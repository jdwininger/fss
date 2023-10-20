#!/bin/bash
#[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

quit() {
	clear
	exit
}

updates() {
	echo "Now updating your Fedora install. You will be asked for your password to continue. When this finishes your computer will reboot, so make sure all your work is saved. When your computer reboots run this script again."
	echo ""
	read -n 1 -s -p 'Press any key to continue.'
	sudo dnf upgrade -y
	reboot -n
}

uninstall() {
	sudo dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y
	clear
	echo "Finished uninstalling unwanted Fedora applications."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

flathub() {
	sudo flatpak install https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref 
	sudo flatpak install --system flathub org.inkscape.Inkscape -y
	sudo flatpak install --system flathub com.discordapp.Discord -y
	sudo flatpak install --system flathub org.videolan.VLC -y
	sudo flatpak install --system flathub org.kde.krita -y
	sudo flatpak install --system flathub org.blender.Blender -y
	sudo flatpak install --system flathub com.github.libresprite.LibreSprite -y
	sudo flatpak install --system flathub com.orama_interactive.Pixelorama -y
	sudo flatpak install --system flathub org.tuxpaint.Tuxpaint -y
	sudo flatpak install --system flathub org.upscayl.Upscayl -y
	sudo flatpak install --system flathub org.atheme.audacious -y
	sudo flatpak install --system flathub net.retrodeck.retrodeck -y
	sudo flatpak install --system flathub org.ryujinx.Ryujinx -y
	sudo flatpak install --system flathub org.yuzu_emu.yuzu -y
	sudo flatpak install --system flathub com.obsproject.Studio -y
	sudo flatpak install --system flathub io.github.antimicrox.antimicrox -y
	sudo flatpak install --system flathub com.fightcade.Fightcade -y
	sudo flatpak install --system flathub com.mattjakeman.ExtensionManager -y
	sudo flatpak install --system flathub dev.gbstudio.gb-studio -y
	sudo flatpak install --system flathub org.mapeditor.Tiled -y
	sudo flatpak install --system flathub net.lutris.Lutris -y
	sudo flatpak install --system flathub com.heroicgameslauncher.hgl -y
	sudo flatpak install --system flathub com.github.tchx84.Flatseal -y
	sudo flatpak install --system flathub org.kde.kdenlive -y
	sudo flatpak install --system flathub fr.handbrake.ghb -y
	sudo flatpak install --system flathub org.jdownloader.JDownloader -y
	sudo flatpak install --system flathub com.github.Matoking.protontricks -y
	sudo flatpak install --system flathub com.transmissionbt.Transmission -y
	sudo flatpak install --system flathub com.vysp3r.ProtonPlus -y
	sudo flatpak install --system flathub org.gnome.FileRoller -y
	clear
	echo "Finished installing Flathub applications. You'll need to log out and back in to see applications in gnome applications list."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

rpmfusion() {
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
	sudo dnf groupupdate core -y
	sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
	sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
	sudo dnf groupupdate sound-and-video -y
	sudo dnf install rpmfusion-free-release-tainted -y
	sudo dnf install libdvdcss -y
	sudo dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y
	sudo dnf install fedora-workstation-repositories -y
	sudo dnf config-manager --set-enabled google-chrome 
	sudo dnf install google-chrome-stable -y
	clear
	echo "Finished installing Fedora & RPMfusion applications."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
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
	clear
	echo "Finished tweaking Gnome."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

mainmenu() {
  clear
  echo "Press 1 to update your system"
  echo "Press 2 to uninstall unused applications"
  echo "Press 3 to Setup RPMfusion and install Fedora applications"
  echo "Press 4 to install Flathub applications"
  echo "Press 5 to set system tweaks"
  echo "Press x to exit the script"
  read -n 1 -p "Input Selection:" mainmenuinput
  if [ "$mainmenuinput" = "1" ]; then
            updates
        elif [ "$mainmenuinput" = "2" ]; then
            uninstall
        elif [ "$mainmenuinput" = "4" ]; then
            flathub
        elif [ "$mainmenuinput" = "3" ]; then
            rpmfusion
        elif [ "$mainmenuinput" = "5" ]; then
            tweaks
        elif [ "$mainmenuinput" = "x" ];then
            quit
        elif [ "$mainmenuinput" = "X" ];then
            quit
        else
            echo "You have entered an invalid selection!"
            echo "Please try again."
            echo ""
            read -n 1 -s -p 'Press any key to continue.'
            echo ""
            clear
            mainmenu
        fi
}

mainmenu
