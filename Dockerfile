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

RUN install -m 0755 -d /etc/apt/keyrings && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
	chmod a+r /etc/apt/keyrings/docker.asc && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

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
	language-pack-en \
	tzdata \
	ripgrep \
	tmuxinator \
	clangd \
	sudo \
	docker-ce \
	xclip \
	cppcheck \
	cpplint \
	doxygen \
	lcov \
	gdb \
 	ruby-dev \
  	ruby-bundler \
	xz-utils && \
	rm -rf /var/lib/apt/lists/*

RUN update-locale LANG=en_US.UTF-8

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

# Switch to 'robotsix-docker' user
USER robotsix-docker

# Create a python virtual environment activate it
RUN python3 -m venv /home/robotsix-docker/.venv

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

# Copy aider configuration for 'robotsix-docker'
COPY --chown=robotsix-docker conf/aider_config.yml /home/robotsix-docker/.aider.conf.yml

WORKDIR /home/robotsix-docker

