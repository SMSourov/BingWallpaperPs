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
if (Test-Path $curDir\$folderName)
{
    # Write-Host "The folder already exist."
    Set-Location $curDir\$folderName
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
    Set-Location $curDir\$folderName
    New-Item "FHD" -ItemType Directory
    New-Item "UHD" -ItemType Directory
}
#Set-Location $curDir
#Set-Location ".\Bing wallpaper\FHD\"
#echo $PWD
#echo "Before the invoke request"

#echo "After the invoke request"
$filepath =  "$curDir\Bing wallpaper\FHD\" + $filename
$UHD_filepath =  "$curDir\Bing wallpaper\UHD\" + $UHD_filename

Invoke-WebRequest -Method Get -Uri $fileurl -OutFile  $filepath
Invoke-WebRequest -Method Get -Uri "$UHD_fileurl" -OutFile "$UHD_filepath"

