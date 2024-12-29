# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    tar \
    unzip \
    zsh \
    passwd \
    fontconfig \
    tmux \
    g++ \
    clang \
    openssl \
    awscli \
    npm \
    tzdata \
    make \
    python3-pip \
    python3-venv \
    python3-dev \
    portaudio19-dev \
    libsndfile1 \
    linux-headers-generic \
    alsa-base \
    alsa-utils \
    xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Get latest Neovim
COPY --from=docker.robotsix.net/alpine-neovim:latest /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=docker.robotsix.net/alpine-neovim:latest /usr/local/share/nvim /usr/local/share/nvim
COPY --from=docker.robotsix.net/alpine-neovim:latest /usr/local/lib/nvim /usr/local/lib/nvim

# Install language servers with npm
RUN npm install -g \
	bash-language-server \
	dockerfile-language-server-nodejs \
	yaml-language-server && \
	npm cache clean --force

# Install lua-language-server based on architecture
RUN ARCH=$(uname -m) && \
	if [ "$ARCH" = "x86_64" ]; then \
	curl --connect-timeout 5 --retry 10 -L https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-x64.tar.gz | tar -xz -C /usr/local/bin; \
	elif [ "$ARCH" = "aarch64" ]; then \
	curl --connect-timeout 5 --retry 10 -L https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-arm64.tar.gz | tar -xz -C /usr/local/bin; \
	else \
	echo "Unsupported architecture: $ARCH"; exit 1; \
	fi

# Add Hack Nerd Font
COPY fonts/Hack /usr/share/fonts/Hack
RUN fc-cache -f -v  # Rebuild font cache

# Add a new user 'robotsix-docker'
RUN adduser -D -u 1000 robotsix-docker

# Prepare for Nix installation
RUN mkdir -m 0755 /nix && chown robotsix-docker /nix

# Add robotsix-docker and root to the audio group
RUN addgroup robotsix-docker audio && \
	addgroup root audio

# Switch to 'robotsix-docker' user
USER robotsix-docker

# Install Nix package manager
RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Make zsh the default shell for 'robotsix-docker'
RUN chsh -s /bin/zsh robotsix-docker

# Install oh-my-zsh for 'robotsix-docker'
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
	&& chown -R robotsix-docker:robotsix-docker /home/robotsix-docker/.oh-my-zsh

# Install autosuggestions for zsh
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/robotsix-docker/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install syntax highlighting for zsh
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/robotsix-docker/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Copy custom agnoster theme
COPY --chown=robotsix-docker conf/agnoster-robotsix.zsh-theme /home/robotsix-docker/.oh-my-zsh/custom/themes/agnoster-robotsix.zsh-theme

# Copy zsh configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/.zshrc /home/robotsix-docker/.zshrc

# Copy tmux configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/.tmux.conf /home/robotsix-docker/.tmux.conf

# Copy neovim configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/nvim /home/robotsix-docker/.config/nvim

# Install python packages in a virtual environment
RUN python3 -m venv /home/robotsix-docker/.robotsix-env && \
	. /home/robotsix-docker/.robotsix-env/bin/activate && \
	python -m pip install -U pip && \
	python -m pip -v install aider-chat sounddevice soundfile && \
	python -m pip cache purge && \
	deactivate

# Create the GitHub Copilot configuration directory
RUN mkdir -p /home/robotsix-docker/.config/github-copilot

# Set the working directory
WORKDIR /home/robotsix-docker
