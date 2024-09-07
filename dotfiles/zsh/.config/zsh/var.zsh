#!/usr/bin/env zsh
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# proxy
# export https_proxy=http://127.0.0.1:7890
# export http_proxy=http://127.0.0.1:7890
# export all_proxy=socks5://127.0.0.1:7890

# poetry
export POETRY_PYPI_MIRROR_URL=https://mirrors.cloud.tencent.com/pypi/simple/

# nvim
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export SPACEVIMDIR="$HOME/.config/SpaceVim"

# perl
export MANPATH="$HOME/perl5/man:$MANPATH"
export PERL_LIB="$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5:$HOME/perl5/lib/perl5"
export PERL_ARCHLIB="$HOME/perl5/lib/perl5"
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
export PERL_LOCAL_LIB_DIR="$HOME/perl5/lib/perl5"

# homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
