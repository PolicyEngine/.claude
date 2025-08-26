---
description: Orchestrates multi-agent workflow to implement new government benefit programs
---

# Implementing $ARGUMENTS in PolicyEngine US

Coordinate the multi-agent workflow to implement $ARGUMENTS:

## Phase 1: Document Collection
Invoke document-collector agent to gather official $ARGUMENTS documentation.

## Phase 2: Parallel Development (SIMULTANEOUS)
After documentation is ready, invoke BOTH agents IN PARALLEL:
- test-creator: Create integration tests from documentation only
- rules-engineer: Implement rules from documentation only

**CRITICAL**: These must run simultaneously in separate conversations to maintain isolation. Neither can see the other's work.

## Phase 3: Review
Invoke rules-reviewer to validate the complete implementation.

## Phase 4: CI Fix & PR Creation
Invoke ci-fixer to:
- Create draft PR
- Monitor CI pipeline
- Fix any failing tests, linting, or formatting issues
- Iterate until all CI checks pass
- Mark PR as ready for review

Start with Phase 1: Use /agents to invoke document-collector for $ARGUMENTS.