#!/bin/bash
set -euo pipefail

# Creates 3 test PRs (one per scope) to validate Mergify queue lanes.
# Usage: bash .github/scripts/create-test-prs.sh

TIMESTAMP=$(date +%s)

git checkout master
git pull origin master

echo "=== Creating CORE scope PR ==="
git checkout -b "test/core-$TIMESTAMP"
echo "Core test change at $(date)" >> projects/liboi/README.md
git add projects/liboi/README.md
git commit -m "test(core): update liboi"
git push -u origin "test/core-$TIMESTAMP"
gh pr create \
  --title "Test CORE: liboi change" \
  --body "Touches projects/liboi. Should run static + fast + integration + HITL (~9 min)."

echo "=== Creating STANDARD scope PR ==="
git checkout master
git checkout -b "test/standard-$TIMESTAMP"
echo "Standard test change at $(date)" >> projects/orchestrator/README.md
git add projects/orchestrator/README.md
git commit -m "test(standard): update orchestrator"
git push -u origin "test/standard-$TIMESTAMP"
gh pr create \
  --title "Test STANDARD: orchestrator change" \
  --body "Touches projects/orchestrator. Should run static + fast + integration (~4 min)."

echo "=== Creating LIGHT scope PR ==="
git checkout master
git checkout -b "test/light-$TIMESTAMP"
echo "Light test change at $(date)" >> docs/README.md
git add docs/README.md
git commit -m "test(light): update docs"
git push -u origin "test/light-$TIMESTAMP"
gh pr create \
  --title "Test LIGHT: docs change" \
  --body "Touches docs/. Should run static + fast only (~1.5 min)."

git checkout master

echo ""
echo "Created 3 test PRs. Expected behaviour:"
echo "  Light  -> merges in ~1.5 min (independent lane)"
echo "  Standard -> merges in ~4 min (independent lane)"
echo "  Core   -> merges in ~9 min (independent lane)"
echo "  None should block the others."
