#!/usr/bin/env zsh
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# nvim
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export SPACEVIMDIR="$HOME/.config/SpaceVim"
export SSH_AUTH_SOCK="$HOME/Library/Group SSH_AUTH_SOCK=$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# perl
export MANPATH="$HOME/perl5/man:$MANPATH"
export PERL_LIB="$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5"
export PERL_ARCHLIB="$HOME/perl5/lib/perl5"
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
export PERL_LOCAL_LIB_DIR="$HOME/perl5/lib/perl5"

# homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
