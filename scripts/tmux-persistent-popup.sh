#!/usr/bin/env bash

## Will resume/open new session based on current directory path
## Reference: https://www.devas.life/how-to-run-claude-code-in-a-tmux-popup-window-with-persistent-sessions/

APP_PATH=$1
APP_NAME=$(basename "$APP_PATH")

[[ ! -f "$APP_PATH" ]] && { echo "${APP_PATH} not found. Setup manually and try again."; exit 0; }

PANE_CURRENT_PATH=$(tmux display-message -p "#{pane_current_path}")
SESSION="{popup}-${APP_NAME}-$(echo "$PANE_CURRENT_PATH" | md5sum | cut -c1-8)"  # {} are lowest in alphabet order

tmux has -t "$SESSION" 2>/dev/null || tmux new -d -s "$SESSION" -c "#{pane_current_path}" "$APP_PATH"
tmux display-popup -w 85% -h 85% -E "tmux attach -t $SESSION"
