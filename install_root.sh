#!/usr/bin/env bash

# Create required directories
echo ":: Creating required directories"
mkdir -p "$HOME/homebrew"

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
sudo cp "$HOME/homebrew/startup_animations/service/randomize_deck_startup_root.service" "/etc/systemd/system/randomize_deck_startup.service"
sudo systemctl daemon-reload
sudo systemctl enable randomize_deck_startup.service

