#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

quit() {
	clear
	exit
}

updates() {
	clear
	echo ""
	echo "Now updating your Fedora install. When this finishes your computer will automatically reboot, so make sure all your work is saved. When your computer reboots run this script again to continue to the next step."
	echo ""
	read -n 1 -s -p 'Press any key to continue.'
	sudo dnf upgrade -y
	reboot -n
}

uninstall() {
	clear
	echo ""
	sudo dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y
	clear
	echo "Finished uninstalling unwanted Fedora applications."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

flathub() {
	clear
	echo ""
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
	clear
	echo "On the next flatpak choose option 2"
	read -n 1 -s -p 'Press any key to continue'
	echo ""
	sudo echo -e "2" | flatpak install --system flathub org.freedesktop.Platform.VulkanLayer.gamescope -y
	sudo flatpak install --system flathub app.xemu.xemu -y
	sudo flatpak install --system flathub net.pcsx2.PCSX2 -y
	sudo flatpak install --system flathub net.kuribo64.melonDS -y
	sudo flatpak install --system flathub io.github.lime3ds.Lime3DS -y
	sudo flatpak install --system flathub com.retrodev.blastem -y
	sudo flatpak install --system flathub org.flycast.Flycast -y
	sudo flatpak install --system flathub org.libretro.RetroArch -y
	sudo flatpak install --system flathub info.cemu.Cemu -y
	sudo flatpak install --system flathub net.rpcs3.RPCS3 -y
	sudo flatpak install --system flathub io.github.ryubing.Ryujinx -y
	clear
	echo "Finished installing Flathub applications. You'll need to log out and back in to see applications in gnome applications list."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

rpmfusion() {
	clear
	echo ""
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
	sudo dnf update @core -y
	sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
	sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
	sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
	sudo dnf groupupdate sound-and-video -y
	sudo dnf install rpmfusion-free-release-tainted -y
	sudo dnf install libdvdcss -y
	sudo dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y
	sudo dnf group install development-tools -y
	sudo dnf install make gcc-cpp -y
	sudo dnf install fedora-workstation-repositories -y
	# sudo dnf config-manager --set-enabled google-chrome 
	# sudo dnf install google-chrome-stable -y
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc -y
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	sudo dnf install code -y
	clear
	echo "Finished installing Fedora & RPMfusion applications."
	echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

tweaks() {
	clear
	echo ""
	gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
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

nvidia()  {
	clear
	echo ""
	echo "Make sure you have ran menu option 1 before installing these Nvidia drivers."
	sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 nvidia-vaapi-driver libva-utils vdpauinfo -y
	sudo grubby --update-kernel=ALL --args='video=vesafb:mtrr:3'
	sudo dnf install libva-nvidia-driver.{i686,x86_64}
	echo "export GDK_GL=gles" >> ~/.bash_profile
	echo "Finished RPMFusion Nvidia drivers."
        echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

amd()  {
	clear
	echo ""
	sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
	sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
	sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
	sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
	sudo dnf install rocminfo rocm-opencl rocm-clinfo rocm-hip 
        echo "Finished setting up AMD GPU."
        echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
	mainmenu
}

intel()  {
        clear
        echo ""
	sudo dnf install xorg-x11-drv-intel
	sudo dnf install intel-media-driver
        echo "Finished setting up Intel GPU."
        echo ""
        read -n 1 -s -p 'Press any key to return to the main menu'
        clear
    mainmenu
}

mainmenu() {
  clear
  echo "Press 1 to update your system - Start Here"
  echo "Press 2 to uninstall unused applications"
  echo "Press 3 to setup RPMfusion and install Fedora applications"
  echo "Press 4 to install Flathub applications"
  echo "Press 5 to set system tweaks"
  echo "Press n to install Nvidia driver for media and CUDA"
  echo "Press a to setup AMD GPU for ROCm, VDPU and VAAPI"
  echo "Press i to setup Intel GPU Hardware Acceleration"
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
        elif [ "$mainmenuinput" = "a" ]; then
            amd
        elif [ "$mainmenuinput" = "A" ]; then
            amd
	elif [ "$mainmenuinput" = "i" ]; then
            intel
        elif [ "$mainmenuinput" = "I" ]; then
            intel
        elif [ "$mainmenuinput" = "n" ]; then
            nvidia
        elif [ "$mainmenuinput" = "N" ]; then
            nvidia
        elif [ "$mainmenuinput" = "x" ]; then
            quit
        elif [ "$mainmenuinput" = "X" ];then
            quit
        else
            echo "You have entered an invalid selection!"
            echo "Please try again."
            echo ""
            read -n 1 -s -p "Press any key to continue."
            echo ""
            clear
            mainmenu
        fi
}

mainmenu
