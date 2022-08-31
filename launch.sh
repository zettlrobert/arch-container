#!/bin/bash
# Output
not_supported="Your architecture is currently not supported by this script"

arg1=$1

# Initialize Start Variable
declare LAUNCH
declare DARWIN
declare LINUX

# Function to check if tools are availalbe
commandExists() {
	commandToTest="$1"

	if ! command -v "${commandToTest}" &>/dev/null; then
		echo -e "[CHECK]: FAIL\t\t ""${commandToTest}"" required but it's not installed. Aborting."
		exit 1
	fi

	echo -e "[CHECK]: OK\t\t ${commandToTest} exists, continue"
	return 0
}

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

	# rebuild image and recreate container
	local rebuildImage="docker compose build --no-cache --progress auto"

	# enter the running container
	# TODO: pass in user prompt variables
	local enterContainer="docker exec -it --user mobilehead arch-container /bin/zsh"

	# launch new kitty terminal and execute enterContainer command
	assembleKittyLaunchCommand "${enterContainer}"

	if [[ ${arg1} == "--new" ]]; then
		until (eval "${rebuildImage}"); do sleep 1; done
		eval "${LAUNCH}"
		exit 0
	fi

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
		echo "[SYSTEM]: Mac/Darwin"
	fi
	return 0
}

checkForLinux() {
	if [[ "$(uname)" == "Linux" ]]; then
		LINUX=true
		echo -e "[SYSTEM]: Linux"
	fi
}

# Execution
inferSystemEnvrionment() {
	checkForDarwin
	checkForLinux
	# Check prerequesites, script will exit if not availalbe.
	commandExists kitty
	commandExists docker
}

# Mac only functionality
startOnDarwin() {
	startDevContainerInKitty
}

# Linux - Sweet Home
startOnLinux() {
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
