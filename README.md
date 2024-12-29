# Dev-Docker

## Overview

Dev-Docker is a Docker-based development environment tailored for terminal-based coding. It includes essential tools such as Zsh, Neovim, and Aider to enhance your coding experience.

## Features

- **Zsh**: A powerful shell with advanced features and customization options.
- **Neovim**: A modern text editor that is an extension of Vim, designed for efficient coding.
- **Aider**: A tool to assist with coding tasks and improve productivity.

## Getting Started

### Prerequisites

- Ensure you have Docker installed on your system. You can download it from [Docker's official website](https://www.docker.com/products/docker-desktop).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dev-docker.git
   cd dev-docker
   ```

2. Build the Docker image:
   ```bash
   docker build -t dev-docker .
   ```

3. Run the Docker container using Docker Compose:
   ```bash
   docker-compose up -d
   ```

### Customization

- **Volumes**: Customize the `compose.yml` file to mount your project directory or other necessary volumes. For example, change the line:
  ```yaml
  - .:/home/robotsix-docker/docker-dev
  ```
  to point to your specific project directory.

## Usage

Once inside the container, you can start using Zsh and Neovim for your development tasks. Customize your environment as needed by editing the configuration files located in the `conf` directory.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for more details.

## Contact

For any questions or feedback, please contact [your email or contact information].
