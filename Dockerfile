ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

ENV TZ=US \
	DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	curl && \
	rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x > setup.sh && \
	chmod +x setup.sh && \
	./setup.sh && \
	rm setup.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
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
	nodejs \
	tzdata \
	make \
	python3-pip \
	openssh-client \
	lsb-release \
	gnupg \
	python3-venv \
	python3-dev \
	portaudio19-dev \
	libsndfile1 \
	linux-headers-generic \
	alsa-base \
	alsa-utils \
	language-pack-en \
	tzdata \
	ripgrep \
	tmuxinator \
	clangd \
	sudo \
	xz-utils && \
	rm -rf /var/lib/apt/lists/*

RUN update-locale LANG=en_US.UTF-8

# Download and extract the latest Neovim nightly build
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
	tar xzvf nvim-linux64.tar.gz -C /usr/local --strip-components=1 && \
	rm nvim-linux64.tar.gz

# Install language servers and playwright with npm
RUN npm install -g \
	playwright \
	bash-language-server \
	dockerfile-language-server-nodejs \
	yaml-language-server && \
	npm cache clean --force

# Install lua-language-server based on architecture
RUN ARCH=$(uname -m) && \
	if [ "$ARCH" = "x86_64" ]; then \
	curl --connect-timeout 5 --retry 10 -L https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-x64.tar.gz | tar -xz -C /usr/local; \
	elif [ "$ARCH" = "aarch64" ]; then \
	curl --connect-timeout 5 --retry 10 -L https://github.com/LuaLS/lua-language-server/releases/download/3.13.5/lua-language-server-3.13.5-linux-arm64.tar.gz | tar -xz -C /usr/local; \
	else \
	echo "Unsupported architecture: $ARCH"; exit 1; \
	fi
# Allow /usr/local/log to be written to by all users
RUN mkdir /usr/local/log && chmod 777 /usr/local/log

# Add Hack Nerd Font
COPY fonts/Hack /usr/share/fonts/Hack
RUN fc-cache -f -v  # Rebuild font cache

# Check if 'ubuntu' user exists; if so, rename it. Otherwise, create 'robotsix-docker' user.
RUN if id -u ubuntu >/dev/null 2>&1; then \
	usermod -l robotsix-docker ubuntu && \
	usermod -d /home/robotsix-docker -m robotsix-docker && \
	groupmod -n robotsix-docker ubuntu; \
	else \
	useradd -m -u 1000 robotsix-docker; \
	fi && \
	chsh -s /bin/zsh robotsix-docker

# Prepare for Nix installation
RUN mkdir -m 0755 /nix && chown robotsix-docker /nix

# Add robotsix-docker and root to the audio group
# Add robotsix-docker to sudoers
RUN usermod -a -G audio robotsix-docker && usermod -a -G audio root && \
	usermod -a -G sudo robotsix-docker && \
	echo "robotsix-docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to 'robotsix-docker' user
USER robotsix-docker

# Install Nix package manager
RUN bash -c "$(curl -L https://nixos.org/nix/install)" --no-daemon

# Install oh-my-zsh for 'robotsix-docker'
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
	&& chown -R robotsix-docker:robotsix-docker /home/robotsix-docker/.oh-my-zsh

# Install autosuggestions for zsh
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/robotsix-docker/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install syntax highlighting for zsh
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/robotsix-docker/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Copy custom agnoster theme
COPY --chown=robotsix-docker conf/agnoster-robotsix.zsh-theme /home/robotsix-docker/.oh-my-zsh/custom/themes/agnoster-robotsix.zsh-theme

# Install python packages in a virtual environment
RUN python3 -m venv /home/robotsix-docker/.robotsix-env && \
	. /home/robotsix-docker/.robotsix-env/bin/activate && \
	python -m pip install -U pip && \
	python -m pip -v install aider-chat sounddevice soundfile playwright shell-gpt && \
	python -m playwright install chromium && \
	python -m pip cache purge && \
	deactivate

# Copy zsh configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/.zshrc /home/robotsix-docker/.zshrc

# Copy tmux configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/.tmux.conf /home/robotsix-docker/.tmux.conf

# Copy neovim configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/nvim /home/robotsix-docker/.config/nvim

# Create the GitHub Copilot configuration directory
RUN mkdir -p /home/robotsix-docker/.config/github-copilot

# Copy aider configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/aider_config.yml /home/robotsix-docker/.aider.conf.yml

# Copy shell_gpt configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/shell_gpt /home/robotsix-docker/.config/shell_gpt

WORKDIR /home/robotsix-docker

