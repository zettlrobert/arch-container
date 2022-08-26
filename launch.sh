#!/bin/bash
# Output
using_linux="You are using Linux!"
using_mac="You are using Mac"
not_supported="Your architecture is currently not supported by this script"

# Initialize Start Variable
declare LAUNCH
declare DARWIN
declare LINUX

# Assemble the kitty launch command
function assembleKittyLaunchCommand() {
	local command=$1

    if [[ -n ${LINUX} ]]; then
	  local startNewKitty="kitty -e --detach --hold zsh -c '${command}; ${SHELL}'"
    fi

    if [[ -n ${DARWIN} ]]; then
	  local startNewKitty="kitty -e --hold zsh -c '${command}; ${SHELL}' &disown"
    fi
    
	LAUNCH=${startNewKitty}
	return 0
}

function startDevContainerInKitty() {
	# start/build the container with docker compose
	local startDevContainer="docker compose up -d"

	# enter the running container
	local enterContainer="docker exec -it --user mobilehead arch-container /bin/zsh"

	# launch new kitty terminal and execute enterContainer command
	assembleKittyLaunchCommand "${enterContainer}"

	# Wait until container is started/build before proceeding
	until (eval "${startDevContainer}"); do sleep 1; done

	# Launch a new terminal window singedinto the container
	eval "${LAUNCH}"
	exit 0
}

# Shell funtion to check for mac
checkForDarwin() {
	if [[ "$(uname)" == "Darwin" ]]; then
		DARWIN=true
		echo "${using_mac}"
		echo "Will be implemented soon..."
	fi
	return 0
}

checkForLinux() {
	if [[ "$(uname)" == "Linux" ]]; then
		LINUX=true
		echo "${using_linux}"
	fi
}

inferSystemEnvrionment() {
	checkForDarwin
	checkForLinux
}

# Mac only functionality
startOnDarwin() {
	echo "${using_mac}"
	startDevContainerInKitty
}

# Linux - Sweet Home
startOnLinux() {
	echo "${using_linux}"
	startDevContainerInKitty
}

launch() {
    inferSystemEnvrionment
	if [[ -n ${LINUX} ]]; then
		startOnLinux
		return 0
	fi

	if [[ -n ${DARWIN} ]]; then
		startOnDarwin
		return 0
	fi

	echo "${not_supported}"
	return 1
}
launch

# TODO - Optional
# Ask user if image should be rebuild
# Share variables to configure docker and the script
