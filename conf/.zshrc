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
    echo
    sgpt <<< "$_sgpt_cmd" --no-interaction --role ShellGPTActions
    # clear the buffer
    BUFFER=""
    zle redisplay
fi
}
zle -N _sgpt_zsh
bindkey '\el' _sgpt_zsh
_record_and_use_sgpt() {
    script -c "python3 -m aider.voice" /tmp/sgpt_voice_input
    if [[ -s /tmp/sgpt_voice_input ]]; then
        sgpt <<< "$(cat /tmp/sgpt_voice_input)" --no-interaction --role ShellGPTActions
    fi
}

zle -N _record_and_use_sgpt
bindkey '\er' _record_and_use_sgpt
