#!/usr/bin/env zsh
# zsh-abbr
source $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH

    autoload -Uz compinit
    compinit
fi

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# incr
source ~/.oh-my-zsh/plugins/incr/incr*.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# perl
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
