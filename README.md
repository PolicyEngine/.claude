# PolicyEngine Claude Agents

Specialized AI agents for developing tax and benefit microsimulation models with unprecedented accuracy through isolated development and comprehensive verification.

## 📚 Documentation

Full documentation is available at: https://policyengine.github.io/.claude/

## 🚀 Quick Start

Add these agents to your PolicyEngine repository:

```bash
git submodule add https://github.com/PolicyEngine/.claude.git .claude
```

## 🤖 Available Agents

### Country Model Development
- **Supervisor** - Orchestrates multi-agent workflow
- **Document Collector** - Gathers authoritative sources
- **Test Creator** - Creates tests in isolation
- **Rules Engineer** - Implements rules in isolation  
- **Rules Reviewer** - Validates implementation

### API Development
- **API Reviewer** - Reviews Flask/backend code

### App Development
- **App Reviewer** - Reviews React/frontend code

## 🔑 Key Innovation: Isolated Development

The multi-agent system ensures tests and implementation are developed in complete isolation:
- Test creators never see implementation code
- Rules engineers never see test expectations
- Both work from the same authoritative documents
- Only the reviewer sees everything after development

This prevents implementation bias and ensures accuracy based on regulations, not test expectations.

## 📖 Documentation Setup

To build the documentation locally:

```bash
pip install -r docs/requirements.txt
jupyter-book build docs
```

To enable GitHub Pages:
1. Go to Settings → Pages in this repository
2. Set Source to "GitHub Actions"
3. The documentation will auto-deploy on push to master

## 🔗 Integration

The agents are used across all PolicyEngine country packages:
- [policyengine-us](https://github.com/PolicyEngine/policyengine-us)
- [policyengine-uk](https://github.com/PolicyEngine/policyengine-uk)
- [policyengine-canada](https://github.com/PolicyEngine/policyengine-canada)
- [policyengine-il](https://github.com/PolicyEngine/policyengine-il)
- [policyengine-ng](https://github.com/PolicyEngine/policyengine-ng)

## 📝 License

This repository is part of the PolicyEngine project. See LICENSE for details.

## License

Code in this repository is released under the [MIT License](LICENSE). Original text and figures are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) with attribution to PolicyEngine. Third-party data and materials keep their own terms.
