# Scripts
This folder contains bash scripts used to easily configure vim and any other terminal features that I have customized.

## Post-Install Actions
This section highlights all of the extra steps needed in order to completly finish the dotfile installation.

#### Required
- Install [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - Use the `Oh-My-Zsh` installation:
    - Clone the repo into `~/.oh-my-zsh/custom/plugins`
    - Add `plugins=(zsh-autosuggestions)` to the `~/.zshrc` file
- Install [autoclose plugin](https://www.vim.org/scripts/script.php?script_id=1849)
  - Put the vim file from this into the `~/.vim/plugin` folder.
  - NOTE: If using the `vim_bootstrap`, this is already installed!
- Install [grip](https://github.com/joeyespo/grip)
  - Use `brew install grip`
- Install [vim markdown preview](https://github.com/JamshedVesuna/vim-markdown-preview) 
  - Clone repository into `~/.vim/bundle`

#### Optional
- Install [tmux](https://github.com/tmux/tmux) if you want to do some cool multiplexing action
  - Follow Wiki in how to install this.
  - If you do install tmux, you will also need to do the following:
    - Install [tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- Install [vim terraform](https://github.com/hashivim/vim-terraform) to make vim work well with Terraform.
  - Clone repo into `~/.vim/bundle`

