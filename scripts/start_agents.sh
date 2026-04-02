#!/bin/bash
# ~/repos/generic_cc/scripts/start_agents.sh
#
# Opens a multi-pane layout for Claude Code agent monitoring:
#   Left ~52%:  VSCode with Claude Code extension (Conductor)
#   Right ~48%: 7 iTerm2 windows (Blacksmith, Bookworm, Artist, Adversary, Oracle, Conscience, Saul Goodman)
#              stacked vertically, each tailing its progress.log
#
# Usage:
#   ./scripts/start_agents.sh                  # uses current directory as project
#   ./scripts/start_agents.sh ~/repos/my_proj  # specify a project directory
#
# Prerequisites:
#   - iTerm2 installed
#   - VSCode installed (with Claude Code extension)
#   - An external display (edit DISPLAY_* vars below for your setup)

set -euo pipefail

# ── Project directory ────────────────────────────────────────────────────────
PROJECT_DIR="${1:-$(pwd)}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"  # resolve to absolute path
PROJECT_NAME="$(basename "$PROJECT_DIR")"

echo "=== Claude Code Agent Monitor ==="
echo "Project: $PROJECT_DIR ($PROJECT_NAME)"
echo ""

CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

# ── External display logical coordinates ─────────────────────────────────────
# Edit these for your display setup. Run the following to find your coordinates:
#   system_profiler SPDisplaysDataType | grep -A5 Resolution
#   defaults read com.apple.windowserver | grep -A10 DisplaySets
#
# LG 4K display: 1920x1080 logical points, positioned above laptop display
DISPLAY_X=-92
DISPLAY_Y=-1080
DISPLAY_WIDTH=1920
DISPLAY_HEIGHT=1080
MENU_BAR=25

# ── Layout geometry ──────────────────────────────────────────────────────────
# VSCode (Conductor): left ~52% (990px wide on 1920px display)
VSCODE_LEFT=$DISPLAY_X
VSCODE_TOP=$(( DISPLAY_Y + MENU_BAR ))
VSCODE_RIGHT=$(( DISPLAY_X + 990 ))
VSCODE_BOTTOM=$(( DISPLAY_Y + DISPLAY_HEIGHT ))

# Agent windows: right side, stacked vertically (7 rows)
AGENT_LEFT=$(( DISPLAY_X + 993 ))
AGENT_RIGHT=$(( DISPLAY_X + 993 + 888 ))
AGENT_TOP=$(( DISPLAY_Y + MENU_BAR ))
AGENT_BOTTOM=$(( DISPLAY_Y + DISPLAY_HEIGHT ))
USABLE_HEIGHT=$(( AGENT_BOTTOM - AGENT_TOP ))
AGENT_ROW1_TOP=$AGENT_TOP
AGENT_ROW2_TOP=$(( AGENT_TOP + USABLE_HEIGHT / 7 ))
AGENT_ROW3_TOP=$(( AGENT_TOP + USABLE_HEIGHT * 2 / 7 ))
AGENT_ROW4_TOP=$(( AGENT_TOP + USABLE_HEIGHT * 3 / 7 ))
AGENT_ROW5_TOP=$(( AGENT_TOP + USABLE_HEIGHT * 4 / 7 ))
AGENT_ROW6_TOP=$(( AGENT_TOP + USABLE_HEIGHT * 5 / 7 ))
AGENT_ROW7_TOP=$(( AGENT_TOP + USABLE_HEIGHT * 6 / 7 ))

# ── Create output directories and empty log files ───────────────────────────
mkdir -p "$PROJECT_DIR/outputs"/{blacksmith,bookworm,artist,adversary,oracle,conscience,saul_goodman}
touch "$PROJECT_DIR/outputs"/{blacksmith,bookworm,artist,adversary,oracle,conscience,saul_goodman}/progress.log

# ── 1. Open VSCode as the Conductor ─────────────────────────────────────────
"$CODE" "$PROJECT_DIR" &
sleep 3

