# Isolation Mechanism

Understanding how the multi-agent system maintains isolation between agents.

## The Isolation Principle

```{mermaid}
graph TB
    subgraph "Traditional Development"
        DEV1[Developer sees everything:<br/>✅ Documentation<br/>✅ Tests<br/>✅ Implementation]
    end
    
    subgraph "Multi-Agent Isolation"
        TC[Test Creator sees:<br/>✅ Documentation<br/>❌ Implementation]
        RE[Rules Engineer sees:<br/>✅ Documentation<br/>❌ Test expectations]
    end
    
    style DEV1 fill:#ffebee
    style TC fill:#e1f5fe
    style RE fill:#fff3e0
```

## Why Isolation Matters

### Problem: Implementation Bias

Without isolation, developers often:
- Write code specifically to pass tests
- Miss edge cases not covered by tests  
- Take shortcuts when they know expected values
- Lose sight of actual requirements

### Solution: Independent Interpretation

With isolation:
- Test Creator interprets regulations independently
- Rules Engineer implements based on documentation alone
- Both create their own understanding of requirements
- Discrepancies reveal ambiguities or errors

## Implementation Approaches

### Current: Procedural Isolation

The system currently uses **procedural isolation** through:

1. **Git Worktrees**: Separate directories for each agent
2. **Agent Instructions**: Clear directives not to access other areas
3. **Supervisor Oversight**: Human/AI supervision of the process

```bash
# Each agent works in their own worktree
policyengine-us/         # Main repository
├── pe-docs/            # Document Collector only
├── pe-tests/           # Test Creator only
└── pe-rules/           # Rules Engineer only
```

### Limitations of Current Approach

⚠️ **Not Architecturally Enforced**: Agents could technically access other directories if they:
- Navigate to different worktrees
- Use file reading tools with parent paths
- Ignore their instructions

The isolation depends on agents following their directives, not technical barriers.

## Stronger Enforcement Options

### Option 1: File System Permissions

```bash
# Create separate users for each agent
sudo useradd test_creator
sudo useradd rules_engineer

# Set directory ownership
sudo chown -R test_creator:test_creator pe-tests/
sudo chown -R rules_engineer:rules_engineer pe-rules/

# Restrict access
sudo chmod 700 pe-tests/  # Only test_creator can access
sudo chmod 700 pe-rules/  # Only rules_engineer can access
```

**Pros**: OS-level enforcement  
**Cons**: Complex setup, requires admin rights

### Option 2: Docker Containers

```dockerfile
# Dockerfile.test_creator
FROM ubuntu:latest
WORKDIR /workspace
COPY docs/ /docs/
# No access to implementation files
```

```bash
# Run agents in isolated containers
docker run -v $(pwd)/docs:/docs test_creator
docker run -v $(pwd)/docs:/docs rules_engineer
```

**Pros**: Complete isolation  
**Cons**: Overhead, complex workflow

### Option 3: Git Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit
BRANCH=$(git branch --show-current)
FILES=$(git diff --cached --name-only)

if [[ "$BRANCH" == *"-tests" ]]; then
  if echo "$FILES" | grep -E "variables|parameters"; then
    echo "ERROR: Test branch cannot modify implementation"
    exit 1
  fi
fi
```

**Pros**: Prevents cross-contamination in commits  
**Cons**: Only enforces at commit time

### Option 4: CI/CD Enforcement

```yaml
# .github/workflows/isolation-check.yml
name: Verify Isolation
on: pull_request

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Verify test branch
        if: contains(github.head_ref, '-tests')
        run: |
          # Ensure no implementation files modified
          git diff --name-only origin/main..HEAD | \
            grep -E "variables|parameters" && exit 1 || exit 0
```

**Pros**: Catches violations before merge  
**Cons**: After-the-fact detection

## Current Hook Implementation

The repository includes `claude_code_hook.sh` which attempts to enforce isolation:

```bash
# Detects agent based on working directory
if [[ "$PWD" =~ "pe-.*-tests" ]]; then
    AGENT="Test Creator"
    FORBIDDEN="variables|parameters"
fi

# Blocks access to forbidden paths
check_path_access() {
    if [[ "$1" =~ $FORBIDDEN ]]; then
        echo "❌ Isolation violation!"
        return 1
    fi
}
```

### Hook Limitations

⚠️ **Important**: These hooks only work for shell commands run through bash, not Claude's built-in file tools:

| Action | Hook Can Block? |
|--------|----------------|
| `bash cat file.py` | ✅ Yes |
| `grep pattern file` | ✅ Yes |
| Claude Read tool | ❌ No |
| Claude Edit tool | ❌ No |

## Best Practices for Isolation

### For Human Developers

1. **Physical Separation**: Use different screens/windows for each role
2. **Mental Reset**: Take breaks between switching roles
3. **Documentation Focus**: Always refer back to original sources
4. **No Peeking**: Resist temptation to look at other's work

### For AI Agents

1. **Clear Instructions**: Explicit boundaries in agent prompts
2. **Separate Sessions**: New conversation for each agent role
3. **Supervisor Control**: Human oversees information flow
4. **Audit Trail**: Log all file access attempts

### Process Safeguards

```{mermaid}
graph LR
    A[Documentation] --> B{Supervisor<br/>Checkpoint}
    B --> C[Test Creation]
    B --> D[Implementation]
    C --> E{Supervisor<br/>Review}
    D --> E
    E --> F[Reviewer<br/>Validation]
    F --> G[Final Check]
    
    style B fill:#f5f5f5
    style E fill:#f5f5f5
```

## Verification of Isolation

### How to Verify Isolation is Working

1. **Check Git History**: Each branch should only modify appropriate files
2. **Review Test Comments**: Should reference regulations, not implementation
3. **Review Code Comments**: Should reference regulations, not test values
4. **Cross-validation**: Both test and code interpret same requirement

### Red Flags Indicating Isolation Breach

🚩 Test cases that exactly match implementation edge cases  
🚩 Implementation that handles only tested scenarios  
🚩 Comments referencing the other agent's work  
🚩 Suspiciously perfect alignment without documentation basis

## Future Improvements

### Ideal: Platform-Level Isolation

The ideal solution would be Claude or GitHub providing:
- Role-based access control for AI agents
- Workspace isolation at the platform level
- Audit trails of all access attempts
- Cryptographic proof of isolation

Until then, the procedural approach with human supervision provides a practical balance of isolation and usability.

## Summary

Current isolation is **procedural, not architectural**:
- ✅ Effective when agents follow instructions
- ✅ Provides conceptual separation
- ⚠️ Not technically enforced
- ⚠️ Requires trust and supervision

The value comes from the **process and mindset** of isolated development, even if perfect technical isolation isn't achieved.