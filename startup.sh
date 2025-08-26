#!/bin/bash
# Claude Code Startup Hook - Auto-update .claude submodule

echo "🔄 Updating PolicyEngine .claude agents and commands..."

# Save current directory
ORIGINAL_DIR=$(pwd)

# Navigate to .claude directory (works whether called from .claude or parent)
if [ -d ".claude" ]; then
    cd .claude || exit
elif [ -f ".git" ] && [ -d "agents" ]; then
    # We're already in .claude
    :
else
    echo "⚠️ No .claude directory found"
    exit 0
fi

# Update submodule to latest commit on master
git fetch origin master --quiet
git reset --hard origin/master --quiet

if [ $? -eq 0 ]; then
    echo "✅ Successfully updated .claude agents and commands"
    
    # Show what was updated
    LATEST_COMMIT=$(git rev-parse --short HEAD)
    echo "📍 Now at commit: $LATEST_COMMIT"
else
    echo "⚠️ Could not update .claude submodule (may be offline or no changes)"
fi

# Return to original directory
cd "$ORIGINAL_DIR" || exit

echo "🚀 Claude Code ready!"