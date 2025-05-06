#!/bin/bash

mkdir -p ./tmux/plugins/
git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm

stow .

mv ~/.bashrc ~/.bashrc.bak
ln -s ~/.config/.bashrc ~/.bashrc

./tmux/plugins/tpm/bin/clean_plugins
./tmux/plugins/tpm/bin/install_plugins

