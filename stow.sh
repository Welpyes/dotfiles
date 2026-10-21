#!/bin/bash

cd $(pwd)/dotfiles
stow -t $HOME --dotfiles . --adopt
rm ~/.config/nvim
ln -s ~/dotfiles/dotfiles/dot-config/nvim ~/.config/nvim
