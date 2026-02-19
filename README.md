# Agent Rules

A centralized repository for launching Claude Code with shared rules, prompts, templates, and skills.

## Syncing Shared Rules to Other Repos

This repository is the single source of truth for shared commands, skills, and protocol. Consuming repos (like Titan and web) use the `agent-sync` script to handle fetching and updating.

### 1. Clone this repo into your `~/dev` directory (or your preferred directory)

```bash
cd ~/dev
git clone https://github.com/dep/agent-rules.git
```

### 2. Run `agent-sync` in the consuming repo

Prerequisites: `jq` and `gh` CLI (both standard for developers).

```bash
cd ~/dev/<your-repo>
../agent-rules/bin/agent-sync
```

You can optionally add the following flags to the `agent-sync` command:

- `--local` to force local source only (offline mode)
- `--dry-run` to show what would change without writing
- `--check` to exit 1 if anything is out of date (CI mode)

### 3. Commit the results

After running `agent-sync`, commit the results to your repo.

> **Note**: This script adds a new file to your repo: `.agents/REPO_RULES.md`. You can add your repo-specific rules and conventions to this file. Your repository's root-level `AGENTS.md` points to it automatically — no further setup needed.

## Customization Options

The `agent-sync` script creates `.agents/REPO_RULES.md` for repository-specific rules. Additionally, you can create optional custom context files:

- **`.agents/USER_RULES.md`** - Personal AI preferences (gitignored)
- **`.agents/TEAM_RULES.md`** - Team conventions (gitignored)
- **`.agents/LEARNING_LOG.md`** - Agent-maintained learning log (gitignored, opt-in)

See [`.agents/README.md`](.agents/README.md) for details on the custom context system.

## Agent Rules Structure

### Repository Structure

```text
agent-rules/
├── .agents/                                # Source of truth for commands and skills
│   ├── commands/                           # Commands for Claude Code, Cursor, and Codex
│   ├── skills/                             # Skills for Claude Code, Cursor, and Codex
│   ├── README.md                           # Custom context system documentation (synced to repos)
│   ├── *_RULES.md.example                  # Templates for user/team customization
├── .claude/                                # REDIRECTS to `.agents`, avoid editing these files directly
│   ├── commands/                           # symlinks (redirects) to `.agents/commands`
│   ├── skills/                             # symlinks (redirects) to `.agents/skills`
├── .cursor/                                # REDIRECTS to `.agents`, avoid editing these files directly
│   ├── commands/                           # symlinks (redirects) to `.agents/commands`
│   ├── skills/                             # symlinks (redirects) to `.agents/skills`
├── .codex/                                 # REDIRECTS to `.agents`, avoid editing these files directly
│   ├── commands/                           # symlinks (redirects) to `.agents/commands`
│   ├── skills/                             # symlinks (redirects) to `.agents/skills`
├── bin/                                    # agent-rules related scripts
│   ├── agent-sync                          # Sync script for consuming repos
│   └── local-os-agent-setup.sh             # OS-level setup script
├── .mcp.json                               # MCP server configuration
├── .gitignore                              # Git ignore rules
├── AGENTS.md                               # Agent System Instructions (source of truth)
├── CLAUDE.md                               # symlinks (redirects) to `AGENTS.md`
├── CURSOR.md                               # symlinks (redirects) to `AGENTS.md`
├── CODEX.md                                # symlinks (redirects) to `AGENTS.md`
├── README.md                               # This file
```

**USE THE `.agents` DIRECTORY**: You must place custom skills and commands in the `.agents` directory to ensure that all LLM tools can access them. Do not edit the `.claude`, `.cursor`, or `.codex` directories directly. This rule applies to both this repo and your consuming repos.

## Contributing

### Adding a New Skill

A skill is something you can teach Claude Code, Cursor, or Codex to do, and it will invoke them organically.

1. Create a directory in `.agents/skills`
2. Create a `SKILL.md` file in the directory with the following format:

   ```markdown
   ---
   name: <skill-name>
   version: <version>
   description: <description>
   ---

   <the actual instructions for the skill>
   ```

3. Once a skill is in `agent-rules` mainline, you can use it in any consuming repo by running `../agent-rules/bin/agent-sync` in the consuming repo to sync the changes

### Adding a New Command

A command is essentially a custom `/COMMAND` you can invoke manually.

1. Create a `.md` file in `.agents/commands`
2. Follow the format of an existing command file
3. Once a command is in `agent-rules` mainline, you can use it in any consuming repo by running `../agent-rules/bin/agent-sync` in the consuming repo to sync the changes
4. You should then be able to invoke the command by typing `/COMMAND` in your editor, and it will execute the command.

---

### Contribution Best Practices

- Keep skills and commands focused and single-purpose
- Include a version number, for skills in the metadata section of the file, and for commands in the H1 of the file
- Increment the version number when you make changes to an existingskill or command
- Include context and constraints explicitly
- Use clear, descriptive names
- Document any assumptions or prerequisites
- It's always best to "dogfood" your own commands and skills before promoting them into this library

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)
# agent-rules
