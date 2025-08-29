#!/bin/bash

version="v0.000b"

# establish some variables for nvidia driver installation
FILE="~/.bash_profile"
SEARCH_TEXT="export GDK_GL=gles"
ADDITIONAL_TEXT="export GDK_GL=gles"

## Install zenity if it's not already
if ! rpm -q zenity >/dev/null 2>&1; then
	echo $sudo_password | sudo -S dnf install zenity -y
fi

## Ask for the sudo password
sudo_password=""
sudo_password=$(zenity --password --title="Authentication Required")

## Check if the user entered the sudo password
if [ $? -eq 0 ]; then
    # Run the command with sudo
    echo $sudo_password | sudo -S whoami
else
    zenity  --error --text="Authentication failed"
fi

## Welcome messsage
zenity  --info --title="Welcome to Jeremy's Fedora Setup Script" --width="600" --height="300" --text="Welcome to Jeremy's Fedora Setup script.This script will uninstall, install, configure and tweak your Fedora install until it resembles my desktop. You'll be asked for your user password to continue." --ok-label="Continue"

## function to reboot the system or return to the main menu
reboot_or_return() {
    zenity  --question --title="Reboot System or Return to Main Menu" --text="Some updated packages, such as the Linux kernel, need a reboot to activate. If you decide to reboot you'll need to rerun this script and skip the update option. Would you like to reboot your system now or return to the main menu?" --ok-label="Reboot" --cancel-label="Return to Main Menu"
    if [ $? -eq 0 ]; then
    	echo $sudo_password | sudo -S reboot
    else
        return
    fi
}

## Function to update fedora packages via dnf and call return_or_reboot
updates() {
	(
		sleep 1
		echo $sudo_password | sudo -S dnf upgrade -y
		sleep 1
	) | 
	zenity  --progress --title="Updating your Fedora system"  --pulsate --auto-close --no-cancel	
	reboot_or_return
}

## Function to remove unwanted software from the system
uninstall() {
	(
		sleep 1
		echo $sudo_password | sudo -S dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y 
		sleep 1
	) | 
	zenity  --progress --title="Uninstalling unwanted Fedora packages"  --pulsate --auto-close --no-cancel
	return
}

## Function to install flatpak applications from Flathub
flathub() {
	(
		echo "2" ; sleep 1
		echo $sudo_password | sudo -S flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
		echo "4" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.inkscape.Inkscape -y 
		echo "6" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.discordapp.Discord -y 
		echo "8" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.videolan.VLC -y 
		echo "10" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.krita -y 
		echo "12" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.blender.Blender -y 
		echo "14" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.libresprite.LibreSprite -y 
		echo "16" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.orama_interactive.Pixelorama -y 
		echo "18" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.tuxpaint.Tuxpaint -y 
		echo "20" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.upscayl.Upscayl -y 
		echo "22" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.atheme.audacious -y 
		echo "24" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.blitterstudio.amiberry -y 
		echo "26" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.ryubing.Ryujinx -y 
		echo "28" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.shadps4.shadPS4 -y
		echo "30"  ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.obsproject.Studio -y
		echo "32" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.antimicrox.antimicrox -y
		echo "34" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.fightcade.Fightcade -y
		echo "36" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.mattjakeman.ExtensionManager -y
		echo "38" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub dev.gbstudio.gb-studio -y
		echo "40" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.mapeditor.Tiled -y
		echo "42" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub net.lutris.Lutris -y
		echo "44" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.heroicgameslauncher.hgl -y
		echo "46" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.tchx84.Flatseal -y
		echo "48" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.kdenlive -y
		echo "50" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub fr.handbrake.ghb -y
		echo "52" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.jdownloader.JDownloader -y
		echo "54" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.Matoking.protontricks -y
		echo "56" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.transmissionbt.Transmission -y
		echo "58" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.vysp3r.ProtonPlus -y
		echo "60" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub app.xemu.xemu -y
		echo "65" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub net.pcsx2.PCSX2 -y
		echo "70" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.kuribo64.melonDS -y
		echo "75" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.lime3ds.Lime3DS -y
		echo "80" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.retrodev.blastem -y
		echo "90" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.flycast.Flycast -y
		echo "93" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.libretro.RetroArch -y
		echo "95" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub info.cemu.Cemu -y
		echo "98" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.rpcs3.RPCS3 -y
		echo "100" ; sleep 1
		echo $sudo_password |
		sleep 1
	) | 
		zenity  --progress --title="Installing Flathub applications"  --percentage=0 --auto-close --no-cancel
	return
}

