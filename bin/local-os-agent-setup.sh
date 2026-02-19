#!/usr/bin/env bash
# Setup script for OS-level AI Agent configuration
# Creates ~/.agents/AGENTS.md and symlinks for Claude, Codex, and Gemini
# Note: Cursor does not support OS-level file configuration - use Settings → Rules instead

set -e  # Exit on error

AGENTS_DIR="$HOME/.agents"
AGENTS_FILE="$AGENTS_DIR/AGENTS.md"

echo "🤖 Setting up OS-level AI Agent configuration..."
echo

# Create .agents directory
if [[ ! -d "$AGENTS_DIR" ]]; then
  mkdir -p "$AGENTS_DIR"
  echo "✓ Created $AGENTS_DIR"
else
  echo "⊙ $AGENTS_DIR already exists"
fi

# Create AGENTS.md if it doesn't exist
if [[ ! -f "$AGENTS_FILE" ]]; then
  cat > "$AGENTS_FILE" << 'EOF'
# Agent Rules

Highest priority. Additive to other rules. Defer to project context on conflicts.

## Commit Message Preferences

- Do not use backticks to format code blocks in commit messages.

## Code Quality

- Token efficient: minimize tokens while staying clean, readable, maintainable.
- DRY, OOP, SOLID principles.
- Remove dead code, unused variables, redundant imports.
- Delete comments that don't add value.
- Pass linting and style conventions.
- When refactoring: provide step-by-step plan before showing code. Group changes by theme (DRY refactors, dead code removal, pattern condensing).
EOF
  echo "✓ Created $AGENTS_FILE"
else
  echo "⊙ $AGENTS_FILE already exists"
fi

echo
echo "🔗 Setting up OS-level symlinks..."
echo

# Function to create symlink safely
create_symlink() {
  local source="$1"
  local target="$2"
  local target_dir="$(dirname "$target")"

  # Create target directory if needed
  if [[ ! -d "$target_dir" ]]; then
    mkdir -p "$target_dir"
    echo "  Created directory: $target_dir"
  fi

  # Handle existing file/symlink
  if [[ -L "$target" ]]; then
    local current_target="$(readlink "$target")"
    if [[ "$current_target" == "$source" ]]; then
      echo "⊙ $target already linked correctly"
      return 0
    else
      echo "  Updating symlink: $target"
      rm "$target"
    fi
  elif [[ -e "$target" ]]; then
    echo "  Backing up existing file: $target -> ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -s "$source" "$target"
  echo "✓ Linked $target -> $source"
}

# Create OS-level symlinks (Claude, Codex, Gemini only - Cursor uses GUI)
create_symlink "$AGENTS_FILE" "$HOME/.claude/CLAUDE.md"
create_symlink "$AGENTS_FILE" "$HOME/.codex/CODEX.md"
create_symlink "$AGENTS_FILE" "$HOME/.gemini/GEMINI.md"

echo
echo "✅ OS-level setup complete!"
echo
echo "Next steps:"
echo "  1. Edit $AGENTS_FILE for OS-level preferences"
echo "     (applies to ALL agent interactions across ALL repos on this machine)"
echo "     Keep it minimal - these tokens load into every session!"
echo
echo "  2. For Cursor users: Manually add OS-level rules via Settings → Rules → User Rules"
echo
echo "  3. For repo-level customization, use templates in each repo:"
echo "     cp .agents/USER_RULES.md.example .agents/USER_RULES.md"
echo "     cp .agents/TEAM_RULES.md.example .agents/TEAM_RULES.md"
echo
echo "  4. See docs: https://github.com/dep/agent-rules/blob/main/.agents/README.md"
