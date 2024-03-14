# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export WHOAMI="$(whoami)"

# oh-my-zsh theme
ZSH_THEME="agnoster"

# oh-my-zsh updates
zstyle ':omz:update' mode auto

# auto-correction.
ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

HIST_STAMPS="mm/dd/yyyy"

plugins=(
    git
    sudo
    encode64
    extract
    zoxide
    colorize
    safe-paste
    colored-man-pages
    command-not-found
    zsh-autosuggestions
    zsh-syntax-highlighting
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

export DOTFILES="/Users/$WHOAMI/dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"

. "$XDG_CONFIG_HOME/zsh/var.zsh"
. "$XDG_CONFIG_HOME/zsh/alias.zsh"
. "$XDG_CONFIG_HOME/zsh/plugin.zsh"
. "$XDG_CONFIG_HOME/zsh/path.zsh"
. "$XDG_CONFIG_HOME/zsh/compiler.zsh"

rsync -r /Users/$WHOAMI/Repo/dotfiles/dotfiles /Users/$WHOAMI/
