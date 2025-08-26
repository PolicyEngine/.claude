# Shared Resources

Common standards and tools used across all PolicyEngine agents.

## PolicyEngine Standards

**File**: `.claude/agents/shared/policyengine-standards.md`

Core standards that all agents reference for consistency across the PolicyEngine ecosystem.

### Source Hierarchy

```{mermaid}
graph TD
    A[Primary Sources] --> A1[Statutes/Laws]
    A --> A2[Regulations]
    B[Secondary Sources] --> B1[Agency Manuals]
    B --> B2[Official Guidance]
    C[Tertiary Sources] --> C1[Government Websites]
    C --> C2[Calculators]
    
    A1 --> P[Most Authoritative]
    A2 --> P
    C2 --> L[Least Authoritative]
    
    style A fill:#e8f5e9
    style B fill:#fff3e0
    style C fill:#ffebee
```

### Vectorization Rules

PolicyEngine uses NumPy arrays for all calculations to handle millions of households efficiently.

✅ **Required Patterns**
```python
# Good: Vectorized operations
from policyengine_us.model_api import *

class benefit_amount(Variable):
    def formula(person, period, parameters):
        age = person("age", period)
        income = person("employment_income", period)
        
        # Vectorized conditions
        eligible = (age >= 65) & (income < 20_000)
        
        return where(
            eligible,
            1_000,  # Benefit amount if eligible
            0       # No benefit if not eligible
        )
```

❌ **Forbidden Patterns**
```python
# Bad: Scalar if-elif-else
if age >= 65:
    if income < 20_000:
        return 1_000
    else:
        return 500
else:
    return 0

# Bad: Using .any() for conditions
if (age >= 65).any():  # Never do this!
    return 1_000
```

### Common Pitfalls

| Pitfall | Bad Example | Good Example |
|---------|------------|--------------|
| Hardcoded values | `return 1000` | `p.benefit.amount` |
| Missing thousands separator | `20000` | `20_000` |
| Scalar logic | `if x > y:` | `where(x > y, ...)` |
| Using max/min | `max(x, 0)` | `max_(x, 0)` |
| Chain comparisons | `18 <= age <= 65` | `(age >= 18) & (age <= 65)` |
| Missing defined_for | N/A | `defined_for = StateCode.CA` |

### Testing Standards

✅ **YAML Test Format**
```yaml
- name: Descriptive test name
  absolute_error_margin: 0.01
  period: 2024
  input:
    people:
      person1:
        age: 67
        employment_income: 15_000  # Always use underscores
    households:
      household1:
        members: [person1]
        state_code: CA
  output:
    # Document the calculation
    # $15,000 income, over 65 → eligible per 42 USC § 1382
    ssi: 914.00  # Always include decimals for money
```

### Documentation Requirements

Every implementation must include:

1. **Variable Reference**
   ```python
   reference = "https://www.law.cornell.edu/uscode/text/26/32"
   ```

2. **Parameter Metadata**
   ```yaml
   description: EITC phase-out threshold
   reference:
     title: 26 USC § 32(b)(2)
     href: https://www.law.cornell.edu/uscode/text/26/32
   ```

3. **Test Documentation**
   ```yaml
   # Calculation per 20 CFR 416.1130:
   # Earned income: $500
   # Less general exclusion: -$20
   # Less earned exclusion: -$65  
   # Countable: $415
   ```

## Model Evaluator

**File**: `.claude/agents/shared/model-evaluator.md`

Agent for evaluating model outputs and comparing against external sources.

### Evaluation Criteria

```{mermaid}
graph LR
    A[Model Output] --> B{Evaluation}
    B --> C[Accuracy]
    B --> D[Coverage]
    B --> E[Performance]
    
    C --> C1[Compare to IRS Stats]
    C --> C2[Match Gov Calculators]
    C --> C3[Validate Edge Cases]
    
    D --> D1[All Demographics]
    D --> D2[All States]
    D --> D3[All Programs]
    
    E --> E1[Runtime Speed]
    E --> E2[Memory Usage]
    E --> E3[Scalability]
    
    style B fill:#f5f5f5
    style C fill:#e8f5e9
    style D fill:#e1f5fe
    style E fill:#fff3e0
```

### Validation Methods

1. **Against Official Calculators**
   - IRS withholding calculator
   - SSA benefit calculators
   - State tax calculators

2. **Against Published Statistics**
   - IRS Statistics of Income
   - Census data
   - Program participation rates

3. **Cross-Model Validation**
   - Compare US vs UK approaches
   - Check similar programs
   - Validate shared components

### Common Validation Issues

| Issue | How to Detect | How to Fix |
|-------|---------------|------------|
| Wrong tax rates | Compare to IRS tables | Update parameters |
| Missing deductions | Check total deductions | Add missing variables |
| Edge case errors | Test boundary values | Fix formula logic |
| State differences | Compare state by state | Add state-specific logic |

## Development Workflows

### Adding a New Program

```{mermaid}
stateDiagram-v2
    [*] --> Documentation
    Documentation --> TestCreation: In isolation
    Documentation --> Implementation: In isolation
    TestCreation --> Review
    Implementation --> Review
    Review --> Validation
    Validation --> Integration
    Integration --> [*]
```

### Reviewing a PR

```{mermaid}
stateDiagram-v2
    [*] --> CheckSources: Sources cited?
    CheckSources --> CheckVectorization: Vectorized?
    CheckSources --> RequestSources: No
    RequestSources --> CheckSources: Added
    CheckVectorization --> CheckTests: Tests comprehensive?
    CheckVectorization --> RequestFix: No
    RequestFix --> CheckVectorization: Fixed
    CheckTests --> CheckStandards: Follows standards?
    CheckTests --> RequestTests: No
    RequestTests --> CheckTests: Added
    CheckStandards --> Approve: Yes
    CheckStandards --> RequestChanges: No
    RequestChanges --> CheckStandards: Fixed
    Approve --> [*]
```

## Quick Reference

### Import Requirements
```python
from policyengine_us.model_api import *
import numpy as np
from numpy import where, max_ as max_, min_ as min_
```

### Variable Template
```python
class variable_name(Variable):
    value_type = float
    entity = Person  # or TaxUnit, Family, Household
    label = "Human-readable name"
    unit = USD
    definition_period = YEAR  # or MONTH
    reference = "https://law.cornell.edu/..."
    
    def formula(person, period, parameters):
        p = parameters(period).gov.program
        # Implementation here
        return result
```

### Parameter Template
```yaml
description: Parameter description
values:
  2024-01-01: 1_000
  2023-01-01: 900
reference:
  title: 26 USC § 32
  href: https://www.law.cornell.edu/uscode/text/26/32
unit: USD
```