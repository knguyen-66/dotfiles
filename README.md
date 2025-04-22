# dotfiles

Personal app setting & configuration

## Requirements

GNU Stow, Vim, NeoVim, Tmux

```sh
# for Debian & Ubuntu
sudo apt install stow vim neovim tmux
# for other distros, check the main page of the packages for installation instruction
```

You will also want to setup the NeoVim's recommended packages to get the full functionality. More information in [kickstart.nvim README file](https://github.com/knguyen-66/kickstart.nvim/blob/master/README.md)

## Setup

- Clone the repo and all required submodules onto the local machine

```sh
git clone --recurse-submodules https://github.com/knguyen-66/dotfiles
```

- Run setup scripts to setup the required configuration & symlinks

```sh
cd /path/to/dotfiles
./setup.sh
```

## Customization

### Adding Tmux plugins

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
git submodule add <tmux-plugin-repo-url> ./.tmux/plugins/<tmux-plugin-name> 
```

- Open Tmux and hit `Prefix + r` to reload the config

### Edit NeoVim configs

The repo use `https://github.com/knguyen-66/kickstart.nvim` for the NeoVim environment. It's located in (./.config/nvim/)[./.config/nvim/] submodule when cloned. You can edit the files directly.

For more information about kickstart.nvim configs, check out the [kickstart.nvim README file](https://github.com/knguyen-66/kickstart.nvim/blob/master/README.md).

For submitting changes onto the repository, first you need to set the origin url to the correct repository:

```sh
cd .config/nvim
git remote set-url origin https://github.com/knguyen-66/kickstart.nvim
git fetch --all
# then you can create branches/MR/... as needed

# if you also want to pull latest changes from upstream repo
git remote add upstream https://github.com/nvim-lua/kickstart.nvim
git fetch upstream master
git merge upstream/master
```



