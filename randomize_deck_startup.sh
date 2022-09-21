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
  echo -e ":: ${@}$Color_Off"
}

msg2() {
  echo -e "$Red!!$Color_Off ${@}$Color_Off"
}

DECK_STARTUP_FILE="/home/deck/.steam/steam/steamui/movies/deck_startup.webm"
DECK_LIBRARY_CSS_FILE="/home/deck/.steam/steam/steamui/css/library.css"
DECK_STARTUP_FILE_SIZE=1840847
DECK_STARTUP_STOCK_MD5="4ee82f478313cf74010fc22501b40729"
DECK_STARTUP_SOURCE_FILE_LOCATION="./deck_startup"

check_backup() {
  if [[ ! -f "$DECK_STARTUP_FILE.backup" ]]; then
    checksum="$(md5sum "$DECK_STARTUP_FILE" | cut -d ' ' -f 1)"
    if [[ "$checksum" != "$DECK_STARTUP_STOCK_MD5" ]]; then
      msg2 "deck_startup.webm has already been modified, cannot make a backup"
    else
      msg "Creating backup of initial deck_startup.webm ($checksum)"
      cp "$DECK_STARTUP_FILE" "$DECK_STARTUP_FILE.backup"
    fi
  fi
}

list_animations() {
  find $DECK_STARTUP_SOURCE_FILE_LOCATION -maxdepth 1-type f -size "${DECK_STARTUP_FILE_SIZE}c" -iname '*.webm' -print0
}

random_animation() {
  mapfile -d $'\0' animations < <(list_animations)
  echo "${animations[$RANDOM % ${#animations[@]}]}"
}

replace_css_video() {
  # NEW_CSS MUST be exactly the same length as OLD_CSS
  OLD_CSS="video{flex-grow:0;width:300px;height:300px;z-index:10}"
  NEW_CSS="video{flex-grow:1;width:100%;height:100%;z-index:10}  "
  sed -i.bak -e "s/$OLD_CSS/$NEW_CSS/" $DECK_LIBRARY_CSS_FILE
}

truncate_files() {
  find $DECK_STARTUP_SOURCE_FILE_LOCATION -maxdepth 1 -type f -exec truncate -s ${DECK_STARTUP_FILE_SIZE} {} \; -iname '*.webm'
}

check_backup
truncate_files
replace_css_video
animation="$(random_animation)"
msg "Using $animation"
ln -f "$animation" "$DECK_STARTUP_FILE"

