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
		echo "." ; sleep 1
		echo $sudo_password | sudo -S flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref -y
		echo ".." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.inkscape.Inkscape -y 
		echo "..." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.discordapp.Discord -y 
		echo "...." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.videolan.VLC -y 
		echo "....." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.krita -y 
		echo "......" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.blender.Blender -y 
		echo "......." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.libresprite.LibreSprite -y 
		echo "........" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.orama_interactive.Pixelorama -y 
		echo "........." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.tuxpaint.Tuxpaint -y 
		echo ".........." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.upscayl.Upscayl -y 
		echo "..........." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.atheme.audacious -y 
		echo "............" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.retrodeck.retrodeck -y 
		echo "............." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.ryujinx.Ryujinx -y 
		echo ".............." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.yuzu_emu.yuzu -y
		echo "..............."  ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.obsproject.Studio -y
		echo "................" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.antimicrox.antimicrox -y
		echo "................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.fightcade.Fightcade -y
		echo ".................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.mattjakeman.ExtensionManager -y
		echo "..................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub dev.gbstudio.gb-studio -y
		echo "...................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.mapeditor.Tiled -y
		echo "....................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub net.lutris.Lutris -y
		echo "......................" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.heroicgameslauncher.hgl -y
		echo "......................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.tchx84.Flatseal -y
		echo "........................" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.kde.kdenlive -y
		echo "........................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub fr.handbrake.ghb -y
		echo ".........................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub org.jdownloader.JDownloader -y
		echo "..........................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.github.Matoking.protontricks -y
		echo "............................" ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.transmissionbt.Transmission -y
		echo "............................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub com.vysp3r.ProtonPlus -y
		echo ".............................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub app.xemu.xemu -y
		echo "..............................." ; sleep 1 
		echo $sudo_password | sudo -S flatpak install --system flathub net.pcsx2.PCSX2 -y
		echo "................................" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.kuribo64.melonDS -y
		echo "................................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub io.github.lime3ds.Lime3DS -y
		echo ".................................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub com.retrodev.blastem -y
		echo "..................................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.flycast.Flycast -y
		echo "...................................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub org.libretro.RetroArch -y
		echo "....................................." ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub info.cemu.Cemu -y
		echo "......................................" ; sleep 1
		echo $sudo_password | sudo -S flatpak install --system flathub net.rpcs3.RPCS3 -y
		echo "......................................." ; sleep 1
		echo $sudo_password |
		sleep 1
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
		echo $sudo_password | sudo -S dnf groupupdate @core -y
		echo "..." ; sleep 1
		echo $sudo_password | sudo -S dnf config-manager setopt fedora-cisco-openh264.enabled=1
		echo "...." ; sleep 1
		echo $sudo_password | sudo -S dnf swap ffmpeg-free ffmpeg --allowerasing -y 
		echo "....." ; sleep 1
		echo $sudo_password | sudo -S dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y 
		echo "......" ; sleep 1
		echo $sudo_password | sudo -S dnf install rpmfusion-free-release-tainted -y 
		echo "......." ; sleep 1
		echo $sudo_password | sudo -S dnf install libdvdcss -y 
		echo "........" ; sleep 1
		echo $sudo_password | sudo -S dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y 
		echo "........." ; sleep 1
		echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y 
		echo ".........." ; sleep 1
		echo "............" ; sleep 1
		echo "............." ; sleep 1
		echo $sudo_password | sudo -S dnf install @development-tools -y
		echo ".............." ; sleep 1
		echo $sudo_password | sudo -S dnf install make gcc-cpp -y
		echo "..............." ; sleep 1
		echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y
		echo "................" ; sleep 1
		echo $sudo_password | sudo -S rpm --import https://packages.microsoft.com/keys/microsoft.asc -y
		echo $sudo_password | sudo -S echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
		echo $sudo_password | sudo -S dnf install code -y
		echo "................." ; sleep 1
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

# Install Nvidia Drivers from RPMFusion
nvida() {
	(
		echo "" ; sleep 1
		echo $sudo_password | dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 nvidia-vaapi-driver libva-utils vdpauinfo -y
		echo ".." ; sleep 1
		echo $sudo_password | grubby --update-kernel=ALL --args='video=vesafb:mtrr:3'
		echo "..." ; sleep 1
		echo $sudo_password | dnf install libva-nvidia-driver.{i686,x86_64} -y
		echo "...." ; sleep 1
		echo $sudo_password | "export GDK_GL=gles" >> ~/.bash_profile
		echo "....." ; sleep 1
		) |
	zenity --progress --title="Installing Nvidia Drivers" --pulsate --auto-close --no-cancel
	return
}

# Install AMD Drivers
amd() {
	(
		echo "" ; sleep 1
		echo $sudo_password | sudo dnf install mesa-vulkan-drivers vulkan mesa-libGL mesa-libEGL -y
		echo ".." ; sleep 1
		echo $sudo_password | sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
		echo "..." ; sleep 1
		echo $sudo_password | sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
		echo "...." ; sleep 1
		echo $sudo_password | sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
		echo "....." ; sleep 1
		echo $sudo_password | sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y
		echo "......" ; sleep 1
		echo $sudo_password | sudo dnf install rocminfo rocm-opencl rocm-clinfo rocm-hip 
	) |
	zenity --progress --title="Installing AMD Drivers" --pulsate --auto-close --no-cancel
	return
}


# Function to display menu using zenity
mainmenu() {
    zenity --forms \
        --title="Jeremy's Fedora Setup Script" \
        --text="Please select an option" \
        --add-combo="Option" \
        --combo-values="Update this Fedora Install|Uninstall unwanted applications|Setup RPMfusion and install Fedora applications|Install Flathub applications|Set system tweaks|Install Nvidia Drivers|Install AMD Drivers|Install Intel Drivers|Exit"
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
		"Install Nvidia drivers")
			nvidia
			;;
		"Install AMD drivers")
			amd
			;;
		"Install Intel drivers")
			intel
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