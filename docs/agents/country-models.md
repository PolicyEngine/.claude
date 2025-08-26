# Country Model Agents

Specialized agents for developing tax and benefit microsimulation models (policyengine-us, policyengine-uk, etc.).

## Agent Descriptions

### 🎭 Supervisor
**File**: `.claude/agents/country-models/supervisor.md`

The orchestrator of the multi-agent workflow. Has full visibility but maintains information barriers between other agents.

**Key Responsibilities**:
- Set up isolated workspaces using git worktrees
- Assign tasks to appropriate agents
- Ensure isolation is maintained
- Create final changelog entry
- Merge work from all agents

### 📚 Document Collector
**File**: `.claude/agents/country-models/document_collector.md`

Gathers authoritative documentation from government sources.

**Source Hierarchy**:
1. Statutes/Laws (e.g., 42 USC § 1382)
2. Regulations (e.g., 7 CFR 273.9)
3. Agency manuals and guidance
4. Official websites (lowest priority)

**Output**: Comprehensive documentation package with citations

### 🔍 Test Creator
**File**: `.claude/agents/country-models/test_creator.md`

Creates integration tests based solely on documentation, without seeing implementation.

**Isolation Rules**:
- ❌ Cannot access `/variables/` or `/parameters/`
- ❌ Cannot see implementation code
- ✅ Only reads documentation package
- ✅ Creates comprehensive test cases

**Output**: YAML test files with expected values and calculation steps

### ⚙️ Rules Engineer
**File**: `.claude/agents/country-models/rules_engineer.md`

Implements rules from documentation without seeing test expectations.

**Isolation Rules**:
- ❌ Cannot access integration test files
- ❌ Cannot see expected test values
- ✅ Reads same documentation as Test Creator
- ✅ Creates own unit tests for development

**Output**: Parameters and variables implementing the rules

### ✅ Rules Reviewer
**File**: `.claude/agents/country-models/rules-reviewer.md`

First point where tests and implementation meet. Validates everything against documentation.

**Validation Checklist**:
- All tests pass
- Implementation matches regulations
- Proper source citations
- Vectorization compliance
- Code quality standards

## Workflow Example

```{mermaid}
sequenceDiagram
    participant S as Supervisor
    participant DC as Document Collector
    participant TC as Test Creator
    participant RE as Rules Engineer
    participant R as Reviewer
    
    S->>DC: Collect SSI documentation
    DC->>S: Returns docs package
    
    par Test Creation
        S->>TC: Create tests from docs
        TC->>TC: Works in isolation
        TC->>S: Returns test files
    and Implementation
        S->>RE: Implement from docs
        RE->>RE: Works in isolation
        RE->>S: Returns code
    end
    
    S->>R: Validate everything
    R->>R: Runs tests, checks docs
    R->>S: Validation report
    
    S->>S: Merge and create PR
```

## Common Patterns

### Vectorization Requirements
```python
# ❌ BAD: Scalar logic
if person("age") >= 65:
    return benefit_amount
else:
    return 0

# ✅ GOOD: Vectorized
return where(
    person("age") >= 65,
    benefit_amount,
    0
)
```

### Source Citations
```python
class ssi_eligible(Variable):
    # ✅ GOOD: Specific regulatory citation
    reference = "https://www.law.cornell.edu/cfr/text/20/416.202"
    
    # ❌ BAD: Vague or missing citation
    reference = "SSA website"
```

### Test Documentation
```yaml
- name: SSI couple both eligible
  absolute_error_margin: 0.01
  period: 2024
  # ✅ GOOD: References regulation
  # Per 20 CFR 416.1163(a), combined countable income
  input:
    people:
      person1:
        ssi_earned_income: 500
      person2:
        ssi_earned_income: 300
  output:
    ssi_combined_income: 800  # $500 + $300
```

## Best Practices

1. **Maintain Isolation**: Don't share information between Test Creator and Rules Engineer
2. **Document Everything**: Every value should trace to a source
3. **Think Edge Cases**: Test Creator should consider boundary conditions
4. **Follow Standards**: Use shared standards document as reference
5. **Trust the Process**: Let Reviewer discover discrepancies