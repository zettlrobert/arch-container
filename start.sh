#!/bin/bash

SYSTEM_TERM="$(echo $TERM)";
PATH_TO_TERM="$(whereis "$SYSTEM_TERM")"
SYSTEM_UNAME="$(uname)"

# Output
using_linux="You are using Linux!"
using_mac="You are using Mac"

# echo "Your System Terminal: $SYSTEM_TERM"
# echo "Path: $PATH_TO_TERM"
# echo "System Architectgure: $SYSTEM_UNAME"

# Function to Start new Termnail + pipe docker start command into that new terminal 'as start command'
function startDevContainer () {
  local terminal=${1}
  local command="echo "Hello World""
  echo "startDevContainer with: $1"

  eval "${command} | ${terminal}"
} 

function startDevContainerInKitty () {
  # open remote kitty window running bash
  local openRemoteKitty="kitty @ launch --title dev --keep-focus --type=os-window bash"
  # local showContainer="kitty @ send-text --match title:dev $(docker ps)\\x0d"
  local startContainer="docker compose up -d"
  local enterDev="kitty @ send-text --match title:dev docker exec -it --user mobilehead arch-container /bin/zsh '\n'"

  eval "${openRemoteKitty}"
  # eval "${startContainer}"
  eval "${enterDev}"
  exit
}

if [ "$(uname)"  == "Darwin" ]; then
  echo $using_mac
  # Mac specific definitions

  terminal='
  # Check if brew is avaialabe
  no; exit and tell them to setup there device for work
  yes; continue

  # Install kitty/iterm2 with brew

  # Use kitty/iaterm2 to execute startDevContainer(terminal)
fi

if [ "$(uname)" == "Linux" ]; then
  echo $using_linux
  # Linux specific definitions

  # startDevContainer "kitty"
  startDevContainerInKitty

  # Check for kitty
  # Check gnome-terminal
  # xterm-256color
  # Check for other terminals
  # ==> 
fi

# Open Terminal in new Window

# Start new terminal Linux
# - x-terminal-emulator
# - name of terminal emulator
# - deepin-terminal-gtk

# Start new terminal on mac
