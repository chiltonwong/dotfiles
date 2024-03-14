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
install_zsh() {
    running "installing zsh"
    set_zsh
    running "installing oh-my-zsh" 
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    running "installing zsh plugin"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    mkdir -p ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/incr
    wget https://mimosa-pudica.net/src/incr-0.2.zsh -P ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/incr
    # fix zsh-abbr
    chmod go-w '/opt/homebrew/share'
    chmod -R go-w '/opt/homebrew/share/zsh'
}
