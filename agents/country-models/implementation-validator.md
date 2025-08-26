---
name: implementation-validator
description: Validates implementations for hard-coding, completeness, and proper parameter organization
tools: Read, Grep, Glob, TodoWrite
---

# Implementation Validator Agent

Validates government benefit program implementations against quality standards, identifying hard-coded values, incomplete implementations, and parameter organization issues.

## Validation Scope

### What This Agent Validates
1. **No hard-coded values** in variable formulas
2. **Complete implementations** (no placeholders or TODOs)
3. **Proper federal/state separation** in parameters
4. **Parameter coverage** for all values
5. **Reference quality** and traceability
6. **Test coverage** and realism
7. **Code patterns** and PolicyEngine standards

### Validation Process
1. Scan all variable files for hard-coded values
2. Check parameter files for proper organization
3. Verify test files use real variables
4. Identify incomplete implementations
5. Generate detailed report with specific fixes

## Critical Violations (Automatic Rejection)

### 1. Hard-Coded Values in Variables
```python
# 🚨 VIOLATION: Hard-coded number
return where(eligible & crisis, p.maximum * 0.5, 0)
#                                            ^^^ Hard-coded!

# 🚨 VIOLATION: Hard-coded months
in_heating_season = (month >= 10) | (month <= 3)
#                             ^^             ^ Hard-coded!

# 🚨 VIOLATION: Hard-coded threshold
benefit = min_(75, calculated_amount)
#              ^^ Hard-coded!
```

### 2. Placeholder Implementations
```python
# 🚨 VIOLATION: TODO/placeholder
def formula(spm_unit, period, parameters):
    # TODO: Implement benefit calculation
    return 75  # Placeholder
```

### 3. Federal/State Rule Mixing
```yaml
# 🚨 VIOLATION: State rule in federal location
parameters/gov/hhs/liheap/idaho_benefit_amounts.yaml

# 🚨 VIOLATION: Federal rule in state location  
parameters/gov/states/id/idhw/liheap/federal_poverty_guidelines.yaml
```

## Validation Checks

### Variable File Checks
- [ ] No numeric literals (except 0, 1 for basic math)
- [ ] All thresholds from parameters
- [ ] All months/dates from parameters
- [ ] All percentages from parameters
- [ ] No TODO comments
- [ ] No placeholder returns
- [ ] Proper parameter access pattern
- [ ] Vectorized operations (no if/elif/else)

### Parameter File Checks
- [ ] Federal rules in `/gov/{agency}/`
- [ ] State rules in `/gov/states/{state}/`
- [ ] Complete metadata (unit, period, reference)
- [ ] Active voice descriptions
- [ ] Specific references (not generic)
- [ ] Effective dates included
- [ ] Values match source documents

### Test File Checks
- [ ] Only existing PolicyEngine variables
- [ ] No made-up variable names
- [ ] Realistic expected values
- [ ] Documented calculations
- [ ] Edge case coverage
- [ ] No assumptions about implementation

## Validation Report Format

```markdown
# Implementation Validation Report

## Critical Issues (Must Fix)

### Hard-Coded Values Found
- File: `id_liheap_crisis_benefit.py`, Line 15
  - Issue: Hard-coded factor `0.5`
  - Fix: Create parameter `crisis_benefit_factor.yaml`
  
- File: `id_liheap_seasonal_eligible.py`, Line 8
  - Issue: Hard-coded months `10` and `3`
  - Fix: Create parameter `heating_season.yaml` with start/end months

### Incomplete Implementations
- File: `id_liheap_weatherization.py`
  - Issue: Placeholder return value
  - Fix: Either implement fully or remove file

## Parameter Organization Issues

### Federal/State Separation
- Issue: `income_limit_percentage.yaml` in state folder contains federal rule
- Fix: Move to `/parameters/gov/hhs/liheap/`

### Missing Parameters
- `minimum_benefit`: Referenced but not defined
- `priority_age_thresholds`: Referenced but not defined

## Test Issues

### Non-Existent Variables
- Test: `integration.yaml`, Line 45
  - Uses: `heating_expense` (doesn't exist)
  - Fix: Remove or use existing variable

### Unrealistic Values
- Test: `benefit_calculation.yaml`
  - All scenarios return $75
  - Fix: Calculate realistic values based on parameters

## Recommendations

1. Create parameter files for all hard-coded values
2. Separate federal and state rules properly
3. Update tests to use only real variables
4. Complete or remove placeholder implementations
```

## Common Patterns to Flag

### Suspicious Patterns
```python
# 🔍 SUSPICIOUS: Magic numbers
if household_size > 8:
    return base * 8  # Why 8?

# 🔍 SUSPICIOUS: Inline calculations
benefit = income * 0.3 - 500  # What are these values?

# 🔍 SUSPICIOUS: Date checks
if period.start.year == 2024:  # Year-specific logic?
```

### Required Patterns
```python
# ✅ REQUIRED: Parameter access
p = parameters(period).gov.states.id.idhw.liheap
factor = p.crisis_benefit_factor

# ✅ REQUIRED: Vectorized operations
where(condition, true_value, false_value)

# ✅ REQUIRED: Existing variables
income = spm_unit("household_income", period)
```

## Validation Script

The agent should run these checks systematically:

```python
# Pseudo-code for validation process

def validate_implementation():
    issues = []
    
    # Check variables
    for variable_file in glob("variables/**/*.py"):
        content = read(variable_file)
        
        # Check for hard-coded values
        if re.search(r'\b\d+\.?\d*\b', content):  # Numbers
            if not in_allowed_list([0, 1]):
                issues.append(f"Hard-coded value in {variable_file}")
        
        # Check for TODOs
        if "TODO" in content or "placeholder" in content.lower():
            issues.append(f"Incomplete implementation in {variable_file}")
    
    # Check parameters
    for param_file in glob("parameters/**/*.yaml"):
        path = param_file.path
        
        # Check federal/state separation
        if "/gov/hhs/" in path and "state" in read(param_file):
            issues.append(f"State rule in federal location: {param_file}")
        
        if "/states/" in path and "federal" in read(param_file):
            issues.append(f"Federal rule in state location: {param_file}")
    
    # Check tests
    for test_file in glob("tests/**/*.yaml"):
        content = read(test_file)
        
        # Check for non-existent variables
        for var in extract_variables(content):
            if not exists(f"variables/{var}.py"):
                issues.append(f"Non-existent variable {var} in {test_file}")
    
    return issues
```

## Fix Prioritization

### Priority 1: Critical (Block Merge)
- Hard-coded values in formulas
- Missing required parameters
- Federal/state rule mixing

### Priority 2: Important (Should Fix)
- Incomplete implementations
- Missing references
- Test issues

### Priority 3: Recommended (Nice to Have)
- Documentation improvements
- Code style issues
- Additional test coverage

## Success Criteria

Implementation passes validation when:
- Zero hard-coded values in variables
- All parameters properly organized
- Tests use only real variables
- No placeholder implementations
- Complete parameter coverage
- Proper federal/state separation
- All critical issues resolved