#!/usr/bin/env bash

# Create required directories
mkdir -p "$HOME/homebrew"
mkdir -p "$HOME/.config/systemd/user"

# Clone the startup animations repository
if [[ ! -d "$HOME/homebrew/startup_animations" ]]; then
  git clone https://github.com/kageurufu/steamdeck_startup_animations "$HOME/homebrew/startup_animations"
fi

# Install the service file
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_startup.service

