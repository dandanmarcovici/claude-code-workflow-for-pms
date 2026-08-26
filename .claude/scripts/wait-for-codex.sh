#!/usr/bin/env bash
# Waits for Codex to answer on a PR, emits exactly one line, then exits.
#
# Written to be the `command` of Claude Code's Monitor tool: stdout lines become
# chat notifications, so this stays silent while Codex is thinking and speaks
# once — either because Codex answered, or because the deadline passed. It never
# ends silently: a quiet exit would be indistinguishable from "still waiting".
#
# The point is that nobody has to sit refreshing the PR page. You tag Codex, arm
# this, and go do something else; Claude gets pinged when there is something to
# reconcile and can run /peer-review right then.
#
#   Usage: .claude/scripts/wait-for-codex.sh <pr-number> [timeout-minutes] [since-iso8601]
#
# Codex posts to one of TWO surfaces depending on the outcome:
#   - found nothing   -> an ISSUE comment ("Codex Review: Didn't find any major
#                        issues"), and no review at all
#   - found something -> a REVIEW plus inline comments on the diff, and no
#                        issue comment
# Polling only one surface goes permanently silent in exactly the case that
# matters, so both are checked on every pass.
#
# `since` defaults to now, which is what makes re-tagging after a follow-up push
# work: without it, Codex's previous answer matches immediately and /peer-review
# reconciles a review of the wrong commit.
#
# Codex typically answers in about three minutes, occasionally past four, hence
# 60s polling and a 15min default deadline.
#
# Requires the `gh` CLI, and must run from inside the repo — {owner}/{repo}
# resolves from the git remote.
set -uo pipefail

PR="${1:?usage: wait-for-codex.sh <pr-number> [timeout-minutes] [since-iso8601]}"
TIMEOUT_MIN="${2:-15}"
SINCE="${3:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

BOT="chatgpt-codex"
DEADLINE=$(( $(date +%s) + TIMEOUT_MIN * 60 ))

# Prints a description if Codex has posted on this surface since $SINCE, and
# nothing if it has not. Returns non-zero only when the API call itself failed,
# so the caller can tell "nothing yet" apart from "could not read the PR" —
# `gh api` prints its error body to STDOUT, so without this gate a 404 would be
# mistaken for Codex's answer.
poll_surface() {
  local path="$1" ts_field="$2" label="$3" out
  out=$(gh api "repos/{owner}/{repo}/$path" \
      --jq ".[] | select(.user.login|startswith(\"$BOT\")) | select(.$ts_field > \"$SINCE\") | \"$label (\(.$ts_field))\"" \
      2>/dev/null) || return 1
  printf '%s' "$out" | head -1
  return 0
}

first_pass=1
while :; do
  reachable=0
  a=$(poll_surface "issues/$PR/comments" created_at "summary comment") && reachable=1
  b=$(poll_surface "pulls/$PR/reviews" submitted_at "review with inline findings") && reachable=1
  hit="${a:-$b}"

  if [ -n "$hit" ]; then
    echo "CODEX ANSWERED on PR #$PR — $hit. Run /peer-review $PR."
    exit 0
  fi

  # Fail fast on a typo'd PR number instead of reporting "no answer from Codex"
  # a quarter of an hour later, which would blame the wrong thing. Only on the
  # first pass: after that, a failed call is treated as a transient blip.
  if [ "$first_pass" = 1 ] && [ "$reachable" = 0 ]; then
    echo "CANNOT READ PR #$PR — GitHub rejected both queries. Check the PR number, and that gh is authenticated for this repo."
    exit 1
  fi
  first_pass=0

  if [ "$(date +%s)" -ge "$DEADLINE" ]; then
    echo "NO ANSWER FROM CODEX on PR #$PR after ${TIMEOUT_MIN}min (since $SINCE). Check that the '@codex review' comment was actually posted; if it was, it is just running long."
    exit 0
  fi

  sleep 60
done
