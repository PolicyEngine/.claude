#!/bin/bash
# Protection script to prevent editing .claude when it's a submodule

# Check if we're in a submodule (presence of .git file instead of directory)
if [ -f ".git" ]; then
    echo "⚠️  ERROR: You're trying to edit .claude as a submodule!"
    echo ""
    echo "The .claude directory is a submodule that should only be modified in the main repository:"
    echo "https://github.com/PolicyEngine/.claude"
    echo ""
    echo "To make changes:"
    echo "1. Clone the main repository: git clone https://github.com/PolicyEngine/.claude"
    echo "2. Make your changes there"
    echo "3. Push to the main repository"
    echo "4. Update this submodule with: git submodule update --remote"
    echo ""
    exit 1
fi

# If not a submodule, allow the operation
exit 0