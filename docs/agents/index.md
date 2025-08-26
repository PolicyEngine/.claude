# Agent Reference

This section provides detailed documentation for each agent in the PolicyEngine system.

## Agent Categories

```{mermaid}
graph TD
    A[PolicyEngine Agents] --> B[Country Models]
    A --> C[API Development]
    A --> D[App Development]
    A --> E[Shared Resources]
    
    B --> B1[Supervisor]
    B --> B2[Document Collector]
    B --> B3[Test Creator]
    B --> B4[Rules Engineer]
    B --> B5[Rules Reviewer]
    
    C --> C1[API Reviewer]
    
    D --> D1[App Reviewer]
    
    E --> E1[Standards]
    E --> E2[Model Evaluator]
    
    style A fill:#f5f5f5
    style B fill:#e8f5e9
    style C fill:#fff3e0
    style D fill:#e1f5fe
    style E fill:#f3e5f5
```

## Choosing the Right Agent

### For New Program Implementation
Use the **country-models** agents with the multi-agent workflow:
1. Start with the Supervisor
2. Follow the isolated development process
3. Use Rules Reviewer for final validation

### For Code Review
- **Country Models**: Use Rules Reviewer for tax/benefit code
- **API**: Use API Reviewer for Flask/backend code
- **React App**: Use App Reviewer for frontend code

### For Standards Reference
All agents reference the shared standards document for:
- Source citation requirements
- Vectorization rules
- Common pitfalls
- Testing best practices

## Quick Links

- [Country Model Agents](country-models.md)
- [API Development](api.md)
- [App Development](app.md)
- [Shared Resources](shared.md)