#!/usr/bin/env bash

set -euo pipefail

KUBE_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
printf -v KUBE_ENV_DIR_Q '%q' "$KUBE_ENV_DIR"

open_iterm_pane() {
  local title="$1"
  local command="$2"

  if [[ "${HOST_SETUP_DRY_RUN:-false}" == "true" ]]; then
    echo "[${title}] ${command}"
    return
  fi

  osascript - "$title" "$command" <<'APPLESCRIPT'
on run argv
  set paneTitle to item 1 of argv
  set shellCommand to item 2 of argv

  tell application "iTerm" to activate
  delay 0.5
  tell application "System Events"
    tell process "iTerm"
      keystroke "d" using {command down, shift down}
      delay 0.5
      keystroke "i" using command down
      keystroke paneTitle
      key code 53
      keystroke shellCommand
      key code 52
    end tell
  end tell
end run
APPLESCRIPT
}

run_with_confirmation() {
  local title="$1"
  local command="$2"
  local answer

  while true; do
    open_iterm_pane "$title" "$command"
    echo "${title} is running in a separate iTerm pane."

    while true; do
      read -r -p "Did ${title} complete successfully? (y=continue, r=retry, a=abort): " answer
      case "$answer" in
        y|Y)
          return
          ;;
        r|R)
          echo "Retrying ${title} in a new iTerm pane..."
          break
          ;;
        a|A)
          echo "Aborted after ${title}." >&2
          exit 1
          ;;
        *)
          echo "Please enter y, r, or a."
          ;;
      esac
    done
  done
}

if [[ "${HOST_SETUP_DRY_RUN:-false}" != "true" ]]; then
  open -a iTerm
fi

run_with_confirmation \
  "Kube setup and DMN scripts" \
  "source ~/.zprofile; cd ${KUBE_ENV_DIR_Q}; source scripts/environment/activate-local-databases.sh; cd scripts; ./setup.sh"

run_with_confirmation \
  "WA CCD definitions upload" \
  "source ~/.zprofile; cd ${KUBE_ENV_DIR_Q}; ./scripts/environment/upload-wa-definitions-no-admin.sh"

echo "Host setup stages were confirmed successfully."
