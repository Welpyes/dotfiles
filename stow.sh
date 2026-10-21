#!/bin/bash

cd $(pwd)/dotfiles
stow -t $HOME --dotfiles . --adopt
rm ~/.config/nvim
ln -s ~/dotfiles/nvim ~/.config/nvim
