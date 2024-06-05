#!/bin/bash

# Check if config file exists, download it if not
if [ ! -f ~/.config/code-server/config.yaml ]; then
  read -p "Config not found! Download? (y/n) " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
    echo "Downloading..."
    curl -o ~/.config/code-server/config.yaml https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/configs/code-server/config.yaml
  else
    echo "Skipping..."
    exit 1
  fi
else
  echo "Config found! Skipping..."
fi

# Check if code-server command is available, install it if not
if ! command -v code-server &> /dev/null; then
  read -p "Code-server not found! Download? (y/n) " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
    echo "Downloading..."
    curl -fsSL https://code-server.dev/install.sh | sh
  else
    echo "Skipping..."
    exit 1
  fi
else
  echo "Code-server found! Skipping..."
fi

# Create a tmux window called "code-session" and run code-server inside it
tmux kill-session -t "code-session" || true
tmux new-session -d -s "code-session" 
tmux send-keys -t "code-session" 'code-server' Enter
echo "Created code-session!"