# Capture the flags.
$LNK = $args[0]
$UHD = $args[1]
$FHD = $args[2]
# Capture the FHD filepath.
$FHD_filepath = $args[3]
# Capture the FHD title.
$FHD_title = $args[4]
# Capture the FHD info url.
$FHD_info_url = $args[5]

# Only the given desktop environments will be supported.
# The commands given below are taken from 
# https://github.com/pgc062020/DailyDesktopWallpaperPlus/blob/master/setwallpaper.cpp

# Detect the desktop environment that the
# user have in it's OS.

# Make a function to get the minimal output
# of neofetch.
function neofetchMinimal {
    & ./neofetch.sh --disable memory gpu cpu wm theme shell resolution icons packages uptime kernel --os_arch off --de_version off --stdout
    # In this command, Memory, GPU, CPU, WM,
    # Theme, Shell, Resolution, Icons, Packages, 
    # Uptime, Kernel, OS architecture, Desktop 
    # Environment version, Distro icon, Text 
    # color and bold text will not be shown. 
    # Only username, hostname, the seperator line 
    # OS, Host, DE, Terminal will be shown.
}

# Every OS/DE I've tested were the latest at the time of testing.

# Get the minimal output and get get minimal 
# output to an array variable
[array] $information = neofetchMinimal

# Copy the fifth value of the array to a 
# new variable. This line contains the 
# name of the desktop environment.
$desktop_environment_info = $information[4]

# Trim the first "DE: " and put the all 
# of the string in a new variable. It will 
# make thing easy. Firstly, you have to save 
# the value to a string type variable and 
# trim the first 4 characters.
# $desktop_environment = $desktop_environment_info.ToString().Substring(4)
$desktop_environment = $desktop_environment_info.ToString().Replace("DE: ", "")

# Trim the whitespaces from the variable
$desktop_environment = $desktop_environment.Trim()

# Lower all of the character of the string.
# This will make the conditions easier to 
# implement.
$desktop_environment = $desktop_environment.ToLower()

# Remove " (wayland)" if exist.
$desktop_environment = $desktop_environment.ToString().Replace(" (wayland)", "")
# Write-Output "de is $desktop_environment"

if ($desktop_environment -eq "gnome") {
    Write-Output "It has detected GNOME desktop environment."
    # GNOME (Tested on Ubuntu 22.04.)
    # gsettings set org.gnome.desktop.background picture-uri $FHD_filepath

    # Go to the GNOME directory
    Set-Location gnome

    pwsh setGnome.ps1 $LNK $UHD $FHD $FHD_filepath $FHD_title $FHD_info_url

    # Get back to the working directory
    Set-Location ..

    # Not sure why but at the time of testing this on, 
    # Visual Studio Code, it kept detecting 
    # the desktop environment as Unity Desktop 
    # Environment. But when this was run from GNOME 
    # Terminal(not flatpak or snap), it detected the 
    # desktop environment as GNOME Desktop Environment.
}

if ($desktop_environment -eq "plasma") {
    Write-Output "It has detected KDE Plasma desktop environment."
    # KDE (Tested on Kubuntu 22.04.)
    plasma-apply-wallpaperimage $FHD_filepath
}

if ($desktop_environment -eq "unity") {
    Write-Output "It has detected Unity desktop environment."
    # Unity (Tested on Ubuntu Unity 22.10.)
    gsettings set org.gnome.desktop.background picture-uri file://$FHD_filepath
}

if ($desktop_environment -eq "budgie") {
    Write-Output "It has detected Budgie desktop environment"
    # Budgie (Tested on Ubuntu Budgie 22.04)
    gsettings set org.gnome.desktop.background picture-uri file://$FHD_filepath
}

if ($desktop_environment -eq "cinnamon") {
    Write-Output "It has detected Cinnamon desktop environment."
    # Cinnamon (Tested on Linux Mint 20.3 Uma Cinnamon edition.)
    gsettings set org.cinnamon.desktop.background picture-uri file://$FHD_filepath
}

if ($desktop_environment -eq "mate") {
    Write-Output "It has detected MATE desktop environment."
    # MATE (Tested on Ubuntu MATE 22.04.)
    gsettings set org.mate.background picture-filename $FHD_filepath
}

if ($desktop_environment -eq "deepin") {
    Write-Output "It has detected Deepin desktop environment."
    # Deepin (Tested on AcroLinux 22.11.02 Deepin 20.6 environment)
    # I couldn't make it work in Deepin 20.8.
    # Same goes for the previous releases.
    gsettings set com.deepin.wrap.gnome.desktop.background picture-uri file://$FHD_filepath
}

if ($desktop_environment -eq "lxqt") {
    Write-Output "It has detected LXQt desktop environment"
    # LXQt (Tested on Lubuntu 22.04.)
    pcmanfm-qt --set-wallpaper="$FHD_filepath"
}

if ($desktop_environment -eq "lxde") {
    Write-Output "It has detected LXDE desktop environment."
    # LXDE (Tested on Fedora LXDE 36.)
    pcmanfm --set-wallpaper="$FHD_filepath"
}
