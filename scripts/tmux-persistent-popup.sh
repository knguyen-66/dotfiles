#!/usr/bin/env bash

## Usage:
## ./tmux-persistent-popup.sh ~/.local/bin/app                           # dir-specific session
## ./tmux-persistent-popup.sh -g ~/.local/bin/app                        # global session
## ./tmux-persistent-popup.sh --global ~/.local/bin/app "some prompt"    # global session with args
## ./tmux-persistent-popup.sh ~/.local/bin/app --resume                  # dir-specific session with args
## ./tmux-persistent-popup.sh htop                                       # app resolved via PATH
## ./tmux-persistent-popup.sh -g btop                                    # global session, app via PATH

## Will resume/open new session based on current directory path
## Reference: https://www.devas.life/how-to-run-claude-code-in-a-tmux-popup-window-with-persistent-sessions/

GLOBAL=false

# Parse optional -g|--global flag
if [[ "$1" == "-g" || "$1" == "--global" ]]; then
    GLOBAL=true
    shift
fi

APP_INPUT=$1
shift
APP_ARGS=("$@")

# Resolve the app: if it's a direct path (contains a slash) use as-is,
# otherwise try to resolve it via PATH using `command -v`.
if [[ "$APP_INPUT" == */* ]]; then
    APP_PATH="$APP_INPUT"
else
    APP_PATH=$(command -v "$APP_INPUT")
    if [[ -z "$APP_PATH" ]]; then
        echo "${APP_INPUT} not found in PATH. Setup manually and try again."
        exit 0
    fi
fi

APP_NAME=$(basename "$APP_PATH")

[[ ! -f "$APP_PATH" ]] && { echo "${APP_PATH} not found. Setup manually and try again."; exit 0; }

PANE_CURRENT_PATH=$(tmux display-message -p "#{pane_current_path}")

if [[ "$GLOBAL" == true ]]; then
    SESSION="{popup}-${APP_NAME}"  # {} are lowest in alphabet order
else
    SESSION="{popup}-${APP_NAME}-$(echo "$PANE_CURRENT_PATH" | md5sum | cut -c1-8)"  # {} are lowest in alphabet order
fi

tmux has -t "$SESSION" 2>/dev/null || tmux new -d -s "$SESSION" -c "$PANE_CURRENT_PATH" "$APP_PATH" "${APP_ARGS[@]}"
tmux display-popup -w 85% -h 85% -E "tmux attach -t $SESSION"
