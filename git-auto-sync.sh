#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit

while inotifywait -r -e modify,close_write,move,create .; do
    sleep 5
    # Stage only changed or new files
    git add -u
    git add .

    # Only commit if there are staged changes
    if ! git diff --cached --quiet; then
        git commit -m "Auto update $(date '+%Y-%m-%d %H:%M:%S')"
        git push origin main
    else
        echo "No changes to commit."
    fi
done
