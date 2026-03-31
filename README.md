# generic_cc

Shared Claude Code infrastructure for the Hallett Lab. Provides reusable agents, coding rules, and configuration that apply across all lab repositories.

## Authors

- Mike Hallett, Hallett Lab, Western University
- Contact: mike.hallett@uwo.ca

## Why This Repo Exists

Claude Code supports a global configuration layer at `~/.claude/` that applies to every project on your machine. This includes:

- **`~/.claude/agents/`** — agent definitions available in all repos (no need to duplicate per-project)
- **`~/.claude/rules/`** — coding standards and conventions applied everywhere
- **`~/.claude/agent-memory/`** — persistent knowledge that agents accumulate across projects and conversations

The problem is that `~/.claude/` is machine-local — it's not version-controlled or shareable. This repo solves that: it holds the canonical versions of our shared agents and rules, and a setup script symlinks them into `~/.claude/` so they stay in sync via `git pull`.

## What's Included

### Agents (`agents/`)
| Agent | Personality | Purpose |
|-------|-------------|---------|
| **Oracle** | Calm, wise | Cross-project knowledge keeper. Remembers genes, findings, hypotheses, and experimental context. Query it to recall or cross-reference accumulated knowledge. |
| **Blacksmith** | Shoresy (Northern Ontario) | Computational workhorse. Data loading, feature engineering, model training, Streamlit GUIs. Always the first agent invoked for analysis work. |
| **Artist** | Florid, poetic | Visualization specialist. Publication-quality figures, PowerPoint presentations, HTML gallery exhibitions. |
| **Adversary** | Passive-aggressive perfectionist | Scientific skeptic and auditor. Data leakage checks, cross-validation, methodology challenges. Runs after the blacksmith. |
| **Bookworm** | Wholesome, organized | Literature and database specialist. Paper summaries, database queries, Zotero integration, Slack reporting. |

These are **generic** versions of the agents. Project-specific repos can override any agent by placing a customized `.claude/agents/<name>.md` in the project — the project-level version takes priority over the global one.

**Bookworm Zotero tagging**: The bookworm auto-detects the current repo name for Zotero tags. If a project-level bookworm defines a custom `zotero_tag`, that is used. Otherwise it falls back to the git repo name, then to `claude_code`.

### Rules (`rules/`)
| Rule | Purpose |
|------|---------|
| `code-style.md` | Python/R naming conventions, type hints, preferred libraries |
| `data-storage.md` | Data organization in `/data/lab_vm/raw` and `/data/lab_vm/refined` |
| `documentation.md` | README, script header, and versioning requirements |
| `project-structure.md` | Lab repo layout, experiment naming, `src/` conventions |

## Setup

```bash
# 1. Clone the repo
git clone git@github.com:hallettmiket/generic_cc.git ~/repos/generic_cc

# 2. Run the setup script
chmod +x ~/repos/generic_cc/scripts/setup.sh
~/repos/generic_cc/scripts/setup.sh
```

The setup script creates symlinks from `~/.claude/` into this repo. Running it again is safe — it skips existing links.

### What setup does

1. Creates `~/.claude/agents/` and symlinks each agent `.md` file into it
2. Creates `~/.claude/rules/` and symlinks each rule `.md` file into it (skips if a regular file already exists — back up first if you want the symlinked version)
3. Creates `~/.claude/agent-memory/oracle/` with an initial `MEMORY.md` index

After setup, the oracle agent is available in **every repository** on your machine — no per-project configuration needed.

## How It Works: The Architecture

```
~/repos/generic_cc/              <-- this repo (version-controlled, shareable)
  agents/oracle.md
  rules/code-style.md
  rules/data-storage.md
  ...

~/.claude/                       <-- machine-local Claude Code config
  agents/
    oracle.md -> ~/repos/generic_cc/agents/oracle.md    (symlink)
  rules/
    code-style.md -> ~/repos/generic_cc/rules/code-style.md  (symlink)
    ...
  agent-memory/
    oracle/
      MEMORY.md              <-- oracle's persistent knowledge (local, not in git)
      genes_of_interest.md   <-- created by oracle as it learns
      compounds.md
      ...
```

Key points:
- **Agents and rules** are symlinked, so `git pull` updates them everywhere instantly
- **Agent memory** is local to each machine — it's your personal knowledge base, not shared via git
- **No per-project setup required** — global agents work in any repo automatically

## Using the Oracle

The oracle is available in any repository after setup. It maintains a persistent knowledge base in `~/.claude/agent-memory/oracle/` as plain markdown files.

### Remembering findings

When your analysis surfaces something interesting, tell the oracle to remember it:

```
> ask the oracle to remember that ABCB1 is a top efflux transporter
> in our BBB analysis, strongly correlated with BBB- status

> ask the oracle to remember that PIN1 is a drug target for glioblastoma,
> identified in round 2 pharmacophore screening of BBB+ molecules
```

The oracle records: what the finding is, why it matters, which project/experiment it came from, and the date.

### Recalling knowledge

```
> ask the oracle what it knows about efflux transporters

> ask the oracle what genes have been flagged across all projects
```

### Cross-referencing

This is where the oracle shines. Give it a list and it searches for overlaps with everything it has accumulated:

```
> ask the oracle to check these genes against its knowledge:
> ABCB1, TP53, BRCA1, PIN1, SLC6A3

# Oracle responds with:
#   ABCB1 — yes, flagged as top efflux transporter in BBB project
#   PIN1 — yes, target of round 2 pharmacophore screening in BBB project
#   TP53, BRCA1, SLC6A3 — no matches found
```

### Getting a digest

```
> ask the oracle for a summary of all knowledge organized by topic
```

### Browsing the knowledge base directly

The oracle's memory is just files — you can read and edit them:

```bash
ls ~/.claude/agent-memory/oracle/
cat ~/.claude/agent-memory/oracle/genes_of_interest.md
```

## Updating

When shared rules or agents are updated in this repo:

```bash
cd ~/repos/generic_cc
git pull
# Symlinks automatically pick up changes — no re-run needed
```

If **new files** are added to the repo:

```bash
cd ~/repos/generic_cc
git pull
./scripts/setup.sh   # Creates symlinks for new files only
```

## Adding New Agents or Rules

1. Create the `.md` file in `agents/` or `rules/`
2. Commit and push
3. Each lab member runs `./scripts/setup.sh` to pick up the new file

### Agent definition format

Agent `.md` files use YAML frontmatter:

```markdown
---
name: agent-name
description: One-line description of what the agent does
model: sonnet
tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
---

# Agent Name

Instructions for the agent...
```

## Dependencies

- [Claude Code](https://claude.ai/code) CLI installed
- macOS or Linux (uses symlinks)

## License

Internal lab use.
