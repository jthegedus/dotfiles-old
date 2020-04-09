#!/usr/bin/env bash

set -euo pipefail

# install from apt
sudo apt install git curl tar apt-transport-https gnome-tweaks -y

# VSCode
sudo snap install code --classic

# Gitkraken
# Fix Gitkraken snap launcher icon
sudo snap install gitkraken
gitkraken_icon_path="Icon=/snap/gitkraken/current/usr/share/gitkraken/gitkraken.png"
gitkraken_snap_path="/var/lib/snapd/desktop/applications/gitkraken_gitkraken.desktop"
if ! grep -q "${gitkraken_icon_path}" "${gitkraken_snap_path}"; then
    printf "\n%s" "${gitkraken_icon_path}" >>"${gitkraken_snap_path}"
fi

# Barrier (cross-platform keyboard-mouse network sharing)
sudo snap install barrier

# Chat apps
sudo snap install discord
sudo snap install signal-desktop
sudo snap install slack --classic

# Firefox Developer Edition
firefox_developer_download_url="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
firefox_developer_filename="firefox-developer-edition.tar.bz2"
firefox_developer_destination_directory="/opt/firefox_dev"
firefox_developer_desktop_entry_path="${HOME}/.local/share/applications/firefox_dev.desktop"

if [[ ! -e "${firefox_developer_desktop_entry_path}" ]]; then
    tmp_download_dir=$(mktemp -d -t 'firefox_developer_edition_XXXXXX')
    trap 'rm -rf "${tmp_download_dir}"' EXIT
    wget -O "${tmp_download_dir}/${firefox_developer_filename}" "${firefox_developer_download_url}"
    tar -xvf "${tmp_download_dir}/${firefox_developer_filename}" --directory "${tmp_download_dir}"
    sudo mv "${tmp_download_dir}/firefox" "${firefox_developer_destination_directory}"
    cat >"${firefox_developer_desktop_entry_path}" <<EOL
[Desktop Entry]
Name=Firefox Developer
GenericName=Firefox Developer Edition
Exec=/opt/firefox_dev/firefox %u --class=FirefoxDev
StartupWMClass=FirefoxDev
Terminal=false
Icon=/opt/firefox_dev/browser/chrome/icons/default/default128.png
Type=Application
Categories=Application;Network;X-Developer;
Comment=Firefox Developer Edition Web Browser

[Desktop Action new-window]
Name=Open a New Window
Exec=/home/egdoc/.local/bin/firefox-dev %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=/home/egdoc/.local/bin/firefox-dev --private-window %u
EOL
    chmod +x "${firefox_developer_desktop_entry_path}"
else
    # cannot replace with utils.bash log_info as it will break remote file pull and execute.
    printf "ℹ️  Firefox Developer Edition is already installed.\\n"
fi
