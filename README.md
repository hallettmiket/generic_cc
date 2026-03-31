# generic_cc

Shared Claude Code infrastructure for the Hallett Lab. Provides reusable agents, coding rules, and configuration that apply across all lab repositories.

## Authors

- Mike Hallett, Hallett Lab, Western University
- Contact: mike.hallett@uwo.ca

## What's Included

### Agents (`agents/`)
| Agent | Purpose |
|-------|---------|
| **Oracle** | Cross-project knowledge keeper. Remembers genes, findings, hypotheses, and experimental context. Query it to recall or cross-reference accumulated knowledge across all lab projects. |

### Rules (`rules/`)
| Rule | Purpose |
|------|---------|
| `code-style.md` | Python/R naming conventions, type hints, preferred libraries |
| `data-storage.md` | Data organization in /data/lab_vm/raw and /data/lab_vm/refined |
| `documentation.md` | README, script header, and versioning requirements |
| `project-structure.md` | Lab repo layout, experiment naming, src/ conventions |

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

- Links `agents/*.md` into `~/.claude/agents/` (available in all repos)
- Links `rules/*.md` into `~/.claude/rules/` (applied in all repos)
- Creates `~/.claude/agent-memory/oracle/` with an initial index

## Using the Oracle

The oracle is available in any repository after setup. Examples:

```bash
# Remember a finding
> ask the oracle to remember that ABCB1 is a top efflux transporter
> in our BBB analysis, strongly correlated with BBB- status

# Recall knowledge
> ask the oracle what it knows about efflux transporters

# Cross-reference a gene list
> ask the oracle to check these genes against its knowledge:
> ABCB1, TP53, BRCA1, PIN1, SLC6A3

# Get a summary
> ask the oracle for a digest of all genes of interest across projects
```

The oracle stores its knowledge in `~/.claude/agent-memory/oracle/` as plain markdown files. These are human-readable and can be edited directly.

## Updating

When shared rules or agents are updated:

```bash
cd ~/repos/generic_cc
git pull
# Symlinks automatically pick up changes — no re-run needed
```

If new files are added to the repo:

```bash
cd ~/repos/generic_cc
git pull
./scripts/setup.sh   # Creates symlinks for new files only
```

## Adding New Agents or Rules

1. Create the `.md` file in `agents/` or `rules/`
2. Commit and push
3. Each lab member runs `./scripts/setup.sh` to pick up the new file

## Dependencies

- [Claude Code](https://claude.ai/code) CLI installed
- macOS or Linux (uses symlinks)

## License

Internal lab use.
