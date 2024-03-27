# include lib
source ./lib/echos.sh
source ./lib/requires.sh

# include script
source ./brew.sh
source ./zsh.sh
source ./dotfiles.sh
source ./nvim.sh

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

check_xcode
install_brew
install_zsh
set_dotfiles
install_spacevim
