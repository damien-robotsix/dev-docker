#!/bin/bash

# Check if the shell_gpt configuration directory exists
if [ ! -d "$HOME/.config/shell_gpt" ]; then
    # Run the sgpt integration installation
    sgpt --install-integration
fi

# Execute the command passed to the entrypoint
exec "$@"
