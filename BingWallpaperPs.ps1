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

# Creating three boolean variables to determine which files 
# have been downloaded. These will be used to notify users 
# which files have been downloaded. By default, the values 
# false as they have not been downloaded yet.
$FHD = "F"
$UHD = "F"
$LNK = "F"

# Check whether the user already have the wallpaper
# or not. This can be verified by checking whether 
# the file or wallpaper is present or not.
if (Test-Path $FHD_filepath) {
    Write-Host "The FHD file exist. So, the FHD file will not be downloaded."
}
else {
    # Downlaod the FHD file.
    Invoke-WebRequest -Method Get -Uri "$FHD_fileurl" -OutFile "$FHD_filepath"
    $FHD = "T" # Means, the FHD file has been downloaded.
}

if (Test-Path $UHD_filepath) {
    Write-Host "The UHD file exist. So, the UHD file will not be downloaded."
}
else {
    # Download the UHD file.
    Invoke-WebRequest -Method Get -Uri "$UHD_fileurl" -OutFile "$UHD_filepath"
    $UHD = "T" # Means, the FHD file has been downloaded.
}

if (Test-Path $LNK_filepath) {
    Write-Host "The LNK file exist. So, the wallpaper not be downloaded and applied."
}
else {
    # Save the informations in the LNK file.
    Add-Content -Path $LNK_filepath -Encoding utf8 -Value "Title of the image:
$body.images[0].copyright

More information of the image:
$body.images[0].copyrightlink

Date of the image(YYYYMMDD):
$body.images[0].startdate

The base URL of the image:
$body.images[0].urlbase

Download link of the FHD file:
$FHD_fileurl

Download link of the UHD file:
$UHD_fileurl

Powershell command to download the FHD file:
Invoke-WebRequest -Method Get -Uri `"$FHD_fileurl`" -OutFile `"$FHD_filename`"

Powershell command to download the UHD file:
Invoke-WebRequest -Method Get -Uri `"$UHD_fileurl`" -OutFile `"$UHD_filename`""
    $LNK = "T" # Means, the FHD file has been saved.
}

# Set the picture as desktop background image.
if ($IsLinux) {
    # Go to the linux directory
    Set-Location .\setWallpaper\linux

    pwsh neofetch.ps1 $FHD_filepath $FHD $UHD $LNK

    # Get back to the working directory
    Set-Location ..\..
}

if ($IsWindows) {
    # Go to the setWallpaper directory
    Set-Location .\setWallpaper\windows

    pwsh setWindows.ps1 $FHD_filepath $LNK $UHD $FHD $body.images[0].copyrightlink

    # Get back to the working directory
    Set-Location ..\..
}