#!/bin/bash

# Fail fast and safer IFS
set -euo pipefail
IFS=$'\n\t'

# Get script directory for accessing resources like icons
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_PATH="$SCRIPT_DIR/beefy.png"

# establish some variables for nvidia driver installation
FILE="$HOME/.bash_profile"
SEARCH_TEXT="export GDK_GL=gles"
ADDITIONAL_TEXT="export GDK_GL=gles"

## Detect if zenity is available; if not, we'll install it after gathering credentials
need_zenity_install=false
if ! command -v zenity >/dev/null 2>&1; then
    need_zenity_install=true
fi

## Ask for the sudo password (use zenity if available, otherwise fallback to terminal)
sudo_password=""
if command -v zenity >/dev/null 2>&1; then
	sudo_password=$(zenity --password --title="Authentication Required" --window-icon="$ICON_PATH") || { zenity --error --text="Authentication failed" --window-icon="$ICON_PATH"; exit 1; }
else
	read -r -s -p "Sudo password: " sudo_password
	echo
fi

# Validate sudo credentials and cache them for this session
if ! printf '%s\n' "$sudo_password" | sudo -S -v >/dev/null 2>&1; then
	if command -v zenity >/dev/null 2>&1; then
		zenity --error --text="Authentication failed" --window-icon="$ICON_PATH"
	else
		echo "Authentication failed" >&2
	fi
	exit 1
fi

# Ensure cleanup: unset password and invalidate sudo timestamp on exit
trap 'unset sudo_password; sudo -k' EXIT

# Helper to run sudo with basic error handling and optional dry-run
run_sudo() {
	if [ "${DRY_RUN:-false}" = "true" ]; then
		echo "[DRY-RUN] sudo $*"
		return 0
	fi
	if ! sudo "$@"; then
		if command -v zenity >/dev/null 2>&1; then
			zenity --error --text="Command failed: sudo $*"
		else
			printf 'Command failed: sudo %s\n' "$*" >&2
		fi
		return 1
	fi
}

# If zenity was missing when we started, install it now (we have validated sudo)
if [ "$need_zenity_install" = true ]; then
    run_sudo dnf install -y zenity
fi

## Welcome messsage
zenity  --info --title="Welcome to Jeremy's Fedora Setup Script" --width="600" --height="300" --text="Welcome to Jeremy's Fedora Setup script.This script will uninstall, install, configure and tweak your Fedora install until it resembles my desktop. You'll be asked for your user password to continue." --ok-label="Continue" --window-icon="$ICON_PATH"

## function to reboot the system or return to the main menu
reboot_or_return() {
        zenity  --question --title="Reboot System or Return to Main Menu" --text="Some updated packages, such as the Linux kernel, need a reboot to activate. If you decide to reboot you'll need to rerun this script and skip the update option. Would you like to reboot your system now or return to the main menu?" --ok-label="Reboot" --cancel-label="Return to Main Menu" --window-icon="$ICON_PATH"
    if [ $? -eq 0 ]; then
        run_sudo reboot
    else
        return
    fi
}## Function to update fedora packages via dnf and call return_or_reboot
updates() {
	(
		sleep 1
		run_sudo dnf upgrade -y
		sleep 1
	) | 
	zenity  --progress --title="Updating your Fedora system"  --pulsate --auto-close --no-cancel --window-icon="$ICON_PATH"	
	reboot_or_return
}

