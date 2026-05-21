# Mergify Scoped Merge Queue Test

Simulates the OxIonics/ionics monorepo CI pipeline to validate Mergify's
scoped merge queue before deploying on the real repo.

Contains zero proprietary code. All "tests" are sleep commands.

## Scopes

| Scope | Example paths | Simulated CI time |
|-------|--------------|-------------------|
| core | projects/liboi, projects/ion-transport | ~9 min (static + fast + integration + HITL) |
| standard | projects/orchestrator, projects/controllers | ~4 min (static + fast + integration) |
| light | docs, systems, tooling | ~1.5 min (static + fast) |

## What we're testing

With GitHub's native merge queue, all PRs wait in a single FIFO queue.
A docs PR waits 45+ min behind a liboi PR. Mergify's scoped queues let
each scope merge independently.

## Setup

1. Install Mergify on this repo: https://github.com/apps/mergify
2. Enable branch protection on master requiring "Check status"
3. Create test PRs: `bash .github/scripts/create-test-prs.sh`

## Expected result

All 3 PRs merge independently. The light PR finishes first (~1.5 min),
then standard (~4 min), then core (~9 min). None blocks the others.
