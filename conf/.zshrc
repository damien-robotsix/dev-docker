export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster-robotsix"

CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

clean_and_open_debug() {
  # Ensure the argument (input file) is provided
  if [[ -z "$1" ]]; then
    echo "Usage: clean_and_open_debug <file>"
    return 1
  fi

  # Create a temporary file
  local tmpfile=$(mktemp /tmp/clean_and_open_debug.XXXXXX)

  # Remove ANSI escape codes and save to the temporary file
  sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' "$1" > "$tmpfile"

  # Open the temporary file with nvim in quickfix mode
  nvim -q "$tmpfile"
}


PATH=$PATH:/home/robotsix-docker/.nix-profile/bin

source /home/robotsix-docker/.venv/bin/activate
