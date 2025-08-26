# Setup Guide

This guide will help you add the PolicyEngine Claude agents to your repository.

## Adding Agents to Your Repository

### Step 1: Add as Submodule

```bash
# Navigate to your repository root
cd /path/to/your/policyengine-repo

# Add the .claude repository as a submodule
git submodule add https://github.com/PolicyEngine/.claude.git .claude

# Commit the changes
git add .gitmodules .claude
git commit -m "feat: Add PolicyEngine Claude agents"
```

### Step 2: Update Submodule (When Needed)

```bash
# Get latest agent updates
git submodule update --remote .claude

# Commit the update
git add .claude
git commit -m "chore: Update Claude agents to latest version"
```

## Setting Up Multi-Agent Workflow

For implementing new programs with the multi-agent system:

### Step 1: Create Isolated Workspaces

```bash
# From your main repository
git worktree add ../pe-program-docs feature/program-docs
git worktree add ../pe-program-tests feature/program-tests  
git worktree add ../pe-program-rules feature/program-rules
```

### Step 2: Assign Agents to Workspaces

Each agent works in their designated directory:

```bash
# Document Collector
cd ../pe-program-docs
# Work with .claude/agents/country-models/document_collector.md

# Test Creator
cd ../pe-program-tests
# Work with .claude/agents/country-models/test_creator.md

# Rules Engineer
cd ../pe-program-rules
# Work with .claude/agents/country-models/rules_engineer.md
```

### Step 3: Maintain Isolation

```{warning}
**Critical**: Test Creator and Rules Engineer must not access each other's work!
```

The system relies on isolation between:
- **Test Creator**: Only sees documents, not implementation
- **Rules Engineer**: Only sees documents, not test expectations

## Directory Structure

After setup, your workspace should look like:

```
YourOrganization/
├── policyengine-us/              # Main repository
│   └── .claude/                  # Submodule (linked to central repo)
│       └── agents/
│           ├── country-models/
│           ├── api/
│           ├── app/
│           └── shared/
├── pe-program-docs/              # Document collection workspace
├── pe-program-tests/             # Test creation workspace
└── pe-program-rules/             # Implementation workspace
```

## Configuration

### For Claude Desktop/CLI

If using Claude directly, reference agents by their path:

```bash
# Use supervisor for orchestration
claude --agent .claude/agents/country-models/supervisor.md

# Use reviewer for PR review
claude --agent .claude/agents/country-models/rules-reviewer.md
```

### For GitHub Copilot/Other AI Tools

Reference the agent instructions when prompting:

```
I want you to act as the Test Creator agent.
Follow the instructions in .claude/agents/country-models/test_creator.md
```

## Workflow Integration

### For New Features

1. **Start with Supervisor**: Let it orchestrate the process
2. **Collect Documentation**: Use Document Collector
3. **Parallel Development**: Test Creator and Rules Engineer work simultaneously
4. **Review**: Rules Reviewer validates everything
5. **Merge**: Supervisor creates final PR

### For Code Review

Simply use the appropriate reviewer:
- **Country Models**: `.claude/agents/country-models/rules-reviewer.md`
- **API**: `.claude/agents/api/api-reviewer.md`
- **App**: `.claude/agents/app/app-reviewer.md`

## Troubleshooting

### Submodule Not Updating

```bash
# Force update to latest
git submodule update --init --recursive --remote

# If that doesn't work, re-clone
rm -rf .claude
git submodule add https://github.com/PolicyEngine/.claude.git .claude
```

### Worktree Conflicts

```bash
# List all worktrees
git worktree list

# Remove old worktree
git worktree remove ../pe-program-tests

# Prune worktree references
git worktree prune
```

### Isolation Violations

If agents accidentally access wrong directories:
1. Check current working directory
2. Verify agent is using correct worktree
3. Review audit logs if hooks are configured
4. Reset and restart from correct workspace

## Best Practices

1. **Regular Updates**: Keep agents updated with `git submodule update --remote`
2. **Clean Workspaces**: Remove worktrees after merging features
3. **Document Sources**: Always provide agents with authoritative documentation
4. **Trust the Process**: Don't bypass isolation for expedience
5. **Review Thoroughly**: Use Rules Reviewer even for small changes