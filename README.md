<div align="center">

# Dotfiles & Developer Environment

Cross-platform dotfiles & developer environment for Ubuntu 18.04+, macOS Catalina & Windows 10 with WSL2

![Shellcheck](https://github.com/jthegedus/dotfiles/workflows/Shellcheck/badge.svg)

⚡️ tools for shell superpowers ⚡️<br/>[asdf](https://github.com/asdf-vm/asdf) · [shellcheck](https://github.com/koalaman/shellcheck) · [fzf](https://github.com/junegunn/fzf) · [z](https://github.com/rupa/z)

</div>

## Contents

- [Preamble](#preamble)
- [Windows 10 with WSL2](#windows-10-with-wsl2)
- [Ubuntu 20.04 or macOS Catalina](#ubuntu-2004-or-macos-catalina)
- [Ubuntu 20.04 Applications](#ubuntu-2004-applications)
- [VSCode](#vscode)
- [Fonts](#fonts)
- [Ubuntu on various hardware](#ubuntu-on-various-hardware)
- [Resources worth reading](#resources-worth-reading)
- [Contributions](#contributions)
- [License](#license)

## Preamble

This "cross-platform" setup of mine is really just a Ubuntu 20.04+ ZSH environment. macOS is supported by installing dependencies with `brew` where required. Windows 10 is supported with Ubuntu 18.04+ via WSL 2 👌

## Windows 10 with WSL2

<details>
<summary>Expand for Windows Setup</summary>

### Enable WSL

1. press `windows key`
2. type `developer settings` & press `enter`
3. select `developer mode`
4. press `windows key`
5. type `turn windows features on or off` & press `enter`
6. check `Windows Subsystem for Linux` & then press `ok`
7. reboot

### Ubuntu 20.04 on Windows

Install the [Ubuntu 18.04 Shell](https://www.microsoft.com/store/productId/9N9TNGVNDL3Q).

Boot the app and follow any instructions to setup your Ubuntu user profile.

Update Ubuntu deps with: `sudo apt-get update && sudo apt-get upgrade`

### A note on WSL 1 vs WSL 2

This guide will work with WSL version 1 and 2. WSL 2 will be recommended for better Ubuntu support and an improved user experience when it moves into a stable release of Windows 10.

If you intend to use WSL 2, then you will require a Windows build 18917+, currently available in the Insider Slow or Fast ring. [Read more about the requirements in the official release post](https://devblogs.microsoft.com/commandline/wsl-2-is-now-available-in-windows-insiders/).

### Set WSL2 Version

In powershell (admin) set the WSL version for your Ubuntu shell:

```shell
# wsl --set-version <Distro> <Version>
wsl --set-version Ubuntu-18.04 2
```

Validate the correct WSL version is being used:

```shell
wsl --list --verbose
```

See the [development of WSL on GitHub](https://github.com/microsoft/WSL).

### Windows Terminal

Microsoft's new [Terminal application for Windows 10](https://www.microsoft.com/store/productId/9N0DX20HK701) is a modern terminal app with support for different shells, themes, tabs and unicode (read emoji) support.

See the [development of Terminal on GitHub](https://github.com/microsoft/terminal).

<details>
<summary>Configuring the Terminal</summary>

- settings is a JSON file (`profile.json`) so easily syncable over cloud storage or code repository
- JSON Schema for `profile.json` provides autocompletion in editors for easy discovery of options
- set the default shell using the `globals.defaultProfile` value with the guid from your desired profile `profile[x].guid`.
- custom font via `profiles[x].fontFace` & `.fontSize`
- custom theme per profile with `profiles[x].colorScheme`, set with the desired `schemes[x].name` value. Comes with Solarized Dark/Light, Campbell (MS default theme) and One Half Dark/Light
- adjustable acrylic opacity (blur)
- editable key bindings

</details>

### VSCode with WSL 2

With VSCode's remote server feature, we now have native support for WSL within VSCode! Simply run `code .` from within a project folder in any terminal, if VSCode detects it needs to use WSL it will 💯 See the [docs for further information](https://code.visualstudio.com/docs/remote/wsl).

See the [VSCode remote server development on GitHub](https://github.com/microsoft/vscode-remote-release).

### Prepare for Ubuntu 18.04

The filesystem used by the Linux shell is hidden deep in your user's AppData folder. To make developing more convenient we will set up a symlink between our `projects` folder across the two environments.

1. create a `projects` folder in your Windows user space. I like to use `C:\Users\<username>\projects`
   > NB: Ubuntu will mount your `C:` drive to `/mnt/c`
2. open a Ubuntu Shell
3. create a symlink by linking your new `projects` folder from Windows to our Ubuntu userspace.

   ```shell
   ln -sv /mnt/c/Users/<username>/projects ~/projects
   ```

4. validate the symlink with `ls -la` and creating and editing a file from each userspace to see that the changes are reflected correctly.

### Last Steps

Now that we have WSL 2 working and a Ubuntu 18.04 Bash shell we can essentially follow the below Ubuntu guide below ⬇️

</details>

## Ubuntu 20.04 or macOS Catalina

Items installed in the following scripts include:

- shell: [`zsh`](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH) · [`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh) · [`powerline fonts`](https://github.com/powerline/fonts) · [`starship cross-shell theme`](https://starship.rs/)
- tools: [`asdf`](https://github.com/asdf-vm/asdf) · [`shellcheck`](https://github.com/koalaman/shellcheck) · [`fzf`](https://github.com/junegunn/fzf) · [`z`](https://github.com/rupa/z)
- tools with asdf: [`nodejs`](https://github.com/asdf-vm/asdf-nodejs) · [`firebase`](https://github.com/jthegedus/asdf-firebase) · [`gcloud`](https://github.com/jthegedus/asdf-gcloud) · [`gradle`](https://github.com/rfrancis/asdf-gradle) · [`hadolint`](https://github.com/looztra/asdf-hadolint) · [`java`](https://github.com/halcyon/asdf-java) · [`maven`](https://github.com/halcyon/asdf-maven) · [`python`](https://github.com/danhper/asdf-python) · [`ocaml`](https://github.com/asdf-community/asdf-ocaml) · [`shellcheck`](https://github.com/luizm/asdf-shellcheck) · [`terraform`](https://github.com/Banno/asdf-hashicorp)

and all system dependencies required by each of the above tools.

### Automated Installation

- clone my dotiles into the `projects` dir

  ```shell
  cd ~ && git clone https://github.com/jthegedus/dotfiles ~/projects/dotfiles
  ```

- run the `setup-shell.bash` script

  ```shell
  ~/projects/dotfiles/scripts/setup-shell.bash
  ```

- run the `setup-devtools.bash` script

  ```shell
  ~/projects/dotfiles/scripts/setup-devtools.bash
  ```

- run the `setup-devtools.bash` script again (this is because `asdf` requires a shell restart to take effect. The script accounts for re-running)

  ```shell
  ~/projects/dotfiles/scripts/setup-devtools.bash
  ```

### Automated Cleanup

- run the `cleanup.bash` script

```shell
~/projects/dotfiles/scripts/cleanup.bash
```

### Manual Installation

- open `scripts/setup-shell.bash` and `scripts/setup-devtools.bash` and copy/paste the commands you wish to use from top to bottom. It's fairly straight forward. If there is a tool you're unsure about either see my links at the top of the README or Google them 😉

## Ubuntu 20.04 Applications

Runs this installation script to install my Ubuntu 20.04 application setup:

```shell
wget -O - https://raw.github.com/jthegedus/dotfiles/master/scripts/setup-ubuntu.bash | bash
# or with curl if it is already on your system
bash -c "$(curl -fsSL https://raw.github.com/jthegedus/dotfiles/master/scripts/setup-ubuntu.bash)"
```

#### Comes with the following apps

From aptitude:

- `git`, `curl`, `tar`, `apt-transport-https`, `gnome-tweaks`

From the web:

- [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/): All the latest developer tools in beta, plus experimental features like the Multi-line Console Editor and WebSocket Inspector.

From the Ubuntu Store (snaps):

- [VSCode](https://code.visualstudio.com/): Mircosoft's free, open-source code editor.
- [GitKraken](https://www.gitkraken.com/git-client): Cross-platform Git GUI.
- [Slack](https://slack.com/): Team communication app.
- [Discord](https://discordapp.com/): Community communication app.
- [Signal](https://signal.org/): Privacy focused messaging app.

#### Other apps worth considering

- [Solaar](https://pwr.github.io/Solaar/): Logitech Wireless device management. `sudo apt install solaar`.
- [Barrier](https://snapcraft.io/barrier): Cross-platform mouse/keyboard sharing. [Synergy](https://symless.com/synergy): The commercial reimplementation.
- Gnome Extensions (requires `sudo apt-get install chrome-gnome-shell -y`):
  - [Sound Input & Output Device Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/): Select audio IO from media dropdown.
  - [ShellTile](https://extensions.gnome.org/extension/657/shelltile/): A tiling window extension for GNOME Shell.
  - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Disable the screensaver and auto suspend.
  - [Frippery Move Clock](https://extensions.gnome.org/extension/2/move-clock/): Move clock to left of status menu button.
  - [Panel OSD](https://extensions.gnome.org/extension/708/panel-osd/): Configuring where on the (main) screen notifications will appear, instead of just above the message tray.

## VSCode

Add VSCode to macOS path: https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line

[My vscode sync-settings can be found here](https://gist.github.com/jthegedus/a692812095d3bf7efa132c5a1bfe8d71). Choice extensions include:

- [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync): Store your config in the cloud making multi-machine and reinstallations a breeze!
- [shellcheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck): static analysis your `.sh` scripts. Requires [shellcheck itself](https://github.com/koalaman/shellcheck#shellcheck---a-shell-script-static-analysis-tool).
- [shell format](https://github.com/foxundermoon/vs-shell-format): formats `.sh`, `.bash`, `Dockerfiles`, ignore files, amongst others.
- [ReasonML language server](https://marketplace.visualstudio.com/items?itemName=jaredly.reason-vscode): written from scratch in Reason for Reason.

## Fonts

- [Microsoft's Cascadia Code with Powerlines](https://github.com/microsoft/cascadia-code): mono, ligatures, free
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/#how-to-install): mono, ligatures, free
- [Fira Code](https://github.com/tonsky/FiraCode): mono, ligatures, free
- [Dank Mono](https://dank.sh/): mono, ligatures, paid (although reasonable)
- [Hack](https://github.com/source-foundry/Hack): mono, free

## Ubuntu on various hardware

### Lenovo ThinkPad E485/E585

Ubuntu installation will hang on a Lenovo ThinkPad E485/E585. Below are the instructions I followed to remedy the issues:

- [18.04 / 18.10](https://medium.com/@jthegedus/ubuntu-18-04-lts-on-lenovo-thinkpad-e485-15e1d601473f)
- [19.04](https://medium.com/@jthegedus/ubuntu-19-04-lts-on-lenovo-thinkpad-e485-bf2d6cfd9cad)
- [19.04 - PopOS!](https://medium.com/@jthegedus/popos-19-04-on-lenovo-thinkpad-e485-ac3951199132)

### Dell XPS15 9560

On login the OS may hang. Below are the instructions I followed to remedy the issues:

- [18.04 / 18.10](https://medium.com/@jthegedus/ubuntu-18-04-lts-on-a-dell-xps-db4dcee9a2f9)

## Resources worth Reading

ZSH:

- [Bash 2 ZSH reference card](http://www.bash2zsh.com/zsh_refcard/refcard.pdf): Bash user's guide to ZSH
- [ZSH Lovers](http://grml.org/zsh/zsh-lovers.html): Z Shell tips and tricks

## Contributions

Contributions of any kind welcome!

[Thanks goes to these contributors](https://github.com/jthegedus/dotfiles/graphs/contributors)!

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
