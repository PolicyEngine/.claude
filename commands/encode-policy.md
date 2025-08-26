---
description: Orchestrates multi-agent workflow to implement new government benefit programs
---

# Implementing $ARGUMENTS in PolicyEngine

Coordinate the multi-agent workflow to implement $ARGUMENTS as a complete, production-ready government benefit program.

## Phase 1: Document Collection
Invoke document-collector agent to gather official $ARGUMENTS documentation.

**Quality Gate**: Documentation must include:
- Official program guidelines or state plan
- Income limits and benefit schedules
- Eligibility criteria and priority groups
- Seasonal/temporal rules if applicable

## Phase 2: Parameter Architecture
Invoke parameter-architect agent to design the complete parameter structure.

**Requirements**:
- Separate federal/national rules from state/regional implementations
- Create parameter files for ALL values (no hard-coding allowed)
- Include proper references and metadata
- Design for maintainability and updates

**Quality Gate**: Parameter architecture review before proceeding

## Phase 3: Parallel Development (SIMULTANEOUS)
After parameter architecture is approved, invoke BOTH agents IN PARALLEL:
- test-creator: Create integration tests from documentation and parameter architecture
- rules-engineer: Implement rules using the parameter architecture

**CRITICAL**: These must run simultaneously in separate conversations to maintain isolation. Neither can see the other's work.

**Quality Requirements**:
- rules-engineer: ZERO hard-coded values, complete implementations only
- test-creator: Use only existing PolicyEngine variables, test realistic calculations

## Phase 4: Implementation Validation
Invoke implementation-validator agent to check for:
- Hard-coded values in variables
- Placeholder or incomplete implementations
- Federal/state parameter organization
- Test quality and coverage

**Quality Gate**: Must pass ALL critical validations before proceeding

## Phase 5: Review
Invoke rules-reviewer to validate the complete implementation against documentation.

**Review Criteria**:
- Accuracy to source documents
- Complete coverage of all rules
- Proper parameter usage
- Edge case handling

## Phase 6: CI Fix & PR Creation
Invoke ci-fixer to:
- Create draft PR with complete implementation
- Monitor CI pipeline for failures
- Fix any failing tests, linting, or formatting issues
- Address parameter validation errors
- Iterate until all CI checks pass
- Mark PR as ready for review

**Success Metrics**:
- All CI checks passing
- Zero hard-coded values
- Complete test coverage
- Proper documentation

## Expected Review Cycles

### Current Paradigm (Single Reviewer)
- **Initial Review**: 3-5 comments on hard-coding, parameters, organization
- **Second Review**: 1-2 comments on missed edge cases
- **Third Review**: Minor documentation updates
- **Total**: 3 review cycles, 4-8 total comments

### With Enhanced Agents (This Workflow)
- **Initial Review**: 0-1 comments on edge cases or documentation
- **Total**: 1 review cycle, 0-2 total comments

### Alternative: Multiple Specialized Reviewers
**Option A: Domain Expert + Code Quality**
- Domain Expert: Validates accuracy to regulations (1-2 comments)
- Code Reviewer: Checks patterns and style (1-2 comments)
- **Total**: 1-2 review cycles, 2-4 total comments

**Option B: Full Review Board**
- Parameter Reviewer: Validates all parameters against sources (0-1 comments)
- Test Reviewer: Checks test coverage and realism (0-1 comments)
- Implementation Reviewer: Validates formula accuracy (0-1 comments)
- Integration Reviewer: Checks cross-program interactions (0-1 comments)
- **Total**: 1 review cycle, 0-4 total comments (parallel reviews)

## Anti-Patterns This Workflow Prevents

1. **Hard-coded values**: Parameter architect designs everything upfront
2. **Incomplete implementations**: Validator catches before PR
3. **Federal/state mixing**: Architecture phase prevents this
4. **Non-existent variables in tests**: Test creator trained on real variables
5. **Placeholder code**: Validator rejects incomplete work
6. **Poor documentation**: Required at every phase

## Start Implementation

Begin with Phase 1: Use Task tool to invoke document-collector agent for $ARGUMENTS.

Then proceed through each phase, ensuring quality gates are met before advancing.