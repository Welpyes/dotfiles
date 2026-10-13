#!/bin/bash

cd $(pwd)/dotfiles
stow -t $HOME --dotfiles . --adopt
ln -s ~/dotfiles/nvim ~/.config/nvim
