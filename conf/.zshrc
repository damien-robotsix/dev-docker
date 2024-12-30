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
alias gv='script -c "python3 -m aider.voice" /tmp/voice_gpt && sgpt <<< $(tail -n 3 /tmp/voice_gpt | head -n 1) --no-interaction --role ShellGPTActions'

