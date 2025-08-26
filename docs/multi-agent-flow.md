# Multi-Agent Workflow

The multi-agent system ensures accurate implementation of tax and benefit rules through isolated development and comprehensive verification.

## The Five-Agent System

```{mermaid}
flowchart TB
    subgraph Phase1["📚 Documentation Phase"]
        DC[Document Collector]
        DOCS[(Authoritative<br/>Documents)]
        DC -->|Gathers| DOCS
    end
    
    subgraph Phase2["🔨 Development Phase"]
        subgraph Isolated1["🔒 Isolation Zone 1"]
            TC[Test Creator]
            TESTS[(Integration<br/>Tests)]
            TC -->|Creates| TESTS
        end
        
        subgraph Isolated2["🔒 Isolation Zone 2"]
            RE[Rules Engineer]
            CODE[(Implementation<br/>Code)]
            RE -->|Implements| CODE
        end
        
        DOCS -->|Reads| TC
        DOCS -->|Reads| RE
    end
    
    subgraph Phase3["✅ Verification Phase"]
        REV[Reviewer]
        TESTS -->|Validates| REV
        CODE -->|Validates| REV
        DOCS -->|Cross-checks| REV
        REV -->|Produces| RESULT[Verified<br/>Implementation]
    end
    
    subgraph Orchestration["🎭 Orchestration"]
        SUP[Supervisor]
    end
    
    SUP -.->|Manages| DC
    SUP -.->|Manages| TC
    SUP -.->|Manages| RE
    SUP -.->|Manages| REV
    
    style Phase1 fill:#e8f5e9
    style Phase2 fill:#fff3e0
    style Phase3 fill:#f3e5f5
    style Isolated1 fill:#e1f5fe
    style Isolated2 fill:#ffebee
    style Orchestration fill:#f5f5f5
```

## Agent Roles

### 1. 🎭 Supervisor
**Role**: Orchestrates the entire process  
**Access**: Full visibility (but doesn't share between agents)  
**Responsibilities**:
- Sets up isolated workspaces
- Manages information flow
- Ensures isolation is maintained
- Creates final changelog

### 2. 📚 Document Collector
**Role**: Gathers authoritative sources  
**Access**: Documentation only  
**Responsibilities**:
- Finds statutes, regulations, and manuals
- Creates comprehensive documentation package
- Prioritizes primary sources over secondary

### 3. 🔍 Test Creator
**Role**: Creates integration tests from documentation  
**Access**: Documents only (no implementation code)  
**Responsibilities**:
- Writes comprehensive test cases
- Documents expected calculations
- Never sees how it will be implemented

### 4. ⚙️ Rules Engineer
**Role**: Implements rules from documentation  
**Access**: Documents only (no test expectations)  
**Responsibilities**:
- Creates parameters and variables
- Implements calculation logic
- Writes own unit tests for development

### 5. ✅ Reviewer
**Role**: Validates everything matches documentation  
**Access**: Everything (first point of convergence)  
**Responsibilities**:
- Runs all tests
- Verifies documentation compliance
- Ensures code quality standards

## Isolation Implementation

### Git Worktrees Approach

```bash
# Create isolated workspaces for each agent
git worktree add ../pe-program-docs feature/program-docs
git worktree add ../pe-program-tests feature/program-tests
git worktree add ../pe-program-rules feature/program-rules

# Each agent works in their designated worktree
cd ../pe-program-tests  # Test Creator works here
cd ../pe-program-rules  # Rules Engineer works here
```

### Directory Structure

```
PolicyEngine/
├── policyengine-us/          # Main repository
├── pe-program-docs/          # Document Collector workspace
├── pe-program-tests/         # Test Creator workspace
└── pe-program-rules/         # Rules Engineer workspace
```

## Information Barriers

```{mermaid}
graph TB
    subgraph Documents
        D[Statutes<br/>Regulations<br/>Manuals]
    end
    
    subgraph "Test Creator View"
        TC[Can See:<br/>✅ Documents<br/>❌ Implementation<br/>❌ Parameters]
    end
    
    subgraph "Rules Engineer View"  
        RE[Can See:<br/>✅ Documents<br/>❌ Test Expectations<br/>❌ Integration Tests]
    end
    
    subgraph "Reviewer View"
        R[Can See:<br/>✅ Everything]
    end
    
    D --> TC
    D --> RE
    TC --> R
    RE --> R
    
    style Documents fill:#e8f5e9
    style TC fill:#e1f5fe
    style RE fill:#ffebee
    style R fill:#f3e5f5
```

## Process Timeline

```{mermaid}
gantt
    title Multi-Agent Development Timeline
    dateFormat X
    axisFormat %s
    
    section Documentation
    Document Collection     :done, doc, 0, 2
    
    section Development
    Test Creation          :active, test, 2, 4
    Rules Implementation   :active, impl, 2, 4
    
    section Verification
    Review & Validation    :rev, 4, 5
    
    section Finalization
    Integration           :int, 5, 6
```

## Benefits of Isolation

### 1. **Unbiased Implementation**
Rules engineers can't "code to the test" because they never see test expectations. They must implement based solely on documentation.

### 2. **Complete Test Coverage**
Test creators think of edge cases independently, not influenced by implementation limitations.

### 3. **Double Validation**
Both tests and implementation independently interpret the same documentation, catching ambiguities.

### 4. **Audit Trail**
Complete record of who had access to what information at each stage.

## Example Workflow

Here's how the system works for implementing a new benefit program:

1. **Supervisor** creates isolated workspaces and assigns agents
2. **Document Collector** gathers:
   - Federal statute (42 USC § 1382)
   - Regulations (20 CFR 416)
   - SSA program manual
3. **Test Creator** (in isolation) creates tests for:
   - Basic eligibility
   - Income calculations
   - Edge cases from regulations
4. **Rules Engineer** (in isolation) implements:
   - Eligibility parameters
   - Calculation variables
   - Unit tests for development
5. **Reviewer** validates:
   - All tests pass
   - Implementation matches documentation
   - Code quality standards met
6. **Supervisor** merges everything and creates PR

## Key Success Factors

✅ **Strict Isolation**: Agents must not communicate during development  
✅ **Same Sources**: Both test creator and engineer use identical documentation  
✅ **No Peeking**: Resist temptation to look at the other's work  
✅ **Trust Process**: Let reviewer discover any discrepancies  
✅ **Document Everything**: Maintain clear audit trail