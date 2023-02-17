# maishiroma's Dotfiles

![Oh yah...](https://i1.wp.com/media1.tenor.com/images/a71c94c3aa7ad66a5051f81f48d14dd2/tenor.gif?w=688&ssl=1)

Hey there! Welcome to my dotfile repository! Here you will find all of the configuration that I use in all of my projects, whether they are work related or personal usage, everything is in here.

## Table of Contents

1. [General Overview](#general-overview)
1. [How to Install](#how-to-install)
1. [How to Manage](#how-to-manage)

## General Overview

This repository contains the following configurations:

- `.gitignore`
- `.gitconfig`
- `.zsh_exports`
- `.zshrc`
- `.bash_profile`
- `.vimrc`
- `.tmux.conf`

Each of these configurations are organized in root folders, indicating which environment they are being used in. These environments are:

- `global`: Universal configs that can work for any situation
- `personal`: Configs that are used on my personal devices
- `work`: Configs that are used for my work devices

This repository also contains settings and/or standards for the following:

- `python`
- `joplin`
- `Windows Terminal`
- `VS Code`
- `Auto HotKey`
- `Windows Powershell`

## How to Install

> The install script helps install Terminal programs; for programs that are outside of Terminal (i.e. VS Code), those need to be installed and configured manually as of now.

Installation is as simple as running `configure.sh` in the repo's root, specifying which type of config to utilize in the `-o`:

```bash
cd /this/repo
./configure.sh -o <personal/work>
```

If this amount of control is not necessary, an alterntive solution is to manually copy and paste the specific config to wherever it is needed:

```bash
cp /dir/to/this/repo/and/file /new/loc/for/file/
```

## How to Manage

Once the dotfiles are installed, updating is as simple as pulling any new update from the repository, and starting a new terminal sesssion.

```bash
cd /this/repo
git pull --rebase origin master
```

To remove the current/this configuration from the system:

```bash
cd /this/repo
./configure.sh -d
```

For more details on the script's flags as well as additional functionalities:

```bash
./configure.sh -h
```

### Downloading new Binaries

To help automate the installation of new binaries, the script, `bin_dw.sh` can be used:

```bash
./bin_dw.sh -b binary_name -v X.Y.Z
```

Currently the following binaries can be downloaded and verified:

- `terraform`
