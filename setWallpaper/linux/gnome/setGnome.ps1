# gsettings set org.gnome.desktop.background picture-uri $FHD_filepath

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

# # Get the current gnome theme
# $theme = gsettings get org.gnome.desktop.interface color-scheme
# $isDark = ""

# if ($theme -eq "`'prefer-light`'") {
#     Write-Output "The current theme is light theme"
#     $isDark = "F"
# }
# elseif ($theme -eq "`'prefer-dark`'") {
#     Write-Output "The current theme is dark theme"
#     $isDark = "T"
# }

# # Apply the wallpaper on the appropriate theme
# if ($isDark -eq "F") {
#     gsettings set org.gnome.desktop.background picture-uri $FHD_filepath
# }
# elseif ($isDark -eq "T") {
#     Write-Output "The FHD file is: $FHD_filepath"
#     gsettings set org.gnome.desktop.background picture-uri-dark $FHD_filepath
# }
# Write-Output "file path: $FHD_filepath"
gsettings set org.gnome.desktop.background picture-uri "$FHD_filepath"
gsettings set org.gnome.desktop.background picture-uri-dark "$FHD_filepath"

# Incase of the null values, define default values
if ($null -eq $FHD) {
    $FHD = "T"
}
if ($null -eq $UHD) {
    $UHD = "F"
}
if ($null -eq $LNK) {
    $LNK = "F"
}

# Prepare the proper notification message
# The mini map is 
# FFF = NOTHING HAPPENED
# FFT = THE FHD PICTURE WAS SAVED AND THE WALLPAPER IS NOW UPDATED
# FTF = THE UHD PICTURE WAS SAVED
# FTT = THE PICTURES WERE SAVED AND THE WALLPAPER IS NOW UPDATED 
# TFF = THE LNK FILE WAS SAVED
# TFT = THE LNK FILE AND FHD PICTURE WAS SAVED AND WALLPAPER IS NOW UPDATED
# TTF = THE LNK FILE AND UHD PICTURE WAS SAVED
# TTT = TODAY'S BING WALLPAPER WAS SAVED AND THE WALLPAPER IS NOW UPDATED

# Variable to print the message
$Message = ""

# Using switch statements
Switch ($LNK + $UHD + $FHD) {
    "FFF" {
        # $Message = "Everything is already saved. Nothing to do."
        Write-Output "Everything is saved. Nothing to do"
    }
    "FFT" { $Message = "The FHD picture was saved and the wallpaper is now updated." }
    "FTF" { $Message = "The UHD picture was saved." }
    "FTT" { $Message = "The pictures were saved and the wallpaper is now updated." }
    "TFF" { $Message = "The LNK file was saved." }
    "TFT" { $Message = "The LNK file and FHD picture was saved and wallpaper is now updated." }
    "TTF" { $Message = "The LNK file and UHD picture was saved." }
    "TTT" { $Message = "The Bing wallpaper was saved and the wallpaper is now updated." }
}

# Show the notification
# python3 notification.py "BingWallpaperPs" $Message

& ../notify-call -u normal -a "BingWallpaperPs" -i "$PWD/../BingWallpaperPs.png" -p "BingWallpaperPs" "$Message"