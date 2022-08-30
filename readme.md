# Arch Devleopment Container

We set up a arch docker container for development.
Use it as the base for your team to run scripts and commands through it and ensure the same version of TOOLS across your team.

This container heavily relies on the `docker-compose` file, networking, volumes and ports have to be adjusted to work with your projects.

**Do NOT use this setup in production**

## What is provided

I provide a Dockerfile, to set up an Arch Linux Container with a root and regular user with sudo permissions.
We install some basic linux tools and provide a nice cli prompt with `oh-my-zsh`.
For having easy access to the Docker container a script is provided, which launches a new kitty terminal window, connected to the arch-container.

## Requirements

- [kitty terminal](https://github.com/kovidgoyal/kitty) — if you desire an other terminal, the `launch.sh` script has to be adjusted accordingly
- [docker](https://www.docker.com/)
- [docker compose](https://docs.docker.com/compose/install/)

### Recommended
- an installed nerdfont https://www.nerdfonts.com/

## Usage

- adjust the variable values in the Dockerfile to fit your requirements
- run `launch.sh` inside the cloned directory
- hint: if you use this repo as a submodule in your project, ensure that the paths are set up correctly.

## Plans

- [ ] Check dependencies before running the script
- [ ] Prompt user for input to set environment variables like:
  - `container-name`
  - `root-user-password`
  - `user-name`
  - `user-password`
- [ ] prompt for an alias and append it to your shell
- [ ] passalong devenvrionment variables+provide script to show key values of said values
