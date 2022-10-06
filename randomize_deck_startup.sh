#!/usr/bin/env bash

Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

DECK_STARTUP_FILE="$HOME/homebrew/startup_animations/deck_startup/deck_startup.webm"

msg() {
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

list_animations() {
  cd deck_startup && find . -type f -iname '*.webm' -print0
}

random_animation() {
  mapfile -d $'\0' animations < <(list_animations)
  echo "${animations[$RANDOM % ${#animations[@]}]}"
}

animation="$(random_animation)"
msg "Using $animation"
cd deck_startup && ln -sf "$animation" "$DECK_STARTUP_FILE"
