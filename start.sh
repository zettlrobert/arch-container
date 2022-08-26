#!/bin/bash

SYSTEM_TERM="$(echo $TERM)";
PATH_TO_TERM="$(whereis "$SYSTEM_TERM")"
SYSTEM_UNAME="$(uname)"

# Output
using_linux="You are using Linux!"
using_mac="You are using Mac"

# Initialize Start Variable
declare LAUNCH

function assembleKittyLaunchCommand () {
  local command=$1
  local startNewKitty="kitty -e --detach --hold zsh -c '${command}; ${SHELL}'"
  START_COMMAND=${startNewKitty}
  return 0
}

function startDevContainerInKitty () {
  # start/build the container with docker compose
  local startDevContainer="docker compose up -d"

  # enter the running container
  local enterContainer="docker exec -it --user mobilehead arch-container /bin/zsh"

  # launch new kitty terminal and execute enterContainer command
  assembleKittyLaunchCommand "${enterContainer}"

  # Wait until container is started/build before proceeding
  until (eval "${startDevContainer}"); do sleep 1; done; 

  # Launch a new terminal window singedinto the container
  eval "${LAUNCH}"
  exit 0
}

if [ "$(uname)"  == "Darwin" ]; then
  echo $using_mac
  # Test if kitty is availalbe
  # Install kitty
fi

if [ "$(uname)" == "Linux" ]; then
  echo $using_linux
  # Check if kitty is availalabe
  startDevContainerInKitty
fi

# TODO - Optional
# Ask user if image should be rebuild
# Share variables to configure docker and the script
