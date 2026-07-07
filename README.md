# ⚙️ Settings
Just somewhere to save any aliases/functions/editor configurations that I use.

## 📦 Set-up Process

### 🖥️ bash
- Replace `~/.bash_profile` with the contents of `bash/bash_profile.sh`
- Link bash profile inside ~/.bashrc
    -  `echo -e "\nif [ -f ~/.bash_profile ]; then . ~/.bash_profile; fi" >> ~/.bashrc && source ~/.bashrc`

### 🗂️ git
- Add custom git extensions to `~/.local/bin`
- Grant permissions to git extensions
  - `chmod +x ~/.local/bin/git-pr ~/.local/bin/git-url`

### 📝 vscode
- Add extensions by running `vscode/installed-extensions.sh`
- Update `settings.json` with contents of `vscode/settings.json`
- Update keybindings with contents of `vscode/keybindings.json`
- (Optional) Install snippets from `vscode/snippets/` directory

### 🧰 misc
- Install native Linux clipboard helper utility
  - `sudo apt update && sudo apt install xclip -y`
- If on Mac, then install `homebrew`
  - Once `homebrew` is installed, run `brew/install.sh` to install useful packages
