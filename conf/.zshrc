export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster-robotsix"

CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
COMPLETION_WAITING_DOTS="true"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

PATH=$PATH:/home/robotsix-docker/.nix-profile/bin

source $HOME/.robotsix-env/bin/activate

# Shell-GPT integration ZSH
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_cmd=$BUFFER
    sgpt <<< "$_sgpt_cmd" --no-interaction --role ShellGPTActions
    echo
fi
}
zle -N _sgpt_zsh
bindkey ^l _sgpt_zsh