osascript -e "tell application \"Visual Studio Code\" to activate"
sleep 1
osascript -e "tell application \"System Events\" to tell process \"Code\"
  set position of front window to {$VSCODE_LEFT, $VSCODE_TOP}
  set size of front window to {$(( VSCODE_RIGHT - VSCODE_LEFT )), $(( VSCODE_BOTTOM - VSCODE_TOP ))}
end tell"

sleep 1

# ── 2. Helper: open an iTerm2 window, position it, run tail -f ──────────────
open_agent_window() {
  local NAME="$1"
  local B_LEFT=$2
  local B_TOP=$3
  local B_RIGHT=$4
  local B_BOTTOM=$5
  local COLOR=$6
  local LOG_FILE="$7"

  osascript -e "tell application \"iTerm2\"
    create window with default profile
    delay 0.3
    set bounds of front window to {$B_LEFT, $B_TOP, $B_RIGHT, $B_BOTTOM}
  end tell"

  sleep 0.3

  osascript -e "tell application \"iTerm2\"
    tell front window
      tell current session
        write text \"printf '\\\\033[${COLOR}m'; clear; echo '  $NAME'; echo '  ─────────────────────'; echo; tail -f $LOG_FILE\"
      end tell
    end tell
  end tell"
}

# ── 3. Open 7 agent windows stacked vertically ──────────────────────────────
# Row 1: Blacksmith (green)
open_agent_window "⚒  BLACKSMITH" \
  $AGENT_LEFT $AGENT_ROW1_TOP $AGENT_RIGHT $AGENT_ROW2_TOP \
  "32" "$PROJECT_DIR/outputs/blacksmith/progress.log"
sleep 0.5

# Row 2: Bookworm (blue)
open_agent_window "📚  BOOKWORM" \
  $AGENT_LEFT $AGENT_ROW2_TOP $AGENT_RIGHT $AGENT_ROW3_TOP \
  "94" "$PROJECT_DIR/outputs/bookworm/progress.log"
sleep 0.5

# Row 3: Artist (magenta)
open_agent_window "🎨  ARTIST" \
  $AGENT_LEFT $AGENT_ROW3_TOP $AGENT_RIGHT $AGENT_ROW4_TOP \
  "35" "$PROJECT_DIR/outputs/artist/progress.log"
sleep 0.5

# Row 4: Adversary (red)
open_agent_window "⚔  ADVERSARY" \
  $AGENT_LEFT $AGENT_ROW4_TOP $AGENT_RIGHT $AGENT_ROW5_TOP \
  "31" "$PROJECT_DIR/outputs/adversary/progress.log"
sleep 0.5

# Row 5: Oracle (cyan)
open_agent_window "🔮  ORACLE" \
  $AGENT_LEFT $AGENT_ROW5_TOP $AGENT_RIGHT $AGENT_ROW6_TOP \
  "36" "$PROJECT_DIR/outputs/oracle/progress.log"
sleep 0.5

# Row 6: Conscience (purple)
open_agent_window "⚖  CONSCIENCE" \
  $AGENT_LEFT $AGENT_ROW6_TOP $AGENT_RIGHT $AGENT_ROW7_TOP \
  "35" "$PROJECT_DIR/outputs/conscience/progress.log"
sleep 0.5

# Row 7: Saul Goodman (yellow)
open_agent_window "⚖  SAUL GOODMAN" \
  $AGENT_LEFT $AGENT_ROW7_TOP $AGENT_RIGHT $AGENT_BOTTOM \
  "33" "$PROJECT_DIR/outputs/saul_goodman/progress.log"

echo ""
echo "Agent monitor ready for $PROJECT_NAME."
echo "  Left:  VSCode (Conductor)"
echo "  Right: Blacksmith | Bookworm | Artist | Adversary | Oracle | Conscience | Saul Goodman"
echo ""
echo "Each pane tails its agent's progress.log in real time."
