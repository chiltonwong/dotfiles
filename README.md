## dotfiles for macos
please use and share at your own risk. These are regularly maintained and used daily by me on my own MacOS.

### Main Modules
1. brew
2. GNU Stow
3. zoxide
4. SpaceVim
5. 1password-cli & 1password ssh agent
6. zsh
7. oh-my-zsh
8. zsh-abbr

### what is gnu stow
> Stow is a symlink farm manager program which takes distinct sets of software and/or data located in separate directories on the filesystem, and makes them all appear to be installed in a single directory tree.

> However Stow is still used not only for software package management,
but also for other purposes, such as facilitating [a more controlled
approach to management of configuration files in the user's home
directory](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html),
especially when [coupled with version control
systems](http://lists.gnu.org/archive/html/info-stow/2011-12/msg00000.html).

### How to install
1. clone this repo to `~/Repo`
2. review all files in `dotfiles`, modify existing dotfiles and add your own dotfiles`
3. you may need to review and modify `script/install.sh:140`
4. rsync `~/dotfiles` with `~/Repo/dotfiles/dotfiles`
5. run `script/install.sh`

```bash
mkdir -p ~/Repo & cd ~/Repo
git clone https://github.com/chiltonwong/dotfiles.git
rsync -r ~/Repo/dotfiles/dotfiles ~/
cd ~/Repo/dotfiles
# chmod -R +x script
./script/install.sh
```

### todo
- [ ] minimize Brewfile
- [ ] fix known bugs
