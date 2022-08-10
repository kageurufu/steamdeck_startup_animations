#!/usr/bin/env bash

clone_repo() {
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
}

install_user() {
  mkdir -p "$HOME/.config/systemd/user"
   # Install the service file
  echo ":: Installing the startup service"
  ln -sf "$HOME/homebrew/startup_animations/randomize_deck_startup.service" "$HOME/.config/systemd/user/randomize_deck_startup.service"
  systemctl --user daemon-reload
  systemctl --user enable --now randomize_deck_startup.service
}

install_root() {
  # Install the service file
  echo ":: Installing the startup service"
  sudo cp "$HOME/homebrew/startup_animations/service/randomize_deck_startup_root.service" "/etc/systemd/system/randomize_deck_startup.service"
  sudo systemctl daemon-reload
  sudo systemctl enable randomize_deck_startup.service
}


uninstall_user() {
  if [[ -e "$HOME/.config/systemd/user/randomize_deck_startup.service" ]]; then
    echo ":: Removing the boot service"
    systemctl --user disable randomize_deck_startup.service
    rm "$HOME/.config/systemd/user/randomize_deck_startup.service"
  fi
  
  if [[ -f "$HOME/.steam/steam/steamui/movies/deck_startup.webm.backup" ]]; then
    echo ":: Restoring deck_startup.webm.backup"
    rm "$HOME/.steam/steam/steamui/movies/deck_startup.webm"
    mv "$HOME/.steam/steam/steamui/movies/deck_startup.webm.backup" "$HOME/.steam/steam/steamui/movies/deck_startup.webm"
  fi
}

uninstall_root() {
  if [[ -e "/etc/systemd/system/randomize_deck_startup.service" ]]; then
    echo ":: Removing the boot service"
    sudo systemctl disable randomize_deck_startup.service
    sudo rm /etc/systemd/system/randomize_deck_startup.service
  fi
}

delete_repository() {
  if [[ -e "$HOME/homebrew/startup_animations" ]]; then
    echo ":: Deleting the startup_animations directory"
    rm -rf "$HOME/homebrew/startup_animations"
  fi
}

case $1 in
	install|'')
		clone_repo
		uninstall_user
		install_root
		;;
	install-rootless)
		clone_repo
		uninstall_root
		install_user
		;;
	disable)
		uninstall_root
		uninstall_user
		;;
	uninstall)
		uninstall_root
		uninstall_user
		delete_repository
		;;
	*)
		echo "Usage: $0 <install|install-rootless|disable|uninstall>"
		;;
esac
