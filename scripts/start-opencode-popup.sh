#!/usr/bin/env bash

## Will resume/open new session based on current directory path

OPENCODE_PATH=$HOME/.opencode/bin/opencode

[[ ! -f "$OPENCODE_PATH" ]] && { echo "Opencode not found. Setup manually and try again."; exit 0; }

PANE_CURRENT_PATH=$(tmux display-message -p "#{pane_current_path}")
SESSION=opencode-$(echo "$PANE_CURRENT_PATH" | md5sum | cut -c1-8)

tmux has -t "$SESSION" 2>/dev/null || tmux new -d -s "$SESSION" -c "#{pane_current_path}" "$OPENCODE_PATH"
tmux display-popup -w85% -h85% -E "tmux attach -t $SESSION"
