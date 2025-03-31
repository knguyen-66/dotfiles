# dotfiles

Personal app setting &amp; configuration

## Requirements

GNU Stow, Vim & Neovim, Tmux

```sh
sudo apt install stow vim tmux
```

## Adding Tmux plugins

- Add Tmux plugin into the [.tmux.conf](./.tmux.conf) config file

```
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
...

```

- Add plugin repo as a submodule inside [.tmux/plugins/](./.tmux/plugins/) folder

```sh
git submodule add <repo-url> ./.tmux/plugins/<repo-name> 
```

- Open Tmux and hit `Prefix + r` to reload the config
