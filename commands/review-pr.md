---
description: Review and fix issues in an existing PR, addressing GitHub comments
---

# Reviewing PR: $ARGUMENTS

Orchestrate agents to review, validate, and fix issues in PR #$ARGUMENTS, addressing all GitHub review comments.

## Phase 1: PR Analysis
First, gather context about the PR and review comments:

```bash
gh pr view $ARGUMENTS --comments
gh pr checks $ARGUMENTS
gh pr diff $ARGUMENTS
```

Document findings:
- Current CI status
- Review comments to address
- Files changed
- Type of implementation (new program, bug fix, enhancement)

## Phase 2: Enhanced Domain Validation
Run comprehensive validation using specialized agents:

### Step 1: Domain-Specific Validation
Invoke **policy-domain-validator** to check:
- Federal/state jurisdiction separation
- Variable naming conventions and duplicates
- Hard-coded value patterns
- Performance optimization opportunities
- Documentation placement
- PolicyEngine-specific patterns

### Step 2: Reference Validation
Invoke **reference-validator** to verify:
- All parameters have references
- References actually corroborate values
- Federal sources for federal params
- State sources for state params
- Specific citations, not generic links

### Step 3: Implementation Validation
Invoke **implementation-validator** to check:
- No hard-coded values in formulas
- Complete implementations (no TODOs)
- Proper entity usage
- Correct formula patterns

Create a comprehensive checklist:
- [ ] Domain validation issues
- [ ] Reference validation issues
- [ ] Implementation issues
- [ ] Review comments to address
- [ ] CI failures to fix

## Phase 3: Sequential Fix Application
Based on issues found, invoke agents IN ORDER to avoid conflicts.

**Why Sequential**: Unlike initial implementation where we need isolation, PR fixes must be applied sequentially because:
- Each fix builds on the previous one
- Avoids merge conflicts
- Tests need to see the fixed implementation
- Documentation needs to reflect the final code

Apply fixes in priority order:

### Step 1: Fix Domain & Parameter Issues
1. **policy-domain-validator**: Identify all domain violations
2. **parameter-architect**: Extract hard-coded values and design proper structure
3. **rules-engineer**: Refactor implementation to use parameters
4. **reference-validator**: Ensure all new parameters have proper references
5. Commit changes before proceeding

### Step 2: Add Missing Tests
1. **edge-case-generator**: Generate boundary tests based on fixed code
2. **test-creator**: Add integration tests for new parameters
3. Commit test additions

### Step 3: Enhance Documentation
1. **documentation-enricher**: Add examples and references to updated code
2. Commit documentation improvements

### Step 4: Optimize Performance (if needed)
1. **performance-optimizer**: Vectorize and optimize calculations
2. Run tests to ensure no regressions
3. Commit optimizations

### Step 5: Validate Integrations
1. **cross-program-validator**: Check benefit interactions
2. Fix any cliff effects or integration issues found
3. Commit integration fixes

## Phase 4: Apply Fixes
For each issue identified:

1. **Read current implementation**
   ```bash
   git checkout pr/$ARGUMENTS
   ```

2. **Apply agent-generated fixes**
   - Use Edit/MultiEdit for targeted fixes
   - Preserve existing functionality
   - Add only what's needed

3. **Verify fixes locally**
   ```bash
   make test
   make format
   ```

## Phase 5: Address Review Comments
For each GitHub comment:

1. **Parse comment intent**
   - Is it requesting a change?
   - Is it asking for clarification?
   - Is it pointing out an issue?

2. **Generate response**
   - If change requested: Apply fix and confirm
   - If clarification: Add documentation/comment
   - If issue: Fix and explain approach

3. **Post response on GitHub**
   ```bash
   gh pr comment $ARGUMENTS --body "Addressed: [explanation of fix]"
   ```

## Phase 6: CI Validation
Invoke ci-fixer to ensure all checks pass:

1. **Push fixes**
   ```bash
   git add -A
   git commit -m "Address review comments

   - Fixed hard-coded values identified in review
   - Added missing tests for edge cases
   - Enhanced documentation with examples
   - Optimized performance issues
   
   Addresses comments from @reviewer"
   git push
   ```

2. **Monitor CI**
   ```bash
   gh pr checks $ARGUMENTS --watch
   ```

3. **Fix any CI failures**
   - Format issues: `make format`
   - Test failures: Fix with targeted agents
   - Lint issues: Apply corrections

## Phase 7: Final Review & Summary
Invoke rules-reviewer for final validation:
- All comments addressed?
- All tests passing?
- No regressions introduced?

Post summary comment:
```bash
gh pr comment $ARGUMENTS --body "## Summary of Changes

### Issues Addressed
✅ Fixed hard-coded values in [files]
✅ Added parameterization for [values]
✅ Enhanced test coverage (+X tests)
✅ Improved documentation
✅ All CI checks passing

### Review Comments Addressed
- @reviewer1: [Issue] → [Fix applied]
- @reviewer2: [Question] → [Clarification added]

### Ready for Re-Review
All identified issues have been addressed. The implementation now:
- Uses parameters for all configurable values
- Has comprehensive test coverage  
- Includes documentation with examples
- Passes all CI checks"
```

## Command Options

### Quick Fix Mode
`/review-pr $ARGUMENTS --quick`
- Only fix CI failures
- Skip comprehensive review
- Focus on getting checks green

### Deep Review Mode  
`/review-pr $ARGUMENTS --deep`
- Run all validators
- Generate comprehensive tests
- Full documentation enhancement
- Cross-program validation

### Comment Only Mode
`/review-pr $ARGUMENTS --comments-only`
- Only address GitHub review comments
- Skip additional validation
- Faster turnaround

## Success Metrics

The PR is ready when:
- ✅ All CI checks passing
- ✅ All review comments addressed
- ✅ No hard-coded values
- ✅ Comprehensive test coverage
- ✅ Documentation complete
- ✅ No performance issues

## Common Review Patterns

### "Hard-coded value" Comment
1. Identify the value
2. Create parameter with parameter-architect
3. Update implementation with rules-engineer
4. Add test with test-creator

### "Missing test" Comment  
1. Identify the scenario
2. Use edge-case-generator for boundaries
3. Use test-creator for integration tests
4. Verify with implementation-validator

### "Needs documentation" Comment
1. Use documentation-enricher
2. Add calculation examples
3. Add regulatory references
4. Explain edge cases

### "Performance issue" Comment
1. Use performance-optimizer
2. Vectorize operations
3. Remove redundant calculations
4. Test with large datasets

## Error Handling

If agents produce conflicting fixes:
1. Prioritize fixes that address review comments
2. Ensure no regressions
3. Maintain backward compatibility
4. Document any tradeoffs

Start with Phase 1: Analyze PR #$ARGUMENTS and review comments.