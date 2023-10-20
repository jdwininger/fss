#!/bin/bash
#[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Ask for the sudo password
sudo_password=$(zenity --password --title="Authentication Required")

# Check if the user entered the sudo password
if [ $? -eq 0 ]; then
    # Run the command with sudo
    echo $sudo_password | sudo -S whoami
else
    zenity --error --text="Authentication failed"
fi

echo $sudo_password | sudo -S dnf install zenity

reboot_or_return() {
    zenity --question --title="Reboot System or Return to Main Menu" --text="Would you like to reboot your system now or return to the main menu?" --ok-label="Reboot" --cancel-label="Return to Main Menu"
    if [ $? -eq 0 ]; then
    	echo $sudo_password | sudo -S reboot
    else
        mainmenu
    fi
}

show_progress() {
    local task_name=$1
    local total_steps=$2
    local current_step=0

    while true; do
        # Update the progress bar
        current_step=$((current_step + 1))
        zenity --progress --title="Task Progress" --text="Processing $task_name..." --percentage=$(((current_step * 100) / total_steps))

        # Check if the task is completed
        if [ $current_step -eq $total_steps ]; then
            break
        fi

        # Simulate a task by sleeping for a second
        sleep 1
    done
}

quit() {
	clear
	exit
}

updates() {
	show_progress "Updating Fedora - this might take awhile" 
	echo $sudo_password | sudo -S dnf upgrade -y
	reboot_or_return
}

uninstall() {
	show_progress "Uninstalling unwanted applications" 5
	sudo dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y
	clear
	echo "Finished uninstalling unwanted Fedora applications."
	zenity --info --text="Finished uninstalling unwanted applications" --ok-label="Return to Main Menu"
	mainmenu
}

flathub() {
	show_progress "Install Flathub applications - This takes a while" 30
	echo $sudo_password | sudo -S flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref 
	echo $sudo_password | sudo -S flatpak install --system flathub org.inkscape.Inkscape -y
	echo $sudo_password | sudo -S flatpak install --system flathub com.discordapp.Discord -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.videolan.VLC -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.kde.krita -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.blender.Blender -y
	echo $sudo_password | sudo -S flatpak install --system flathub com.github.libresprite.LibreSprite -y
	echo $sudo_password | sudo -S flatpak install --system flathub com.orama_interactive.Pixelorama -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.tuxpaint.Tuxpaint -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.upscayl.Upscayl -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.atheme.audacious -y
	echo $sudo_password | sudo -S flatpak install --system flathub net.retrodeck.retrodeck -y
	echo $sudo_password | sudo -S flatpak install --system flathub org.ryujinx.Ryujinx -y
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
	zenity --info --text="Finished installing Flathub applications" --ok-label="Return to Main Menu"
	mainmenu
}

rpmfusion() {
	echo $sudo_password | sudo -S dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
	echo $sudo_password | sudo -S dnf groupupdate core -y
	echo $sudo_password | sudo -S dnf swap ffmpeg-free ffmpeg --allowerasing -y
	echo $sudo_password | sudo -S dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
	echo $sudo_password | sudo -S dnf groupupdate sound-and-video -y
	echo $sudo_password | sudo -S dnf install rpmfusion-free-release-tainted -y
	echo $sudo_password | sudo -S dnf install libdvdcss -y
	echo $sudo_password | sudo -S dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y
	echo $sudo_password | sudo -S dnf install fedora-workstation-repositories -y
	echo $sudo_password | sudo -S dnf config-manager --set-enabled google-chrome 
	echo $sudo_password | sudo -S dnf install google-chrome-stable -y
	zenity --info --text="Finshed installing Fedora packages" --ok-label="Return to Main Menu"
	mainmenu
}

tweaks() {
	gsettings set org.gnome.desktop.app-folders folder-children "['Graphics', 'Game', 'Utility', 'Development', 'Network']"
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Artsy Stuff'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ name 'Games'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ name 'Utility'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ name 'Development'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Internet'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ translate true
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ translate true
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ translate true
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ categories "['Graphics', 'Video', 'AudioVideo']"
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ categories "['Game']"
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ categories "['Utility', 'X-GNOME-Utilities']"
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ categories "['Development']"
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ categories "['Network']"
	zenity --info --text="Finished setting Gnome tweaks" --ok-label="Return to Main Menu"
	mainmenu
}

# Function to display menu using zenity
mainmenu() {
    zenity --forms \
        --title="Jeremys Fedora Setup Script" \
        --text="Please select an option" \
        --add-combo="Option" \
        --combo-values="Update this Fedora Install|Uninstall unwanted applications|Setup RPMfusion and install Fedora applications|Install Flathub applications|Set system tweaks|Exit"
}

# Function to perform actions based on menu selection
menu_actions() {
    case $1 in
        "Update this Fedora Install")
			clear
            echo "Update this Fedora Install"
			updates
            ;;
        "Uninstall unwanted applications")
			clear
            echo "Uninstall unwanted applications"
			uninstall			
            ;;
        "Setup RPMfusion and install Fedora applications|Install Flathub applications")
			clear
            echo "Setup RPMfusion and install Fedora applications|Install Flathub applications"
            rpmfusion
			;;
		"Install Flathub applications")
			clear
			echo "Install Flathub applications"
			flathub
			;;
		"Set system tweaks")
			clear
			echo "Set system tweaks"
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

# Main loop
while true; do
    # Display menu and get user selection
    selected_option=$(mainmenu)

    # Perform actions based on user selection
    menu_actions "$selected_option"
done


# mainmenu() {
#   clear
#   echo "Press 1 to update your system"
#   echo "Press 2 to uninstall unused applications"
#   echo "Press 3 to Setup RPMfusion and install Fedora applications"
#   echo "Press 4 to Install Flathub applications"
#   echo "Press 5 to set system tweaks"
#   echo "Press x to exit the script"
#   read -n 1 -p "Input Selection:" mainmenuinput
#   if [ "$mainmenuinput" = "1" ]; then
#             updates
#         elif [ "$mainmenuinput" = "2" ]; then
#             uninstall
#         elif [ "$mainmenuinput" = "4" ]; then
#             flathub
#         elif [ "$mainmenuinput" = "3" ]; then
#             rpmfusion
#         elif [ "$mainmenuinput" = "5" ]; then
#             tweaks
#         elif [ "$mainmenuinput" = "x" ];then
#             quit
#         elif [ "$mainmenuinput" = "X" ];then
#             quit
#         else
#             echo "You have entered an invalid selection!"
#             echo "Please try again."
#             echo ""
#             read -n 1 -s -p 'Press any key to continue.'
#             echo ""
#             clear
#             mainmenu
#         fi
# }

mainmenu
