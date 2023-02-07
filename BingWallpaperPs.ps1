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


# Check whether the user has internet 
# connection or not.


# Give a URL which would stay online 
# everytime. For this case, I'll 
# use Bing website as I'll download 
# Bing wallpaper of the day. 
$URL = "www.bing.com"


# Trap the process inside an infinity 
# loop. For this case, I'll use 
# while loop.
while (1) {


    # If the user has internet connection and 
    # the website is online then the next 
    # line would return "True", if not then 
    # it would return "False".
    $hasInternetConnection = Test-Connection -TargetName $URL -Ping -Count 1 -Quiet


    # If it returns "True" then tell the user 
    # something and proceed to the next tasks 
    if ($hasInternetConnection -eq "True") {
        Write-Output "Your internet connection is OK."
        Write-output "Proceeding to the next steps."

        
        # Break the loop.
        break
    }


    # If it returns "False" then tell the user 
    # something and go the next loop after a 
    # certain amount of time. For this case, 
    # I'll go the next loop after 1 minute. 
    else {
        Write-Output "Check your internet connection"


        # Enter the wait time in seconds. I'll give 
        # 60 as 60 seconds mean 1 minute.
        Start-Sleep -Seconds 60
    }
}


# BING API
# ($uri is created)
$uri = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-WW"

# Get the image metadata and temporarily store it
# ($response is created)
$response = Invoke-WebRequest -Method Get -Uri $uri

# Extrect the image metadata
# ($body and $FHD_fileurl is created)
$body = ConvertFrom-Json -InputObject $response.Content
$FHD_fileurl = "https://www.bing.com" + $body.images[0].url

# Try to get the UHD version if available
# This basically replaces "1920x1080" with UHD
# from the $FHD_fileurl
# ($UHD_fileurl is created)
$UHD_fileurl = $FHD_fileurl.Replace("1920x1080", "UHD")
# echo $body.images

# Determine filename for both HD & UHD images
# I had to edit to resolve the file access denied problem in the Linux OS.
$FHD_filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("/", ", ").Replace("-", " ").TrimEnd(' ') + "_FHD.jpg"
$UHD_filename = $body.images[0].startdate + " - " + $body.images[0].copyright.Split('(', 2)[-2].Replace(" ", "-").Replace("?", "").Replace("/", ", ").Replace("-", " ").TrimEnd(' ') + "_UHD.jpg"
$LNK_filename = $body.images[0].startdate + "_LNK.txt"

# Get the current directory
$curDir = Get-Location

# Check if there is a folder named "Bing Wallpapers". 
# If the folder doesn't exist, create the folder.
# Also, if the folder exist, check whether FHD and UHD.
# folder exitst or not. if not, create 2 folders named FHD and UHD.
$folderName = "Bing wallpaper"
if (Test-Path $curDir/$folderName) {
    # Write-Host "The folder already exist."
    Set-Location $curDir/$folderName
    # FHD
    if (Test-Path "FHD") {
        Write-Host "The FHD folder already exist."
    }
    else {
        New-Item "FHD" -ItemType Directory
    }
    # UHD
    if (Test-Path "FHD") {
        Write-Host "The UHD folder already exist."
    }
    else {
        New-Item "UHD" -ItemType Directory
    }
    # LINKSN
    if (Test-Path "LNK") {
        Write-Host "The LNK folder already exist."
    }
    else {
        New-Item "LNK" -ItemType Directory
    }
}
else {
    New-Item $folderName -ItemType Directory
    # Write-Host "The folder is created."
    Set-Location $curDir/$folderName
    New-Item "FHD" -ItemType Directory
    New-Item "UHD" -ItemType Directory
    New-Item "LNK" -ItemType Directory
}
# Set-Location $curDir
# Set-Location ".\Bing wallpaper\FHD\"
# echo $PWD
# echo "Before the invoke request"

# echo "After the invoke request"
$FHD_filepath = "$curDir/Bing wallpaper/FHD/" + $FHD_filename
$UHD_filepath = "$curDir/Bing wallpaper/UHD/" + $UHD_filename
$LNK_filepath = "$curDir/Bing wallpaper/LNK/" + $LNK_filename

# Get back to the working directory from where the 
# script was launched
Set-Location -Path ..

# Check whether the user already have the wallpaper
# or not. This can be verified by checking whether 
# the file or wallpaper is present or not.
if (Test-Path $FHD_filepath) {
    Write-Host "The FHD file exist. So, the FHD file will not be downloaded."
}
else {
    # Downlaod the FHD file.
    Invoke-WebRequest -Method Get -Uri "$FHD_fileurl" -OutFile "$FHD_filepath"
}

