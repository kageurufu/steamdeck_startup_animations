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

msg() {
  echo -e ":: ${*}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${*}$Color_Off"
}

DECK_UIOVERRIDES="/home/deck/.steam/root/config/uioverrides"
DECK_UIOVERRIDES_MOVIES="${DECK_UIOVERRIDES}/movies"
DECK_UIOVERRIDES_STARTUP="${DECK_UIOVERRIDES_MOVIES}/deck_startup.webm"

restore_backup() {
  DECK_STARTUP_FILE="/home/deck/.steam/steam/steamui/movies/deck_startup.webm"
  DECK_STARTUP_STOCK_MD5="4ee82f478313cf74010fc22501b40729"

  if [[ -f "$DECK_STARTUP_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_STARTUP_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_STARTUP_STOCK_MD5" ]]; then
      rm "$DECK_STARTUP_FILE"
      mv "$DECK_STARTUP_FILE.backup" "$DECK_STARTUP_FILE"
    fi

    rm "$DECK_STARTUP_FILE.backup"
  fi
}

list_animations() {
  find deck_startup/ -type f -iname '*.webm' -print0
}

random_animation() {
  mapfile -d $'\0' animations < <(list_animations)
  echo "${animations[$RANDOM % ${#animations[@]}]}"
}

restore_backup

animation="$(random_animation)"
msg "Using $animation"
mkdir -p "${DECK_UIOVERRIDES_MOVIES}"
ln -f "$animation" "$DECK_UIOVERRIDES_STARTUP"

