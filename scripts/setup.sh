#!/usr/bin/env bash
#
# Purpose: Install shared Claude Code infrastructure into ~/.claude/
# Author: Hallett Lab
# Date: 2026-03-31
#
# Usage: ./scripts/setup.sh
#
# This script creates symlinks from ~/.claude/ into this repo so that
# shared agents, rules, and skills are available in all projects.
# Running it again is safe — it skips existing links and reports status.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== Hallett Lab Claude Code Setup ==="
echo "Repo:   $REPO_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# ── Helper ──────────────────────────────────────────────────────────
link_file() {
    local src="$1"
    local dst="$2"
    local name
    name="$(basename "$src")"

    if [ -L "$dst" ]; then
        existing_target="$(readlink "$dst")"
        if [ "$existing_target" = "$src" ]; then
            echo "  [ok]   $name (already linked)"
        else
            echo "  [SKIP] $name (symlink exists but points to $existing_target)"
        fi
    elif [ -e "$dst" ]; then
        echo "  [SKIP] $name (regular file exists — back it up manually if you want to replace)"
    else
        ln -s "$src" "$dst"
        echo "  [NEW]  $name -> $src"
    fi
}

# ── 1. Agents ───────────────────────────────────────────────────────
echo "Agents:"
mkdir -p "$CLAUDE_DIR/agents"

for agent_file in "$REPO_DIR"/agents/*.md; do
    [ -f "$agent_file" ] || continue
    link_file "$agent_file" "$CLAUDE_DIR/agents/$(basename "$agent_file")"
done
echo ""

# ── 2. Rules ────────────────────────────────────────────────────────
echo "Rules:"
mkdir -p "$CLAUDE_DIR/rules"

for rule_file in "$REPO_DIR"/rules/*.md; do
    [ -f "$rule_file" ] || continue
    link_file "$rule_file" "$CLAUDE_DIR/rules/$(basename "$rule_file")"
done
echo ""

# ── 3. Skills ───────────────────────────────────────────────────────
if [ -d "$REPO_DIR/skills" ] && [ "$(ls -A "$REPO_DIR/skills" 2>/dev/null)" ]; then
    echo "Skills:"
    mkdir -p "$CLAUDE_DIR/skills"

    for skill_dir in "$REPO_DIR"/skills/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        link_file "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
    done
    echo ""
fi

# ── 4. Agent memory directory ──────────────────────────────────────
echo "Agent memory:"
mkdir -p "$CLAUDE_DIR/agent-memory/oracle"
if [ ! -f "$CLAUDE_DIR/agent-memory/oracle/MEMORY.md" ]; then
    cat > "$CLAUDE_DIR/agent-memory/oracle/MEMORY.md" << 'EOF'
# Oracle Knowledge Base — Master Index

This index tracks all knowledge accumulated by the Oracle across lab projects.
Each entry points to a topic file with full details.

## Topic Files
<!-- Add entries as: - [Title](filename.md) — one-line description -->
EOF
    echo "  [NEW]  oracle/MEMORY.md (initialized)"
else
    echo "  [ok]   oracle/MEMORY.md (already exists)"
fi
echo ""

# ── Done ────────────────────────────────────────────────────────────
echo "=== Setup complete ==="
echo ""
echo "Verify with:"
echo "  ls -la ~/.claude/agents/"
echo "  ls -la ~/.claude/rules/"
echo ""
echo "The oracle agent is now available in all repositories."
echo "Try:  claude 'ask the oracle to remember that TP53 is interesting'"
