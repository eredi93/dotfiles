#! /bin/bash

# link custom scripts
for SCRIPT in $(ls $HOME/.dotfiles/scripts); do
  rm -rf /usr/local/bin/$SCRIPT
  ln -s $HOME/.dotfiles/scripts/$SCRIPT /usr/local/bin/$SCRIPT
done

# zsh-syntax-highlighting
ZSH_SYNTAX=$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
if [ -d $ZSH_SYNTAX ]; then
    rm -rf $ZSH_SYNTAX
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_SYNTAX

# zsh-autosuggestions
ZSH_AUTOSUGGESTIONS=$HOME/.oh-my-zsh/plugins/zsh-autosuggestions
if [ -d $ZSH_AUTOSUGGESTIONS ]; then
    rm -rf $ZSH_AUTOSUGGESTIONS
fi
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_AUTOSUGGESTIONS

# zsh-history-substring-search
ZSH_HISTORY=$HOME/.oh-my-zsh/plugins/zsh-history-substring-search
if [ -d $ZSH_HISTORY ]; then
    rm -rf $ZSH_HISTORY
fi
git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_HISTORY

# add custom pygmelion theme
PYG=$HOME/.oh-my-zsh/themes/pygmalion.zsh-theme
rm -rf $PYG
ln -s $HOME/.dotfiles/themes/pygmalion.zsh-theme $PYG

USE_CASE=${USE_CASE:-home}
# zshrc soft link
if ! [ -L $HOME/.zshrc ] && [ -f $HOME/.zshrc ]; then
    mv $HOME/.zshrc $HOME/.zshrc.old
fi
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zshrc.$USE_CASE $HOME/.zshrc

# git soft link
if ! [ -L $HOME/.gitconfig ] && [ -f $HOME/.gitconfig ]; then
    mv $HOME/.gitconfig $HOME/.gitconfig.old
fi
rm -rf $HOME/.git-config
ln -s $HOME/.dotfiles/git-config $HOME/.git-config

# vimrc soft link
if ! [ -L $HOME/.vimrc ] && [ -f $HOME/.vimrc ]; then
    mv $HOME/.vimrc $HOME/.vimrc.old
fi
rm -rf $HOME/.vimrc
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc

# setup vundle
VIM_DIR="$HOME/.vim"
if [ -d $VIM_DIR ]; then
    rm -rf $VIM_DIR
fi
mkdir $VIM_DIR
mkdir $VIM_DIR/bundle
mkdir $VIM_DIR/colors
git clone https://github.com/VundleVim/Vundle.vim.git $VIM_DIR/bundle/Vundle.vim
git clone https://github.com/altercation/vim-colors-solarized.git $VIM_DIR/bundle/vim-colors-solarized
cp $VIM_DIR/bundle/vim-colors-solarized/colors/solarized.vim $VIM_DIR/colors/
vim +PluginInstall +qall

# tmux soft link
if ! [ -L $HOME/.tmux.conf ] && [ -f $HOME/.tmux.conf ]; then
    mv $HOME/.tmux.conf $HOME/.tmux.conf.old
fi
rm -rf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf

# tmux powerline
if [ -d $HOME/.tmux-powerline ]; then
  rm -rf $HOME/.tmux-powerline
fi
git clone git@github.com:erikw/tmux-powerline.git $HOME/.tmux-powerline
cp $HOME/.dotfiles/tmux/default.sh $HOME/.tmux-powerline/themes/
if ! [ -L $HOME/.tmux-powerlinerc ] && [ -f $HOME/.tmux-powerlinerc ]; then
    mv $HOME/.tmux-powerlinerc $HOME/.tmux-powerlinerc.old
fi
rm -rf $HOME/.tmux-powerlinerc
ln -s $HOME/.dotfiles/tmux-powerlinerc $HOME/.tmux-powerlinerc
bash $HOME/.tmux-powerline/generate_rc.sh
tmux source-file ~/.tmux.conf
