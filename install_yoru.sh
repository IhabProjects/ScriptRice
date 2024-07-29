#!/bin/bash

# Exit on error
set -e

# Function to print a message
print_message() {
    echo "======================================"
    echo "$1"
    echo "======================================"
}

# Update system and install base-devel and git
print_message "Updating system and installing base-devel and git..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel git

# Install paru (AUR helper)
print_message "Installing paru (AUR helper)..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..

# Install AwesomeWM and necessary dependencies
print_message "Installing AwesomeWM and necessary dependencies..."
paru -S --noconfirm awesome-git
paru -Sy --noconfirm picom-git wezterm rofi acpi acpid acpi_call upower lxappearance-gtk3 \
jq inotify-tools polkit-gnome xdotool xclip gpick ffmpeg blueman redshift \
pipewire pipewire-alsa pipewire-pulse alsa-utils brightnessctl feh maim \
mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl --needed

# Install zsh and setup as default shell
print_message "Installing zsh and setting it as the default shell..."
sudo pacman -S --noconfirm zsh
chsh -s /bin/zsh

# Install neovim and vscode
print_message "Installing neovim and vscode..."
paru -S --noconfirm neovim
paru -S --noconfirm visual-studio-code-bin

# Enable and start necessary services
print_message "Enabling and starting necessary services..."
systemctl --user enable mpd.service
systemctl --user start mpd.service

# Clone the Yoru repository
print_message "Cloning the Yoru repository..."
git clone --depth 1 --recurse-submodules https://github.com/rxyhn/yoru.git
cd yoru
git submodule update --remote --merge

# Copy configuration files
print_message "Copying configuration files..."
cp -r config/* ~/.config/

# Install necessary fonts
print_message "Installing necessary fonts..."
mkdir -p ~/.local/share/fonts
cp -r misc/fonts/* ~/.local/share/fonts/
fc-cache -fv

# Print final message
print_message "Yoru installation complete! Log out and log back in with AwesomeWM."
print_message "Remember to configure zsh and neovim according to your preferences."