## Function to configure RPMfusion and install fedora packages via dnf
rpmfusion() {
	(
		echo "10" ; sleep 1
		echo $sudo_password | sudo -S dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y 
		echo "20" ; sleep 1
		echo $sudo_password | sudo -S dnf update @core -y
		echo "30" ; sleep 1
		echo $sudo_password | sudo -S dnf config-manager setopt fedora-cisco-openh264.enabled=1
		echo "40" ; sleep 1
		echo $sudo_password | sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y 
		echo "50" ; sleep 1
		echo $sudo_password | sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
		echo "60" ; sleep 1
		echo $sudo_password | sudo -S dnf install rpmfusion-free-release-tainted -y 
		echo "70" ; sleep 1
		echo $sudo_password | sudo -S dnf install libdvdcss -y 
		echo "75" ; sleep 1
		echo $sudo_password | sudo -S dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y 
		echo "80" ; sleep 1
		echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y 
		echo "85" ; sleep 1
		echo $sudo_password | sudo -S dnf install @development-tools -y
		echo "90" ; sleep 1
		echo $sudo_password | sudo -S dnf install make gcc-c++ -y
		echo "92" ; sleep 1
		echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y
		echo "94" ; sleep 1
		echo $sudo_password | sudo -S rpm --import https://packages.microsoft.com/keys/microsoft.asc
		echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
		echo $sudo_password | sudo -S dnf install code -y
		echo "100" ; sleep 1
	) | 
	zenity --progress --title="Configuring RPMfusion and installing Fedora packages" --percentage=0 --auto-close --no-cancel
	return
}

## Function to configure system tweaks i like
tweaks() {
	(	
		echo "5" ; sleep 1
		gsettings set org.gnome.desktop.app-folders folder-children "['Graphics', 'Game', 'Utility', 'Development', 'Network']"
		echo "10" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Artsy Stuff'
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
	zenity  --progress --title="Configuring Gnome tweaks"  --percentage=0 --auto-close --no-cancel
	return
}

# Install Nvidia Drivers from RPMFusion
green() {
	(
		echo "5" ; sleep 1
		echo $sudo_password | sudo -S dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 nvidia-vaapi-driver libva-utils vdpauinfo -y
		echo "37" ; sleep 1
		echo $sudo_password | sudo -S dnf install libva-nvidia-driver.{i686,x86_64} -y
		echo "75" ; sleep 1
		EXPANDED_FILE="${FILE/#\~/$HOME}"
		if ! grep -q "$SEARCH_TEXT" "$EXPANDED_FILE"; then
			echo "$ADDITIONAL_TEXT" >> "$EXPANDED_FILE"
		fi
		echo "100" ; sleep 1
	) |
	zenity  --progress --title="Install Nvidia GPU Drivers"  --percentage=0 --auto-close --no-cancel
	return
}

# Install AMD Drivers
red() {
	(
		echo "5" ; sleep 1
		echo $sudo_password | sudo -S dnf install mesa-vulkan-drivers vulkan mesa-libGL mesa-libEGL -y
		echo "20" ; sleep 1
		echo $sudo_password | sudo -S dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
		echo "40" ; sleep 1
		echo $sudo_password | sudo -S dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
		echo "60" ; sleep 1
		echo $sudo_password | sudo -S dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
		echo "80" ; sleep 1
		echo $sudo_password | sudo -S dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y
		echo "90" ; sleep 1
		echo $sudo_password | sudo -S dnf install rocminfo rocm-opencl rocm-clinfo rocm-hip -y
		echo "100" ; sleep 1
	) |
	zenity  --progress --title="Install AMD GPU Drivers"  --percentage=0 --auto-close --no-cancel
	return
}

blue()  {
    (
        echo "5" ; sleep 1
		echo $sudo_password | sudo -S dnf install xorg-x11-drv-intel -y
		echo "50" ; sleep 1
		echo $sudo_password | sudo -S dnf install intel-media-driver -y
		echo "100" ; sleep 1
	)|
	zenity --progress --title="Install Intel GPU Drivers" --percentage=0 --auto-close --no-cancel
	return
}

# Function to display menu using zenity
mainmenu() {
    zenity --forms  \
        --title="Jeremy's Fedora Setup Script" \
        --text="Please select an option" \
        --add-combo="Option" \
        --combo-values="Update this Fedora Install|Uninstall unwanted applications|Setup RPMfusion and install Fedora applications|Install Flathub applications|Set system tweaks|Install Nvidia GPU Drivers|Install AMD GPU Drivers|Install Intel GPU Drivers|Exit"
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