# ⚙️ Settings

Just somewhere to save any aliases, functions, and editor configurations that I use.

## 📦 Set-up Process

### 🖥️ bash

- **Master Profile Replacement**: Replace `~/.bash_profile` with the contents of `bash/.bash_profile`.
- **Dynamic Platform Profiling**: Create your isolated environment config files (`~/.bash_windows`, `~/.bash_mac`, or `~/.bash_linux`) next to your master profile. The main engine will automatically detect your host `$OSTYPE` and route permissions appropriately.
- **Initialize Terminal Bootloader**: Link your master profile inside your startup configuration loop so it initializes flawlessly on modern non-login or shell panes:

```bash
  echo -e "\nif [ -f ~/.bash_profile ]; then . ~/.bash_profile; fi" >> ~/.bashrc && source ~/.bashrc
  ```

### 🗂️ git

- **Prone Core Configuration**: Standardise `~/.gitconfig` using the base template inside your `git/.gitconfig` configuration target (handling `autocrlf = true`, `color.ui = true`, and remote calculation upstream hooks).
- *Note: All developer operational macros and rapid-fire shortcuts (like `gts`, `gco`, and `ga.`) have been migrated directly into `~/.bash_profile` to ensure seamless syntax parsing across platforms.*

### 📝 vscode

- **Extensions Deployment**: Populate your active layout by running the automated script block:

  ```bash
  vscode/installed-extensions.sh
  ```

- **Preference Configurations**: Sync your direct editor engine layers by copying over properties into your local app maps:
  - Update `settings.json` with contents of `vscode/settings.json`
  - Update keybindings with contents of `vscode/keybindings.json`
  - *(Optional)* Install custom reusable snippet templates from the `vscode/snippets/` folder context.

### 🧰 misc

- **Cross-Platform Compatibility**: Universal macros (like `here`, `hosts`, and `copyLastCmd`) run smoothly across platforms via native platform hooks (`clip` for Windows, `pbcopy` for macOS, and `xclip` for Linux systems).
- **Automated External APIs**: Includes fast-lookup integrations for `weather` checks (`wttr.in`), manual lookups (`cht.sh`), public `ip` fetches, and dynamic repository browsing via `ghcode`.
