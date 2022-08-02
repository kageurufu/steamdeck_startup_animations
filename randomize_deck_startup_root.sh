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

STEAMUI_PATH="/home/deck/.local/share/Steam/steamui"
STEAMUI_LIBRARY_CSS_FILE="${STEAMUI_PATH}/css/library.css"
STEAMUI_LIBRARY_JS_FILE="${STEAMUI_PATH}/library.js"
STEAMUI_SP_JS_FILE="${STEAMUI_PATH}/sp.js"
DECK_STARTUP_FILE="${STEAMUI_PATH}/movies/deck_startup.webm"
DECK_STARTUP_FILE_SIZE=1840847
DECK_STARTUP_STOCK_MD5="4ee82f478313cf74010fc22501b40729"

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
  find . -type f -size "${DECK_STARTUP_FILE_SIZE}c" -iname '*.webm' -print0
}

random_animation() {
  mapfile -d $'\0' animations < <(list_animations)
  echo "$(realpath "${animations[$RANDOM % ${#animations[@]}]}")"
}

try_umount() {
  if grep -q "$1" /etc/mtab; then
    msg2 "Unmounting existing bind on $1"
    umount "$1"
  fi
}

bind_mount() {
  mount -o ro,bind "$1" "$2"
}

patch_library_css() {
  # patch steamui/css/library.css to fullscreen the video
  msg "Patching $STEAMUI_LIBRARY_CSS_FILE"
  try_umount "$STEAMUI_LIBRARY_CSS_FILE"
  sed -E 's/(.steamdeckbootupthrobber_Container_[[:alnum:]]+) video\{flex-grow:0;width:300px;height:300px;z-index:10\}/\1 video{flex-grow:0;width:100%; height:100%; z-index:10}/' "$STEAMUI_LIBRARY_CSS_FILE" > /tmp/patched_library.css
  bind_mount "/tmp/patched_library.css" "$STEAMUI_LIBRARY_CSS_FILE"
}

patch_library_js() {
  msg "Patching $STEAMUI_LIBRARY_JS_FILE"
  try_umount "$STEAMUI_LIBRARY_JS_FILE"
  sed -e 's/return Object(f.y)(i,1e4,\[\])/return Object(f.y)(i,2e4,[])/' "$STEAMUI_LIBRARY_JS_FILE" > /tmp/patched_library.js
  bind_mount "/tmp/patched_library.js" "$STEAMUI_LIBRARY_JS_FILE"
}

randomize_startup_animation() {
  # check_backup
  animation="$(random_animation)"
  msg "Using $animation"
  try_umount "$DECK_STARTUP_FILE"
  bind_mount "$animation" "$DECK_STARTUP_FILE"
}

set -euo pipefail

randomize_startup_animation
patch_library_css
patch_library_js
