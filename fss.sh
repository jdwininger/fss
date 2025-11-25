#!/bin/bash

# Fail fast and safer IFS
set -euo pipefail
IFS=$'\n\t'

# Require sudo; re-exec if not root
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# establish some variables
FILE="$HOME/.bash_profile"
SEARCH_TEXT="export GDK_GL=gles"
ADDITIONAL_TEXT="export GDK_GL=gles"

quit() {
	clear
	exit 0
}

# Helper to run sudo with basic error handling
run_sudo() {
	if ! sudo "$@"; then
		printf 'Command failed: sudo %s\n' "$*" >&2
		return 1
	fi
}

updates() {
	clear
	echo ""
	echo "Now updating your Fedora install. When this finishes your computer will automatically reboot, so make sure all your work is saved. When your computer reboots run this script again to continue to the next step."
	echo ""
	read -r -n 1 -s -p 'Press any key to continue.'
	run_sudo dnf upgrade -y
	run_sudo reboot -n
}

uninstall() {
	clear
	echo ""
	run_sudo dnf remove libreoffice* rhythmbox gnome-abrt mediawriter -y
	clear
	echo "Finished uninstalling unwanted Fedora applications."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

flathub() {
	clear
	echo ""

	packages=(
		"https://flathub.org/beta-repo/appstream/org.gimp.GIMP.flatpakref"
		"--system flathub org.inkscape.Inkscape"
		"--system flathub com.discordapp.Discord"
		"--system flathub org.videolan.VLC"
		"--system flathub org.kde.krita"
		"--system flathub org.blender.Blender"
#		"--system flathub com.github.libresprite.LibreSprite"
#		"--system flathub com.orama_interactive.Pixelorama"
		"--system flathub org.tuxpaint.Tuxpaint"
		"--system flathub org.upscayl.Upscayl"
		"--system flathub org.atheme.audacious"
#		"--system flathub org.yuzu_emu.yuzu"
		"--system flathub com.obsproject.Studio"
		"--system flathub io.github.antimicrox.antimicrox"
		"--system flathub com.fightcade.Fightcade"
		"--system flathub com.mattjakeman.ExtensionManager"
#		"--system flathub dev.gbstudio.gb-studio"
#		"--system flathub org.mapeditor.Tiled"
		"--system flathub net.lutris.Lutris"
		"--system flathub com.heroicgameslauncher.hgl"
		"--system flathub com.github.tchx84.Flatseal"
		"--system flathub org.kde.kdenlive"
		"--system flathub fr.handbrake.ghb"
		"--system flathub org.jdownloader.JDownloader"
		"--system flathub com.github.Matoking.protontricks"
		"--system flathub com.transmissionbt.Transmission"
		"--system flathub com.vysp3r.ProtonPlus"
		"--system flathub org.freedesktop.Platform.VulkanLayer.gamescope"
		"--system flathub app.xemu.xemu"
		"--system flathub net.pcsx2.PCSX2"
		"--system flathub net.kuribo64.melonDS"
		"--system flathub io.github.lime3ds.Lime3DS"
		"--system flathub com.retrodev.blastem"
		"--system flathub org.flycast.Flycast"
		"--system flathub org.libretro.RetroArch"
		"--system flathub info.cemu.Cemu"
		"--system flathub net.rpcs3.RPCS3"
		"--system flathub io.github.ryubing.Ryujinx"
	)

	total=${#packages[@]}
	for i in "${!packages[@]}"; do
		idx=$((i+1))
		echo "Installing package $idx of $total..."
		# Use bash -c so multi-word package strings are parsed as separate args
		run_sudo bash -c "flatpak install -y ${packages[i]}"
	done

	clear
	echo "Finished installing Flathub applications. You'll need to log out and back in to see applications in gnome applications list."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

rpmfusion() {
	clear
	echo ""
	run_sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" -y
	run_sudo dnf update @core -y
	run_sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
	run_sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
#	run_sudo dnf groupupdate sound-and-video -y
	run_sudo dnf install rpmfusion-free-release-tainted -y
	run_sudo dnf install libdvdcss -y
	run_sudo dnf install steam wine winetricks gnome-tweaks kernel-modules-extra -y
	run_sudo dnf group install development-tools -y
	run_sudo dnf install make gcc-c++ -y
	run_sudo dnf install fedora-workstation-repositories -y
	# run_sudo dnf config-manager --set-enabled google-chrome 
	# run_sudo dnf install google-chrome-stable -y
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
	clear
	echo "Finished installing Fedora & RPMfusion applications."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

#tweaks() {
#	clear
#	echo ""
#	gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
#	gsettings set org.gnome.desktop.app-folders folder-children "['Graphics', 'Game', 'Utility', 'Development', 'Network']"
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Artsy Stuff'
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ name 'Games'
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ name 'Utility'
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ name 'Development'
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Internet'
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ translate true
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ translate true
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ translate true
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ categories "['Graphics', 'Video', 'AudioVideo']"
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Game/ categories "['Game']"
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utility/ categories "['Utility', 'X-GNOME-Utilities']"
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ categories "['Development']"
#	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ categories "['Network']"
#	clear
#	echo "Finished tweaking Gnome."
#	echo ""
#	read -r -n 1 -s -p 'Press any key to return to the main menu'
#	clear
#	mainmenu
#}

nvidia()  {
	clear
	echo ""
	echo "Make sure you have ran menu option 1 before installing these Nvidia drivers."
	run_sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 libva-utils vdpauinfo -y
	run_sudo grubby --update-kernel=ALL --args='video=vesafb:mtrr:3'
	run_sudo dnf install libva-nvidia-driver.{i686,x86_64} -y
	if ! grep -q "$SEARCH_TEXT" "$FILE"; then
		echo "$ADDITIONAL_TEXT" >> "$FILE"
	fi
	echo "Finished RPMFusion Nvidia drivers."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

amd()  {
	clear
	echo ""
	run_sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
	run_sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
	run_sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y
	run_sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y
	run_sudo dnf install rocminfo rocm-opencl rocm-clinfo rocm-hip -y
	echo "Finished setting up AMD GPU."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

intel()  {
	clear
	echo ""
	run_sudo dnf install xorg-x11-drv-intel -y
	run_sudo dnf install intel-media-driver -y
	echo "Finished setting up Intel GPU."
	echo ""
	read -r -n 1 -s -p 'Press any key to return to the main menu'
	clear
	mainmenu
}

mainmenu() {
	clear
	echo "Press 1 to update your system - Start Here"
	echo "Press 2 to uninstall unused applications"
	echo "Press 3 to setup RPMfusion and install Fedora applications"
	echo "Press 4 to install Flathub applications"
#	echo "Press 5 to set system tweaks"
	echo "Press n to install Nvidia driver for media and CUDA"
	echo "Press a to setup AMD GPU for ROCm, VDPU and VAAPI"
	echo "Press i to setup Intel GPU Hardware Acceleration"
	echo "Press x to exit the script"
	read -r -n 1 -p "Input Selection:" mainmenuinput
	case "$mainmenuinput" in
		1)  updates ;;
		2)  uninstall ;;
		3)  rpmfusion ;;
		4)  flathub ;;
#		5)  tweaks ;;
		a|A)  amd ;;
		i|I)  intel ;;
		n|N)  nvidia ;;
		x|X)  quit ;;
		*)
			echo "You have entered an invalid selection!"
			echo "Please try again."
			echo ""
			read -r -n 1 -s -p "Press any key to continue."
			echo ""
			clear
			mainmenu
			;;
	esac
}

mainmenu