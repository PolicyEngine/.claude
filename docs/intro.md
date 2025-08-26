# PolicyEngine Claude Agents

Welcome to the PolicyEngine Claude Agents documentation. This system provides specialized AI agents for developing tax and benefit microsimulation models with unprecedented accuracy through isolated development and comprehensive verification.

## Why Multi-Agent Development?

Traditional development approaches often suffer from:
- **Implementation bias**: Developers code to pass tests rather than following regulations
- **Incomplete coverage**: Edge cases missed when one person writes both tests and code  
- **Documentation gaps**: Lack of traceability to authoritative sources
- **Quality issues**: No independent verification of accuracy

Our multi-agent system solves these problems through **development isolation**.

## Core Innovation: Isolated Development

```{mermaid}
graph LR
    A[📚 Documents] --> B[🔍 Document<br/>Collector]
    B --> C[📋 Test<br/>Creator]
    B --> D[⚙️ Rules<br/>Engineer]
    C --> E[✅ Reviewer]
    D --> E
    E --> F[🎯 Accurate<br/>Implementation]
    
    style C fill:#e1f5fe
    style D fill:#fff3e0
    style E fill:#f3e5f5
    
    C -.❌.-> D
```

The key insight: **Test creators never see implementation code, and rules engineers never see test expectations**. Both work from the same authoritative documents, ensuring unbiased validation.

## Quick Start

### For Country Model Development

1. Add the agents to your repository:
```bash
git submodule add https://github.com/PolicyEngine/.claude.git .claude
```

2. Use the supervisor agent to orchestrate development:
```bash
# The supervisor will guide you through setting up isolated development
claude --agent .claude/agents/country-models/supervisor.md
```

### For API or App Development

Use specialized reviewers for your repository type:
- **API**: `.claude/agents/api/api-reviewer.md`
- **React App**: `.claude/agents/app/app-reviewer.md`

## Key Benefits

✅ **Accuracy**: Implementation based directly on regulations, not test expectations  
✅ **Isolation**: Tests and implementation developed separately for unbiased validation  
✅ **Traceability**: Every value traces to primary sources  
✅ **Consistency**: Shared standards across all PolicyEngine repositories  
✅ **Quality**: Multiple validation points catch errors early

## Repository Structure

```
.claude/
├── agents/
│   ├── country-models/     # Tax/benefit model agents
│   ├── api/                # API development agents
│   ├── app/                # React app agents
│   └── shared/             # Shared standards
└── docs/                   # This documentation
```

## Next Steps

- Learn about the [Multi-Agent Workflow](multi-agent-flow.md)
- Explore [Agent Reference](agents/index.md) documentation
- Follow the [Setup Guide](setup.md) for your repository
- Understand [Isolation Mechanisms](isolation.md)