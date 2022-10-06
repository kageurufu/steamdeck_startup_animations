#!/usr/bin/env bash

if [[ -e "$HOME/.config/systemd/user/randomize_deck_startup.service" ]]; then
  echo ":: Removing the boot service"
  systemctl --user disable randomize_deck_startup.service
  rm "$HOME/.config/systemd/user/randomize_deck_startup.service"
fi

if [[ -d "$HOME/.steam/root/config/uioverrides" ]]; then
  if [[ -L "$HOME/.steam/root/config/uioverrides/movies" ]]; then
    echo ":: Removing link to replacement animations directory"
    rm "$HOME/.steam/root/config/uioverrides/movies"
  fi
fi

if [[ -e "$HOME/homebrew/startup_animations" ]]; then
  echo ":: Deleting the startup_animations directory"
  rm -rf "$HOME/homebrew/startup_animations"
fi