## Function to remove unwanted software from the system
uninstall() {
	(
		sleep 1
		run_sudo dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y
		sleep 1
	) | 
	zenity  --progress --title="Uninstalling unwanted Fedora packages"  --pulsate --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

## Function to install flatpak applications from Flathub
flathub() {
	packages=(
		"https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref"
		"--system flathub org.inkscape.Inkscape"
		"--system flathub com.discordapp.Discord"
		"--system flathub org.videolan.VLC"
		"--system flathub org.kde.krita"
		"--system flathub org.blender.Blender"
		"--system flathub com.github.libresprite.LibreSprite"
		"--system flathub com.orama_interactive.Pixelorama"
		"--system flathub org.tuxpaint.Tuxpaint"
		"--system flathub org.upscayl.Upscayl"
		"--system flathub org.atheme.audacious"
		"--system flathub com.blitterstudio.amiberry"
		"--system flathub io.github.ryubing.Ryujinx"
		"--system flathub net.shadps4.shadPS4"
		"--system flathub com.obsproject.Studio"
		"--system flathub io.github.antimicrox.antimicrox"
		"--system flathub com.fightcade.Fightcade"
		"--system flathub com.mattjakeman.ExtensionManager"
		"--system flathub dev.gbstudio.gb-studio"
		"--system flathub org.mapeditor.Tiled"
		"--system flathub net.lutris.Lutris"
		"--system flathub com.heroicgameslauncher.hgl"
		"--system flathub com.github.tchx84.Flatseal"
		"--system flathub org.kde.kdenlive"
		"--system flathub fr.handbrake.ghb"
		"--system flathub org.jdownloader.JDownloader"
		"--system flathub com.github.Matoking.protontricks"
		"--system flathub com.transmissionbt.Transmission"
		"--system flathub com.vysp3r.ProtonPlus"
		"--system flathub app.xemu.xemu"
		"--system flathub net.pcsx2.PCSX2"
		"--system flathub net.kuribo64.melonDS"
		"--system flathub io.github.lime3ds.Lime3DS"
		"--system flathub com.retrodev.blastem"
		"--system flathub org.flycast.Flycast"
		"--system flathub org.libretro.RetroArch"
		"--system flathub info.cemu.Cemu"
		"--system flathub net.rpcs3.RPCS3"
	)

	total=${#packages[@]}

	(
		for i in "${!packages[@]}"; do
			idx=$((i+1))
			pct=$(( idx * 100 / total ))
			echo "$pct"
			# Use bash -c so multi-word package strings are parsed as separate args
			run_sudo bash -c "flatpak install -y ${packages[i]}"
			sleep 1
		done
	) |
	zenity --progress --title="Installing Flathub applications" --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

## Function to configure RPMfusion and install fedora packages via dnf
rpmfusion() {
	(
		echo "10" ; sleep 1
		run_sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" -y
		echo "20" ; sleep 1
		run_sudo dnf update @core -y
		echo "30" ; sleep 1
		run_sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
		echo "40" ; sleep 1
		run_sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y 
		echo "50" ; sleep 1
		run_sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
		echo "60" ; sleep 1
		run_sudo dnf install rpmfusion-free-release-tainted -y 
		echo "70" ; sleep 1
		run_sudo dnf install libdvdcss -y 
		echo "75" ; sleep 1
		run_sudo dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y 
		echo "80" ; sleep 1
		run_sudo dnf install fedora-workstation-repositories -y 
		echo "85" ; sleep 1
		run_sudo dnf install @development-tools -y
		echo "90" ; sleep 1
		run_sudo dnf install make gcc-c++ -y
		echo "92" ; sleep 1
		run_sudo dnf install fedora-workstation-repositories -y
		echo "94" ; sleep 1
		run_sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		printf '%s\n' \
			"[code]" \
			"name=Visual Studio Code" \
			"baseurl=https://packages.microsoft.com/yumrepos/vscode" \
			"enabled=1" \
			"autorefresh=1" \
			"type=rpm-md" \
			"gpgcheck=1" \
			"gpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
		| run_sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
		run_sudo dnf install code -y
		echo "100" ; sleep 1
	) | 
	zenity --progress --title="Configuring RPMfusion and installing Fedora packages" --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

## Function to configure system tweaks i like
tweaks() {
	(	
		echo "5" ; sleep 1
		gsettings set org.gnome.desktop.app-folders folder-children "['Graphics', 'Game', 'Utility', 'Development', 'Network']"
		echo "10" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Multimedia'
		echo "15" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ name 'Games'
		echo "20" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ name 'Utility'
		echo "25" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ name 'Development'
		echo "30" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Internet'
		echo "35" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true
		echo "40" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ translate true
		echo "45" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ translate true
		echo "50" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ translate true
		echo "55" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true
		echo "60" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ categories "['Graphics', 'Video', 'AudioVideo']"
		echo "65" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ categories "['Game']"
		echo "70" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ categories "['Utility', 'X-GNOME-Utilities']"
		echo "80" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ categories "['Development']"
		echo "90" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ categories "['Network']"
		echo "100" ; sleep 1
	) | 
	zenity  --progress --title="Configuring Gnome tweaks"  --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

# Install Nvidia Drivers from RPMFusion
green() {
	(
		echo "5" ; sleep 1
		run_sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 libva-utils vdpauinfo libva-nvidia-driver -y
		echo "75" ; sleep 1
		EXPANDED_FILE="$FILE"
		if ! grep -q "$SEARCH_TEXT" "$EXPANDED_FILE"; then
			echo "$ADDITIONAL_TEXT" >> "$EXPANDED_FILE"
		fi
		echo "100" ; sleep 1
	) |
	zenity  --progress --title="Install Nvidia GPU Drivers"  --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

# Install AMD Drivers
red() {
	(
		echo "5" ; sleep 1
		run_sudo dnf install mesa-vulkan-drivers vulkan mesa-libGL mesa-libEGL -y
		echo "20" ; sleep 1
		run_sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
		echo "40" ; sleep 1
		run_sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
		echo "60" ; sleep 1
		run_sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
		echo "80" ; sleep 1
		run_sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y
		echo "90" ; sleep 1
		run_sudo dnf install rocminfo rocm-opencl rocm-clinfo rocm-hip -y
		echo "100" ; sleep 1
	) |
	zenity  --progress --title="Install AMD GPU Drivers"  --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

blue()  {
    (
		echo "5" ; sleep 1
		run_sudo dnf install xorg-x11-drv-intel -y
		echo "50" ; sleep 1
		run_sudo dnf install intel-media-driver -y
		echo "100" ; sleep 1
	)|
	zenity --progress --title="Install Intel GPU Drivers" --percentage=0 --auto-close --no-cancel --window-icon="$ICON_PATH"
	return
}

# Function to display menu using zenity
mainmenu() {
    local selection
    selection=$(zenity --list \
        --title="Jeremy's Fedora Setup Script" \
        --window-icon="$ICON_PATH" \
        --column="Select an option" \
        --width=600 --height=400 \
        --no-headers \
        "Update this Fedora Install" \
        "Uninstall unwanted applications" \
        "Setup RPMfusion and install Fedora applications" \
        "Install Flathub applications" \
        "Set system tweaks" \
        "Install Nvidia GPU Drivers" \
        "Install AMD GPU Drivers" \
        "Install Intel GPU Drivers" \
        "Exit")
    echo "$selection"
}

## Function to perform actions based on menu selection
menu_actions() {
	case $1 in
		"Update this Fedora Install")
			updates
			;;
		"Uninstall unwanted applications")
			uninstall			
			;;
		"Setup RPMfusion and install Fedora applications")
			rpmfusion
			;;
		"Install Flathub applications")
			flathub
			;;
		"Set system tweaks")
			tweaks
			;;
		"Install Nvidia GPU Drivers")
			green
			;;
		"Install AMD GPU Drivers")
			red
			;;
		"Install Intel GPU Drivers")
			blue
			;;			
		"Exit")
			exit 0
			;;
		*)
			echo "Invalid option"
			;;
    esac
}

## Main loop
while true; do
    # Display menu and get user selection
    selected_option=$(mainmenu)

    # Perform actions based on user selection
    menu_actions "$selected_option"
done

mainmenu
