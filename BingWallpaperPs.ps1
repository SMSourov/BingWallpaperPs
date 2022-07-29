Function Set-WallPaper {
 
    <#
     
        .SYNOPSIS
        Applies a specified wallpaper to the current user's desktop
        
        .PARAMETER Image
        Provide the exact path to the image
     
        .PARAMETER Style
        Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)
      
        .EXAMPLE
        Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
        Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
      
    #>
     
    param (
        [parameter(Mandatory = $True)]
        # Provide path to image
        [string]$Image,
        # Provide wallpaper style that you would like applied
        [parameter(Mandatory = $False)]
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style
    )
     
    $WallpaperStyle = Switch ($Style) {
      
        "Fill" { "10" }
        "Fit" { "6" }
        "Stretch" { "2" }
        "Tile" { "0" }
        "Center" { "0" }
        "Span" { "22" }
      
    }
     
    If ($Style -eq "Tile") {
     
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
     
    }
    Else {
     
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
     
    }
     
    Add-Type -TypeDefinition @" 
    using System; 
    using System.Runtime.InteropServices;
      
    public class Params
    { 
        [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
        public static extern int SystemParametersInfo (Int32 uAction, 
                                                       Int32 uParam, 
                                                       String lpvParam, 
                                                       Int32 fuWinIni);
    }
"@ 
      
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
      
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
      
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

# BING API
# ($uri is created)
$uri = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-WW"

# Get the image metadata and temporarily store it
# ($response is created)
$response = Invoke-WebRequest -Method Get -Uri $uri

# Extrect the image metadata
# ($body and $fileurl is created)
$body = ConvertFrom-Json -InputObject $response.Content
$fileurl = "https://www.bing.com/" + $body.images[0].url

# Try to get the UHD version if available
# This basically replaces "1920x1080" with UHD
# from the $fileurl
# ($UHD_fileurl is created)
$UHD_fileurl = $fileurl.Replace("1920x1080", "UHD")
#echo $body.images

# Determine filename for both HD & UHD images
# I had to edit to resolve the file access denied problem.
$filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("-", " ").TrimEnd(' ') + "_HD.jpg"
$UHD_filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("-", " ").TrimEnd(' ') + "_UHD.jpg"
# In the original code the lines were like
#$filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('-(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("-", " ").TrimEnd(' ') + "_HD.jpg"
#$UHD_filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('-(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("-", " ").TrimEnd(' ') + "_UHD.jpg"

# Get the current directory
$curDir = Get-Location

# Check if there is a folder named "Bing Wallpapers". 
# If the folder doesn't exist, create the folder.
# Also, if the folder exist, check whether FHD and UHD.
# folder exitst or not. if not, create 2 folders named FHD and UHD.
$folderName = "Bing wallpaper"
if (Test-Path $curDir/$folderName)
{
    # Write-Host "The folder already exist."
    Set-Location $curDir/$folderName
    # FHD
    if (Test-Path "FHD")
    {
        Write-Host "The FHD folder already exist."
    }
    else
    {
        New-Item "FHD" -ItemType Directory
    }
    # UHD
    if (Test-Path "FHD")
    {
        Write-Host "The UHD folder already exist."
    }
    else
    {
        New-Item "UHD" -ItemType Directory
    }
}
else
{
    New-Item $folderName -ItemType Directory
    # Write-Host "The folder is created."
    Set-Location $curDir/$folderName
    New-Item "FHD" -ItemType Directory
    New-Item "UHD" -ItemType Directory
}
#Set-Location $curDir
#Set-Location ".\Bing wallpaper\FHD\"
#echo $PWD
#echo "Before the invoke request"

#echo "After the invoke request"
$filepath =  "$curDir/Bing wallpaper/FHD/" + $filename
$UHD_filepath =  "$curDir/Bing wallpaper/UHD/" + $UHD_filename

Invoke-WebRequest -Method Get -Uri $fileurl -OutFile  $filepath
Invoke-WebRequest -Method Get -Uri "$UHD_fileurl" -OutFile "$UHD_filepath"


# Set the picture as desktop background image.
# Only the given desktop environments will be supported.
# The commands given below are taken from 
# https://github.com/pgc062020/DailyDesktopWallpaperPlus/blob/master/setwallpaper.cpp

# Every OS/DE I've tested were the latest at the time of testing.
# GNOME (Tested on Ubuntu 22.04.)
gsettings set org.gnome.desktop.background picture-uri $filepath
# Budgie (Tested on Ubuntu Budgie 22.04)
# gsettings set org.gnome.desktop.background picture-uri file://$filepath
# Cinnamon (Tested on Linux 20.3 Uma Cinnamon edition.)
# gsettings set org.cinnamon.desktop.background picture-uri file://$filepath
# MATE (Tested on Ubuntu MATE 22.04.)
# gsettings set org.mate.background picture-filename $filepath
# Deepin (Not working.)
# gsettings set com.deepin.wrap.gnome.desktop.background picture-uri $filepath
# Unity (Not tested.)
# gsettings set org.gnome.desktop.background picture-uri $filepath
# KDE (Tested on Kubuntu 20.04.)
# plasma-apply-wallpaperimage $filepath

# For Windows
# Use: Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
# Styles: Fill, Fit, Stretch, Tile, Center, Span
# Set-WallPaper -Image "$filepath" -Style Fill
