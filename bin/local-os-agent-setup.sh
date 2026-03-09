#!/usr/bin/env bash
# Setup script for OS-level AI Agent configuration
# Creates ~/AGENTS.md (source of truth) and symlinks for Claude, Codex
# Note: Cursor does not support OS-level file configuration - use Settings → Rules instead

set -e  # Exit on error

AGENTS_DIR="$HOME/.agents"
AGENTS_FILE="$HOME/AGENTS.md"

echo "🤖 Setting up OS-level AI Agent configuration..."
echo

# Create .agents directory and subdirectories
for dir in "$AGENTS_DIR" "$AGENTS_DIR/skills" "$AGENTS_DIR/commands"; do
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    echo "✓ Created $dir"
  else
    echo "⊙ $dir already exists"
  fi
done

# Create ~/AGENTS.md if it doesn't exist
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

# ~/CLAUDE.md and ~/CODEX.md symlink to ~/AGENTS.md
create_symlink "$AGENTS_FILE" "$HOME/CLAUDE.md"
create_symlink "$AGENTS_FILE" "$HOME/CODEX.md"

# ~/.claude/skills and ~/.claude/commands symlink to ~/.agents/skills and ~/.agents/commands
create_symlink "$AGENTS_DIR/skills"   "$HOME/.claude/skills"
create_symlink "$AGENTS_DIR/commands" "$HOME/.claude/commands"

# ~/.codex/skills and ~/.codex/commands symlink to ~/.agents/skills and ~/.agents/commands
create_symlink "$AGENTS_DIR/skills"   "$HOME/.codex/skills"
create_symlink "$AGENTS_DIR/commands" "$HOME/.codex/commands"

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
echo "  4. See docs: https://github.com/Invoca/agent-rules/blob/main/.agents/README.md"

Enter to send  •  Shift+Enter for new line  •  Esc to close
