#!/usr/bin/env bash
set -e

echo "✅ Updating repos"

PROJECT_PATH="/Users/martinspasov/Dev"

CMD='git checkout master && git pull --ff-only origin master && git gc'


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
