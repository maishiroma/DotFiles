# Git Configs
Documentation on what I am including in this repo for Git files

1) `gitconfig <specific>`
  - Depending on what workstation I am on, the `.gitconfig` that I should use will vary. This logic will be handled in my `bootstrap.sh` script.
2) `gitignore`
  - This file will be the bare bone `.gitignore` that I will need for a git repository.
3) `gitignore <specific>`
  - These gitignores will be specific to the projects that they are on. These will generally have what's in the vanilla `.gitignore` along with some extra content.

### How to Create a Specific `.gitignore` for a Project
1) Clone this repo down to your computer or 
``` 
cd ~
git clone https://github.com/shiro105/DotFiles.git
```
2) Copy one of the `.gitignore` that are in this directory and move it to the repo on your computer
```
cp <gitignore you want> ~/location/of/repo
```
