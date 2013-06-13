#!/bin/bash
echo ". ~/dotfiles/aliases" >> ~/.bashrc
ln -sf ~/dotfiles/inputrc            ~/.inputrc
ln -sf ~/dotfiles/gitconfig          ~/.gitconfig
ln -sf ~/dotfiles/vim/vimrc          ~/.vimrc
rm -rf ~/.vim
ln -sf ~/dotfiles/vim                ~/.vim
ln -sf ~/dotfiles/awesome            ~/.config/awesome
ln -sf ~/dotfiles/i3            ~/.i3
ln -sf ~/dotfiles/Xresources         ~/.Xresources
ln -sf ~/dotfiles/octave/octaverc    ~/.octaverc
ln -sf ~/dotfiles/tmux.conf          ~/.tmux.conf
