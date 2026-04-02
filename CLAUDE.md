# Generic CC — Claude Code Instructions

## After every `git push`

After any successful `git push` in this repo, post a summary to the **#claude-code** Slack channel (ID: `C0ANNQ1U5EZ`).

The message should include:
- Repo name and branch
- Short SHA and commit message(s) pushed
- A one-line summary of what changed

Use the `mcp__slack__slack_post_message` tool with channel_id `C0ANNQ1U5EZ`.
