# install brewfile
install_brew_bundle() {
    running "installing homebrew bundle"
    brew bundle install --file=../dotfiles/brew/Brewfile
    ok
}

# install brew
install_brew() {
    running "checking homebrew..."
    brew_bin=$(which brew) 2>&1 > /dev/null
    if [[ $? != 0 ]]; then
        action "installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $? != 0 ]]; then
            error "unable to install homebrew, script $0 abort!"
            exit 2
        fi
        /opt/homebrew/bin/brew shellenv >> /Users/$(whoami)/Repo/dotfiles/dotfiles/zsh/.config/zsh/var.zsh
        eval "$(/opt/homebrew/bin/brew shellenv)"
        brew analytics off
    else
        ok
        bot "Homebrew"
        read -r -p "run brew update && upgrade? [y|N] " response
        if [[ $response =~ (y|yes|Y) ]]; then
            action "updating homebrew..."
            brew update
            ok "homebrew updated"
            action "upgrading brew packages..."
            brew upgrade
            ok "brews upgraded"
        else
            ok "skipped brew package upgrades."
        fi
    fi
    mkdir -p ~/Library/Caches/Homebrew/Formula
    brew doctor
    install_brew_bundle
}
