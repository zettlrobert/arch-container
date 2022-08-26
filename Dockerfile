FROM archlinux:latest

RUN pacman -Syy --noconfirm

# Build Variables
# pass from env file
ARG USER_NAME="mobilehead"
ARG USER_PASSWORD="password"
ARG ROOT_PASSWORD="root"

# Set password for root user add to wheel group
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Update System
RUN pacman -Syyu --noconfirm

# Install packages
RUN pacman -Sy\
    curl\
    zsh \ 
    sudo \
    bash \
    curl \ 
    ripgrep \
    exa \
    figlet \ 
    findutils \
    git \
    base-devel \
    openssh \
    sed \
    bat \
    vim \
    tealdeer \
    --noconfirm

# Add mobilehead user
RUN useradd -m -p ${USER_PASSWORD} ${USER_NAME}

# Update password for ${USER_NAME}
RUN echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# Give newly created user root privileges
RUN usermod -aG wheel ${USER_NAME} 

# Allow members of the wheel group to use root privileges 
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers

# Setup workdir for user
WORKDIR /home/${USER_NAME}

# Run future commands as `${USER_NAME}` and not root
USER ${USER_NAME}

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set oh-my-zsh theme
ARG OH_MY_ZSH_THEME="af-magic"
RUN sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"${OH_MY_ZSH_THEME}\"/g ~/.zshrc

# Insxtall useful oh-my-zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ARG ZSH_PLUGINS="git, zsh-autosuggestions, zsh-syntax-highlighting"
RUN sed -ie "/plugins=(git)/d" ~/.zshrc
RUN echo "plugins=($ZSH_PLUGINS)" >> ~/.zshrc

# Install yay arch user repository helper with github generated binaries
RUN echo ${USER_PASSWORD} | sudo -S git clone https://aur.archlinux.org/yay-bin.git /opt/yay-bin
RUN echo ${USER_PASSWORD} | sudo -S chown -R ${USER_NAME}:${USER_NAME} /opt/yay-bin
RUN cd /opt/yay-bin && makepkg -s 
RUN echo "${USER_PASSWORD}" | sudo -S pacman -U /opt/yay-bin/yay-bin-*.pkg.tar.zst --noconfirm

# Jguer/yay configuration 
# generate development package database for *-git packages that were installed withnout yay
RUN yay -Y --gendb

# Check for updates regarding development packages
RUN echo "${USER_PASSWORD}" | sudo -S yay -Syu --devel --noconfirm

# Enalbe development package update permanently when running yay
RUN yay -Y --devel --save --noconfirm

# aliases
RUN echo "alias ls='exa'" >> ~/.zshrc
RUN echo "alias lsa='exa --icons --long -a --group --header --bytes'" >> ~/.zshrc
RUN echo "alias tree='exa --icons -T'" >> ~/.zshrc
RUN echo "alias gl='git log --oneline --graph'"
RUN echo "alias gl1='git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all'"
RUN echo "alias gl2='git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all'"

RUN echo "DEV-CONTAINER" | figlet
