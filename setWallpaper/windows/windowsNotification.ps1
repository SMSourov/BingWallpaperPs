# windowsNotification.ps1 $FHD_filepath $message $info_link
$FHD_filepath = $args[0]
$message = $args[1]
$infoLink = $args[2]

# Import BurntToast module
Import-Module -FullyQualifiedName "$PWD\Modules\BurntToast"

# >> $Rightbutton = New-BTButton -Content 'Picture info' -Arguments 'https://www.starwindsoftware.com/'
# >> new-BurntToastNotification -AppLogo .\Chromium_1-6.png -Text "This is working", "The first line", "The second line" -HeroImage '.\20231212 - Red poinsettias_UHD.jpg' -Button $Rightbutton

$button = New-BTButton -Content "More info on today's subject" -Arguments "$infoLink"

$image = New-BTImage -Source "$FHD_filepath" -Align Center -Crop None

# $header = New-BTHeader -Title "something"

$column = New-BTColumn -Weight 1080

New-BurntToastNotification -HeroImage $image -Text "BingWallpaperPs", $message -AppLogo .\BingWallpaperPs.png -Button $button -Column $column
