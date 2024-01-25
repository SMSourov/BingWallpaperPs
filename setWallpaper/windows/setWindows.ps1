# The following programming block is taken from
# Joe Espitia.
# https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/


# The next function is used for Windows OS.
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
    Write-Output $ret # To remove the warning shown in the vs code for $ret
}

# Get the current locations.
# $curDir = Get-Location

# Write-Output $curDir
$image_name = $args[0]

# $FHD_filepath = "$curDir\$image_name"
$FHD_filepath = $image_name
$LNK = $args[1]
$UHD = $args[2]
$FHD = $args[3]
$FHD_title = $args[4]
$FHD_info_url = $args[5]

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

if (Test-Path $FHD_filepath) {
    Write-Output "The FHD image file was found."
}
else {
    Write-Output "The image file is missing."
}

# For Windows
# Use: Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
# Styles: Fill, Fit, Stretch, Tile, Center, Span
if ($FHD -eq "T") {
    # There is no way that the wallpaper is applied 
    # without being downloaded. As the wallpaper is downloaded, 
    # it can be applied.
    Set-WallPaper -Image "$FHD_filepath" -Style Fill
}

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
# $message = ""
$attributionMessage = ""

# Using switch statements
Switch ($LNK + $UHD + $FHD) {
    "FFF" {
        $attributionMessage = 1
        # $Message = "Everything is already saved. Nothing to do." 
        $attributionMessage = "Nothing saved."
        break
    }
    "FFT" {
        $attributionMessage = 2
        # $message = "The FHD picture was saved and the wallpaper is now updated." 
        $attributionMessage = "FHD"
        break
    }
    "FTF" {
        $attributionMessage = 3
        # $message = "The UHD picture was saved." 
        $attributionMessage = "UHD"
        break
    }
    "FTT" {
        $attributionMessage = 4
        # $message = "The pictures were saved and the wallpaper is now updated." 
        $attributionMessage = "UHD + FHD"
        break
    }
    "TFF" {
        $attributionMessage = 5
        # $message = "The LNK file was saved." 
        $attributionMessage = "LNK"
        break
    }
    "TFT" {
        $attributionMessage = 6
        # $message = "The LNK file and FHD picture was saved and wallpaper is now updated." 
        $attributionMessage = "LNK + FHD"
        break
    }
    "TTF" {
        $attributionMessage = 7
        # $message = "The LNK file and UHD picture was saved." 
        $attributionMessage = "LNK + UHD"
        break
    }
    "TTT" {
        $attributionMessage = 8
        # $message = "Today's Bing wallpaper was saved and the wallpaper is now updated." 
        $attributionMessage = "Everything saved."
        break
    }
}

# The default execution policy of windows built in 
# powershell will not allow it to run. That's why 
# the execution policy must be bypassed in order 
# to run the script.
# powershell -ExecutionPolicy Bypass .\notification.ps1 "$Message"
$FHD_filepath = $FHD_filepath.ToString().Replace("©", "ReplaceSymbolCopyright").Replace(" ", "ReplaceSymbolSpace").Replace(",", "ReplaceSymbolComma").Replace("'", "ReplaceSymbolApostrophe")
$FHD_title = $FHD_title.ToString().Replace("©", "ReplaceSymbolCopyright").Replace(" ", "ReplaceSymbolSpace").Replace(",", "ReplaceSymbolComma").Replace("'", "ReplaceSymbolApostrophe")
$attributionMessage = $attributionMessage.ToString().Replace(" ", "ReplaceSymbolSpace")

powershell -ExecutionPolicy Bypass .\windowsNotification.ps1 $FHD_filepath "'$FHD_title'" "'$FHD_info_url'" $attributionMessage

