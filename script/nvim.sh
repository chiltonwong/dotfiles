# set perl
install_perl() {
    PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
    cpanm -n App::cpanminus
    cpanm -n Neovim::Ext
}

# install ruby
install_ruby() {
    gem install neovim
    gem install bundler
}

# install nvim
install_spacevim() {
    bot "NVIM Setup"
    running "installing SpaceVim"
    curl -sLf https://spacevim.org/cn/install.sh | bash
    stow SpaceVim
    npm install -g neovim
    install_ruby
    install_perl

    python -m pip install pynvim
    ok "SpaceVim install successfully"
    ok "Plugins will be installed automatically when you fist open the nvim OR vim"
    ok "run :checkhealth to make sure SpaceVim is working correctly"
}
