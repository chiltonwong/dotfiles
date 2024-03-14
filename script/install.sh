source ./lib_sh/echos.sh
source ./lib_sh/requires.sh
source ./lib_sh/stow.sh

# check xcode
check_xcode() {
    if ! xcode-select --print-path &> /dev/null; then
        xcode-select --install &> /dev/null
        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done
        print_result $? ' XCode Command Line Tools Installed'
        sudo xcodebuild -license
        print_result $? 'Agree with the XCode Command Line Tools licence'
    fi
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
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/${whoami}/dotfiles/zsh/.config/zsh/var.zsh
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
}

# install brewfile
install_brew_bundle() {
    running "installing homebrew bundle"
    brew bundle install --file=../dotfiles/brew/Brewfile
    ok
}

# set py-venv
set_py_venv() {
    python -m venv ~/py-venv
}

# set zsh as the user login shell
set_zsh() {
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
    if [[ "$CURRENTSHELL" != "/opt/homebrew/bin/zsh" ]]; then
        bot "setting newer homebrew zsh (/opt/homebrew/bin/zsh) as your shell (password required)"
        sudo bash -c 'echo "/opt/homebrew/bin/zsh" >> /etc/shells'
        chsh -s /opt/homebrew/bin/zsh
        sudo dscl . -change /Users/$USER UserShell $SHELL /opt/homebrew/bin/zsh > /dev/null 2>&1 
        ok
    fi
}
# install zsh plugin
install_zsh_plugin() {
    running "installing oh-my-zsh" 
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    running "installing zsh plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    mkdir -p ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/incr
    wget https://mimosa-pudica.net/src/incr-0.2.zsh -P ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/incr
}

set_dotfiles() {
    bot "Dotfiles Setup"
    sudo -v

    if [ -z "$DOTFILES" ]; then
    export DOTFILES="${HOME}/dotfiles"
    fi

    COMPUTER_NAME=$(scutil --get ComputerName)
    LOCAL_HOST_NAME=$(scutil --get LocalHostName)

    sudo scutil --set HostName "$LOCAL_HOST_NAME"
    HOST_NAME=$(scutil --get HostName)

    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist NetBIOSName -string "$HOST_NAME"

    printf "ComputerName:  ==> [%s]\\n" "$COMPUTER_NAME"
    printf "LocalHostName: ==> [%s]\\n" "$LOCAL_HOST_NAME"
    printf "HostName:      ==> [%s]\\n" "$HOST_NAME"

    if [ -z "$XDG_CONFIG_HOME" ]; then
        running "Setting up ~/.config directory..."
        if [ ! -d "${HOME}/.config" ]; then
            mkdir "${HOME}/.config"
        fi
        export XDG_CONFIG_HOME="${HOME}/.config"
    fi

    if [ ! -d "${HOME}/.local/bin" ]; then
        running "Setting up ~/.local/bin directory..."
        mkdir -pv "${HOME}/.local/bin"
    fi

    if [ ! -d "${HOME}/.ssh" ]; then
        running "Setting up ~/.ssh directory..."
        mkdir -pv "${HOME}/.ssh"
    fi

    running "Checking your system architecture..."

    arch="$(uname -m)"

    if [ "$arch" == "arm64" ]; then
        running "You're on Apple Silicon! Setting HOMEBREW_PREFIX to /opt/homebrew..."
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        running "You're on an Intel Mac! Setting HOMEBREW_PREFIX to /usr/local..."
        HOMEBREW_PREFIX="/usr/local"
    fi

    running "Checking for potential stow conflicts..."

    cd "${DOTFILES}/" # stow needs to run from inside dotfiles dir

    stow_conflicts=(
        ".fzf.zsh"
        ".zshrc"
        ".gitconfig"
        ".gitignore_global"
        ".gitmessage"
        ".vim-bookmarks"
        ".viminfo"
        "Brewfile"
        ".config/1Password"
        ".config/SpaceVim"
        ".config/messauto"
        ".config/op"
        ".config/zsh"
        ".config/zsh-abbr"
    )

    for item in "${stow_conflicts[@]}"; do
        if [ -e "${HOME}/${item}" ]; then
            # Potential conflict detected
            if [ -L "${HOME}/${item}" ]; then
                # This is a symlink and we can ignore it.
                continue
            else
                # This is a file or directory that will cause a conflict.
                backup_stow_conflict "${HOME}/${item}"
            fi
        fi
    done

    for item in *; do
        if [ -d "$item" ]; then
            stow "$item"/
    fi
    done
    ok
}
# install nvim
install_spacevim() {
    bot "NVIM Setup"
    running "installing SpaceVim"
    curl -sLf https://spacevim.org/cn/install.sh | bash
    stow SpaceVim
    npm install -g neovim
    gem install neovim
    gem install bundler
    rbenv rehash
    
    cpanm -n Neovim::Ext
    cpanm -n App::cpanminus
    
    python -m pip install pynvim
    ok "SpaceVim install successfully"
    ok "Plugins will be installed automatically when you fist open the nvim OR vim"
    ok "run :checkhealth to make sure SpaceVim is working correctly"
}

set -e
check_xcode
install_brew
install_brew_bundle
set_py_venv
set_zsh
install_zsh_plugin
set_dotfiles
install_spacevim
