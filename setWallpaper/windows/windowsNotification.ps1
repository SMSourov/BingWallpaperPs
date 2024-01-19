# windowsNotification.ps1 $FHD_filepath $title $info_link $title $attributionMessage
$FHD_filepath = $args[0]
$title = $args[1]
$infoLink = $args[2]
$attributionMessage = $args[3]

# Apply bug fixes
$FHD_filepath = $FHD_filepath.Replace("ReplaceSymbolSpace", " ").Replace("/", "\").Replace("ReplaceSymbolComma", ",")
# $title = $title.ToString().Replace("ReplaceSymbolCopyright", "©").Replace("ReplaceSymbolSpace", " ").Replace("ReplaceSymbolComma", ",")
$title = $title.ToString().Replace("ReplaceSymbolCopyright", "(c)").Replace("ReplaceSymbolSpace", " ").Replace("ReplaceSymbolComma", ",")
$attributionMessage = $attributionMessage.ToString().Replace("ReplaceSymbolSpace", " ")

Write-Output "
FHD : $FHD_filepath
title : $title
link : $infoLink
attribution : $attributionMessage
"

$toastImageNotification = [Windows.UI.Notifications.ToastTemplateType, Windows.UI.Notifications, ContentType = WindowsRuntime]::ToastText01
$toastImageNotificationXML = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::GetTemplateContent($toastImageNotification)

$line1 = "BingWallpaperPs"
$line2 = $title
# $line2 = "This is the second line"
$line3 = $attributionMessage
# $line3 = "This is an attribuito message"
$buttonText1 = "More info on the subject"

# Define the image paths
$imagePath = $FHD_filepath
# $imagePath = "C:\Users\Sourov\temp\20231212 - Red poinsettias_FHD.jpg"
# echo $PWD
$iconPath = "$PWD\BingWallpaperPs.png"

# Predefine the $AppId. This will increase the exectution speed.
$AppId = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"


# Change the template from ToastText01 to ToastGeneric
$toastImageNotificationXML.SelectSingleNode('//binding').SetAttribute('template', 'ToastGeneric')

# Set the statement of $line2 in the text element where id="1"
$toastImageNotificationXML.SelectSingleNode('//text[@id="1"]').InnerText = $line1


# Create new element for $line2
$text2 = $toastImageNotificationXML.CreateElement('text')
$text2.SetAttribute('id', '2')
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($text2) | Out-Null
$toastImageNotificationXML.SelectSingleNode('//text[@id="2"]').InnerText = $line2


# Create new element for $line3
$text3 = $toastImageNotificationXML.CreateElement('text')
$text3.SetAttribute('id', '3')
$text3.SetAttribute('placement', 'attribution')
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($text3) | Out-Null
$toastImageNotificationXML.SelectSingleNode('//text[@id="3"]').InnerText = $line3


# Create new element for the app icon
$icon = $toastImageNotificationXML.CreateElement('image')
$icon.SetAttribute('id', '1')
$icon.SetAttribute('src', $iconPath)
$icon.SetAttribute('placement', 'appLogoOverride')
$icon.SetAttribute('hint-crop', 'unspecified')
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($icon) | Out-Null


# Create new element for the hero image
$image = $toastImageNotificationXML.CreateElement('image')
$image.SetAttribute('id', '2')
$image.SetAttribute('src', $imagePath)
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($image) | Out-Null



# Create the actions element in the toast element tag
$actions = $toastImageNotificationXML.CreateElement('actions')
$toastImageNotificationXML.SelectSingleNode('//toast').AppendChild($actions) | Out-Null

# Create an action element in the actions element tag
$action1 = $toastImageNotificationXML.CreateElement('action')
$action1.SetAttribute('content', $buttonText1)
$action1.SetAttribute('activationType', 'protocol')
$action1.SetAttribute('arguments', $infoLink)
# $action1.SetAttribute('arguments', 'https://www.google.com')
$toastImageNotificationXML.SelectSingleNode('//actions').AppendChild($action1) | Out-Null


# Preview the XML file and store it in temp.html file
# $toastImageNotificationXML.GetXml()

# Send the toast notification
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($toastImageNotificationXML)
