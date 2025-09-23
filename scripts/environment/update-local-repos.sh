#!/usr/bin/env bash
set -e

echo "✅ Updating repos"

PROJECT_PATH="<the_path_to_your_projects>"

CMD='git checkout master && git pull --ff-only origin master && git gc'
CMD_INTEL='git checkout kube-env-mac_intel_chips && git pull --ff-only origin kube-env-mac_intel_chips && git gc'

# wa-kube-environment uses the intel branch
repo="${PROJECT_PATH}/wa-kube-environment"
if [ -d "$repo" ]; then
  echo "📦 $(basename "$repo")"
  (cd "$repo" && eval "$CMD_INTEL")
else
  echo "⚠️  Missing: $repo"
fi

# The rest use master
for r in \
  wa-case-event-handler \
  wa-post-deployment-ft-tests \
  wa-standalone-task-bpmn \
  wa-task-management-api \
  wa-task-monitor \
  wa-workflow-api \
  wa-ccd-definitions \
  ccd-definition-processor \
  wa-task-configuration-template
do
  repo="${PROJECT_PATH}/${r}"
  if [ -d "$repo" ]; then
    echo "📦 $(basename "$repo")"
    (cd "$repo" && eval "$CMD")
  else
    echo "⚠️  Missing: $repo"
  fi
done

echo "✨ Done."
