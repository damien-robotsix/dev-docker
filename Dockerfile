# Use the latest version of Alpine Linux as the base image
FROM alpine:latest

# Install required packages
RUN apk add --no-cache --update\
	curl \ 
	git \ 
	tar \
	unzip \
	zsh \
	shadow \
	fontconfig \
	tmux \
	g++ \
	clang \
	openssl \
	aws-cli \
	npm \
	zsh-vcs \
	tzdata \
	make \
	tar \
	py3-pip \
	py3-virtualenv \
	python3-dev \
	linux-headers \
	xz && \
	echo hosts: files dns > /etc/nsswitch.conf

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
RUN mkdir -p /usr/share/fonts \
	COPY fonts/Hack /usr/share/fonts/Hack
RUN fc-cache -f -v  # Rebuild font cache

# Add a new user 'robotsix-docker'
RUN adduser -D -u 1000 robotsix-docker

# Prepare for Nix installation
RUN mkdir -m 0755 /nix && chown robotsix-docker /nix

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
COPY conf/agnoster-robotsix.zsh-theme /home/robotsix-docker/.oh-my-zsh/custom/themes/agnoster-robotsix.zsh-theme

# Copy zsh configuration for 'robotsix-docker'
COPY conf/.zshrc /home/robotsix-docker/.zshrc

# Copy tmux configuration for 'robotsix-docker'
COPY conf/.tmux.conf /home/robotsix-docker/.tmux.conf

# Copy neovim configuration for 'robotsix-docker'
COPY conf/nvim /home/robotsix-docker/.config/nvim

# Install aider-chat in a virtual environment
RUN python3 -m venv /home/robotsix-docker/.aider && \
	. /home/robotsix-docker/.aider/bin/activate && \
	python -m pip install -U --upgrade-strategy only-if-needed aider-chat && \
	python -m pip cache purge && \
	deactivate

# Switch back to root user
USER root

# Create the GitHub Copilot configuration directory
RUN mkdir -p /home/robotsix-docker/.config/github-copilot

# Ensure everything is owned by 'robotsix-docker'
RUN chown -R robotsix-docker:robotsix-docker /home/robotsix-docker

# Switch to 'robotsix-docker' user and set the working directory
USER robotsix-docker
WORKDIR /home/robotsix-docker