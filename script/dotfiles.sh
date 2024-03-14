source ./lib/stow.sh

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
        ".config/SpaceVim"
        ".config/messauto"
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
