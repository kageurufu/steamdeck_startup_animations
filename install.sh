#!/usr/bin/env bash

OVERRIDES_DIR="$HOME/.steam/root/config/uioverrides"

# Create required directories
echo ":: Creating required directories"
mkdir -p "$HOME/homebrew"
mkdir -p "$HOME/.config/systemd/user"
mkdir -p "$OVERRIDES_DIR"

# Clone the startup animations repository
if [[ ! -d "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Installing to $HOME/homebrew/startup_animations"
  git clone https://github.com/kageurufu/steamdeck_startup_animations "$HOME/homebrew/startup_animations"
  cd "$HOME/homebrew/startup_animations"
else
  echo ":: Updating $HOME/homebrew/startup_animations"
  cd "$HOME/homebrew/startup_animations"
  git pull
fi

# Install the service file
echo ":: Installing the startup service"
ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
systemctl --user daemon-reload
systemctl --user enable --now randomize_deck_startup.service

cd "$OVERRIDES_DIR" && ln -sf ../../../../../homebrew/startup_animations/deck_startup movies