if (Test-Path $UHD_filepath) {
    Write-Host "The UHD file exist. So, the UHD file will not be downloaded."
}
else {
    # Download the UHD file.
    Invoke-WebRequest -Method Get -Uri "$UHD_fileurl" -OutFile "$UHD_filepath"
}

if (Test-Path $LNK_filepath) {
    Write-Host "The LNK file exist. So, the wallpaper not be downloaded and applied."
}
else {
    # Save the informations in the LNK file.
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Title of the image:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $body.images[0].copyright
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "More information of the image:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $body.images[0].copyrightlink
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Date of the image(YYYYMMDD):"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $body.images[0].startdate
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "The base URL of the image:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $body.images[0].urlbase
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Download link of the FHD file:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $FHD_fileurl
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Download link of the UHD file:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value $UHD_fileurl
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Powershell command to download the UHD file:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Start-BitsTransfer -Source `"$FHD_fileurl`" -Destination `"$FHD_filename`""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value ""
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Powershell command to download the UHD file:"
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Start-BitsTransfer -Source `"$UHD_fileurl`" -Destination `"$UHD_filename`""
    # Set the picture as desktop background image.
    if ($IsLinux) {
        # Only the given desktop environments will be supported.
        # The commands given below are taken from 
        # https://github.com/pgc062020/DailyDesktopWallpaperPlus/blob/master/setwallpaper.cpp
    
        # Detect the desktop environment that the 
        # user have in it's OS.
    
        # Make a function to get the minimal output
        # of neofetch.
        function neofetchMinimal {
            neofetch --disable memory gpu cpu wm theme shell resolution icons packages uptime kernel --os_arch off --de_version off --stdout
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
        $desktop_environment = $desktop_environment_info.ToString().Substring(4)
    
        # Trim the whitespaces from the variable
        $desktop_environment = $desktop_environment.Trim()
    
        # Lower all of the character of the string.
        # This will make the conditions easier to 
        # implement.
        $desktop_environment = $desktop_environment.ToLower()
    
    
        if ($desktop_environment -eq "gnome") {
            Write-Output "It has detected GNOME desktop environment."
            # GNOME (Tested on Ubuntu 22.04.)
            gsettings set org.gnome.desktop.background picture-uri $FHD_filepath
            # Not sure why but at the time of testing this on, 
            # Visual Studio Code flatpak, it kept detecting 
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
    }
    
    if ($IsWindows) {
        # For Windows
        # Use: Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
        # Styles: Fill, Fit, Stretch, Tile, Center, Span
        Set-WallPaper -Image "$FHD_filepath" -Style Fill
    
        # Create a new file. It will be used to send a notification
        # in windows PC.
        New-Item -ItemType File -Name notification.ps1
    
        # The following block will write a powershell file 
        # which will be run by the windows built in powershell.
        # It will write this code,
        # https://gist.github.com/dend/5ae8a70678e3a35d02ecd39c12f99110
        # of this link. It will be used to send a toast notification 
        # to let the user know that the desktop wallpaper has been 
        # updated. I tried to find a easier solution but I couldn't 
        # find any.
    
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "function Show-Notification {"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    [cmdletbinding()]"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    Param ("
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "        [string]"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "        `$ToastTitle,"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "        [string]"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "        [parameter(ValueFromPipeline)]"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "        `$ToastText"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    )"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > `$null"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$RawXml = [xml] `$Template.GetXml()"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    (`$RawXml.toast.visual.binding.text|where {`$_.id -eq `"1`"}).AppendChild(`$RawXml.CreateTextNode(`$ToastTitle)) > `$null"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    (`$RawXml.toast.visual.binding.text|where {`$_.id -eq `"2`"}).AppendChild(`$RawXml.CreateTextNode(`$ToastText)) > `$null"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$SerializedXml.LoadXml(`$RawXml.OuterXml)"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Toast = [Windows.UI.Notifications.ToastNotification]::new(`$SerializedXml)"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Toast.Tag = `"PowerShell`""
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Toast.Group = `"PowerShell`""
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(`"PowerShell`")"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "    `$Notifier.Show(`$Toast);"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "}"
        Add-Content -Path notification.ps1 -Encoding utf8 -Value "Show-Notification `"The desktop wallpaper has been updated.`""
    
        # The default execution policy of windows built in 
        # powershell will not allow it to run. That's why 
        # the execution policy must be bypassed in order 
        # to run the script.
        powershell -ExecutionPolicy Bypass .\notification.ps1
    
        # As the work is done, there is no need to keep
        # the file. Delete the file.
        Remove-Item notification.ps1
    }
}
