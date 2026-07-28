#!/usr/bin/env bash

set -euo pipefail

KUBE_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT_ROOT="${PROVIDE_YOUR_PROJECT_PATH:-$(cd "${KUBE_ENV_DIR}/.." && pwd)}"

printf -v KUBE_ENV_DIR_Q '%q' "$KUBE_ENV_DIR"

open_iterm_pane() {
  local title="$1"
  local command="$2"

  if [[ "${WA_REPOSITORIES_DRY_RUN:-false}" == "true" ]]; then
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

repository_command() {
  local repository="$1"
  local run_command="$2"
  local repository_dir="${PROJECT_ROOT}/${repository}"
  local repository_dir_q

  if [[ ! -d "$repository_dir" ]]; then
    echo "Cannot find ${repository} at ${repository_dir}." >&2
    return 1
  fi

  printf -v repository_dir_q '%q' "$repository_dir"
  echo "source ~/.zprofile; cd ${KUBE_ENV_DIR_Q}; source scripts/environment/activate-local-databases.sh; cd ${repository_dir_q}; ${run_command}"
}

ask_to_start() {
  local repository="$1"
  local run_command="$2"
  local answer
  local command

  read -r -p "Would you like to run ${repository} (y/n)?: " answer
  if [[ "$answer" == "y" ]]; then
    command="$(repository_command "$repository" "$run_command")"
    open_iterm_pane "$repository" "$command"
  fi
}

if [[ "${WA_REPOSITORIES_DRY_RUN:-false}" != "true" ]]; then
  open -a iTerm
fi

echo "Starting wa-workflow-api..."
open_iterm_pane \
  "wa-workflow-api" \
  "$(repository_command "wa-workflow-api" "./gradlew clean bootRun")"

ask_to_start \
  "wa-task-management-api" \
  "export SPRING_PROFILES_ACTIVE=replica; ./gradlew clean bootRun --args='--replication.subscriptionUrl=postgresql://ccd-shared-database:5432'"

ask_to_start \
  "wa-task-monitor" \
  "./gradlew clean bootRun"

ask_to_start \
  "wa-case-event-handler" \
  "export AZURE_SERVICE_BUS_FEATURE_TOGGLE=true; export AZURE_SERVICE_BUS_DLQ_FEATURE_TOGGLE=true; ./gradlew clean bootRun"

ask_to_start \
  "wa-post-deployment-ft-tests" \
  "export AZURE_SERVICE_BUS_FEATURE_TOGGLE=false; export AZURE_SERVICE_BUS_DLQ_FEATURE_TOGGLE=false; ./gradlew clean functional --info"

echo "Requested WA repositories have been started in iTerm panes."
