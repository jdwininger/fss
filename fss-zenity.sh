#!/bin/bash

version="v0.000b"

## Welcome messsage
zenity --info --title="Welcome to Jeremy's Fedora Setup Script" --width="600" --height="300" --text="Welcome to Jeremy's Fedora Setup script.This script will uninstall, install, configure and tweak your Fedora install until it resembles my desktop. You'll be asked for your user password to continue." --ok-label="Continue"

## Ask for the sudo password
sudo_password=""
sudo_password=$(zenity --password --title="Authentication Required")

## Check if the user entered the sudo password
if [ $? -eq 0 ]; then
    # Run the command with sudo
    echo $sudo_password | sudo -S whoami
else
    zenity --error --text="Authentication failed"
fi

## Install zenity if it's not already
echo $password | sudo -S dnf install zenity

## function to reboot the system or return to the main menu
reboot_or_return() {
    zenity --question --title="Reboot System or Return to Main Menu" --text="Some updated packages, such as the Linux kernel, need a reboot to activate. If you decide to reboot you'll need to rerun this script and skip the update option. Would you like to reboot your system now or return to the main menu?" --ok-label="Reboot" --cancel-label="Return to Main Menu"
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
	zenity --progress --title="Updating your Fedora system" --pulsate --auto-close --no-cancel	
	reboot_or_return
}

## Function to remove unwanted software from the system
uninstall() {
	(
		sleep 1
		echo $sudo_password | sudo -S dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y 
		sleep 1
	) | 
	zenity --progress --title="Uninstalling unwanted Fedora packages" --pulsate --auto-close --no-cancel
	return
}

## Function to install flatpak applications from Flathub
flathub() {
	(
		echo "."
		echo $sudo_password | sudo -S flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
		echo ".."
		echo $sudo_password | sudo -S flatpak install --system flathub org.inkscape.Inkscape -y 
		echo "..."
		echo $sudo_password | sudo -S flatpak install --system flathub com.discordapp.Discord -y 
		echo "...."
		echo $sudo_password | sudo -S flatpak install --system flathub org.videolan.VLC -y 
		echo "....."
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.krita -y 
		echo "......"
		echo $sudo_password | sudo -S flatpak install --system flathub org.blender.Blender -y 
		echo "......."
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.libresprite.LibreSprite -y 
		echo "........"
		echo $sudo_password | sudo -S flatpak install --system flathub com.orama_interactive.Pixelorama -y 
		echo "........."
		echo $sudo_password | sudo -S flatpak install --system flathub org.tuxpaint.Tuxpaint -y 
		echo ".........."
		echo $sudo_password | sudo -S flatpak install --system flathub org.upscayl.Upscayl -y 
		echo "..........."
		echo $sudo_password | sudo -S flatpak install --system flathub org.atheme.audacious -y 
		echo "............"
		echo $sudo_password | sudo -S flatpak install --system flathub net.retrodeck.retrodeck -y 
		echo "............."
		echo $sudo_password | sudo -S flatpak install --system flathub org.ryujinx.Ryujinx -y 
		echo ".............. 14"
		echo $sudo_password | sudo -S flatpak install --system flathub org.yuzu_emu.yuzu -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.obsproject.Studio -y 
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.antimicrox.antimicrox -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.fightcade.Fightcade -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.mattjakeman.ExtensionManager -y 
		echo $sudo_password | sudo -S flatpak install --system flathub dev.gbstudio.gb-studio -y 
		echo $sudo_password | sudo -S flatpak install --system flathub org.mapeditor.Tiled -y 
		echo $sudo_password | sudo -S flatpak install --system flathub net.lutris.Lutris -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.heroicgameslauncher.hgl -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.tchx84.Flatseal -y 
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.kdenlive -y 
		echo $sudo_password | sudo -S flatpak install --system flathub fr.handbrake.ghb -y 
		echo $sudo_password | sudo -S flatpak install --system flathub org.jdownloader.JDownloader -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.Matoking.protontricks -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.transmissionbt.Transmission -y 
		echo $sudo_password | sudo -S flatpak install --system flathub com.vysp3r.ProtonPlus -y 
		echo $sudo_password | sudo -S flatpak install --system flathub org.gnome.FileRoller -y 
	) | 
		zenity --progress --title="Installing Flathub applications" --pulsate --auto-close --no-cancel
	return
}

## Function to configure RPMfusion and install fedora packages via dnf
rpmfusion() {
	(
		echo "." ; sleep 1
		echo $sudo_password | sudo -S dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y 
		echo ".." ; sleep 1
		echo $sudo_password | sudo -S dnf groupupdate core -y 
		echo "..." ; sleep 1
		echo $sudo_password | sudo -S dnf swap ffmpeg-free ffmpeg --allowerasing -y 
		echo "...." ; sleep 1
		echo $sudo_password | sudo -S dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y 
		echo "....." ; sleep 1
		echo $sudo_password | sudo -S dnf groupupdate sound-and-video -y 
		echo "......" ; sleep 1
		echo $sudo_password | sudo -S dnf install rpmfusion-free-release-tainted -y 
		echo "......." ; sleep 1
		echo $sudo_password | sudo -S dnf install libdvdcss -y 
		echo "........" ; sleep 1
		echo $sudo_password | sudo -S dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y 
		echo "........." ; sleep 1
		echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y 
		echo ".........." ; sleep 1
		echo $sudo_password | sudo -S dnf config-manager --set-enabled google-chrome -y
		echo "............" ; sleep 1
		echo $sudo_password | sudo -S dnf install google-chrome-stable -y
		sleep 1
	) | 
		zenity --progress --title="Configuring RPMfusion and installing Fedora packages" --pulsate --auto-close --no-cancel
	return
}

tweaks() {
	(	
		echo "" ; sleep 1
		gsettings set org.gnome.desktop.app-folders folder-children "['Graphics', 'Game', 'Utility', 'Development', 'Network']"
		echo "." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Artsy Stuff'
		echo ".." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ name 'Games'
		echo "..." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ name 'Utility'
		echo "...." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ name 'Development'
		echo "....." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Internet'
		echo "......" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true
		echo "......." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ translate true
		echo "........" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ translate true
		echo "........." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ translate true
		echo ".........." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true
		echo "..........." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ categories "['Graphics', 'Video', 'AudioVideo']"
		echo "............" ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ categories "['Game']"
		echo "............." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ categories "['Utility', 'X-GNOME-Utilities']"
		echo ".............." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ categories "['Development']"
		echo "..............." ; sleep 1
		gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ categories "['Network']"
		echo "................" ; sleep 1
	) | 
	zenity --progress --title="Configuring Gnome tweaks" --pulsate --auto-close --no-cancel
	return
}

# Function to display menu using zenity
mainmenu() {
    zenity --forms \
        --title="Jeremy's Fedora Setup Script" \
        --text="Please select an option" \
        --add-combo="Option" \
        --combo-values="Update this Fedora Install|Uninstall unwanted applications|Setup RPMfusion and install Fedora applications|Install Flathub applications|Set system tweaks|Exit"
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