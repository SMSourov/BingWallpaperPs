# To create this templates, documents from these websites were followed
# https://learn.microsoft.com/en-us/uwp/api/windows.ui.notifications.toasttemplatetype?view=winrt-22621
# https://learn.microsoft.com/en-us/previous-versions/windows/apps/hh761494(v=win.10)
# https://learn.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/adaptive-interactive-toasts?tabs=xml
# https://www.alkanesolutions.co.uk/2023/08/29/use-powershell-to-display-a-basic-toast-notification/
# https://www.alkanesolutions.co.uk/2023/08/29/use-powershell-to-display-an-advanced-toast-notification/

# Get the template XML. Any template will do. I'm using the ToastText01 template for my simplicity
$toastImageNotification = [Windows.UI.Notifications.ToastTemplateType, Windows.UI.Notifications, ContentType = WindowsRuntime]::ToastText01
$toastImageNotificationXML = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::GetTemplateContent($toastImageNotification)

# Before doing anything, predefine the statements, image files, AppId(required)
$line1 = "BingWallpaperPs"
$line2 = "Today's wallpaper is now updated."
$line3 = "Something is better that nothing. If you thing that it is a bad idea then you are wrong. It may be a clue to anything."
$line4 = "FHD+UHD+LNK"
$buttonText1 = "More info on the subject"

# Define the image paths
# $imagePath = "C:\Users\Sourov\temp\20231212 - Red poinsettias_FHD.jpg"
# $iconPath = "C:\Users\Sourov\temp\BingWallpaperPs.png"


# Get the AppId. For this, I'm using Windows PowerShell as I'm using Windows PowerShell. Not sure any other app will do.
# $AppId = (Get-StartApps | Where Name -eq "Windows PowerShell" | Select -First 1 -ExpandProperty AppID)

# Predefine the $AppId. This will increase the exectution speed.
$AppId = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"


# Change the template from ToastText01 to ToastGeneric
$toastImageNotificationXML.SelectSingleNode('//binding').SetAttribute('template', 'ToastGeneric')

# Set the statement of $line2 in the text element where id="1"
$toastImageNotificationXML.SelectSingleNode('//text[@id="1"]').InnerText = $line1


# Create new element for $line2
$text2 = $toastImageNotificationXML.CreateElement('text')
$text2.SetAttribute('id', '2')      # Make sure to set this attribute where the id number in incremental
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($text2) | Out-Null     # Add the element inside the 'binding' element
$toastImageNotificationXML.SelectSingleNode('//text[@id="2"]').InnerText = $line2       # Set the statement of $line2 in the text element where id="2"


# Create new element for $line3
$text3 = $toastImageNotificationXML.CreateElement('text')
$text3.SetAttribute('id', '3')      # Make sure to set this attribute where the id number in incremental
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($text3) | Out-Null     # Add the element inside the 'binding' element
$toastImageNotificationXML.SelectSingleNode('//text[@id="3"]').InnerText = $line3       # Set the statement of $line2 in the text element where id="3"


# Create new element for $line4
$text4 = $toastImageNotificationXML.CreateElement('text')
$text4.SetAttribute('id', '4')      # Make sure to set this attribute where the id number in incremental
$text4.SetAttribute('placement', 'attribution')     # This will make the text appear in a smaller text.
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($text4) | Out-Null     # Add the element inside the 'binding' element
$toastImageNotificationXML.SelectSingleNode('//text[@id="4"]').InnerText = $line4       # Set the statement of $line2 in the text element where id="4"


# Create new element for the app icon
$icon = $toastImageNotificationXML.CreateElement('image')
$icon.SetAttribute('id', '1')       # Give an id
$icon.SetAttribute('src', $iconPath)    # Give the address of the icon
$icon.SetAttribute('placement', 'appLogoOverride')
# $icon.SetAttribute('hint-crop', 'circle')
$icon.SetAttribute('hint-crop', 'unspecified')
# $icon.SetAttribute('alt', "")       # If you give some information for the assistive technologies, give it in the second parameter
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($icon) | Out-Null


# Create new element for the hero image
$image = $toastImageNotificationXML.CreateElement('image')
$image.SetAttribute('id', '2')       # Give an id
$image.SetAttribute('src', $imagePath)      # Give the address of the image
# $image.SetAttribute('placement', 'hero')    # Giving attribut would place the image in the top but it would crop the bottom
# $image.SetAttribute('hint-crop', 'circle')  # This won't work if placement="hero"
# $image.SetAttribute('hint-crop', 'unspecified')
# $image.SetAttribute('alt', "")       # If you give some information for the assistive technologies, give it in the second parameter
$toastImageNotificationXML.SelectSingleNode('//binding').AppendChild($image) | Out-Null



# Create the actions element in the toast element tag
$actions = $toastImageNotificationXML.CreateElement('actions')
$toastImageNotificationXML.SelectSingleNode('//toast').AppendChild($actions) | Out-Null

# Create an action element in the actions element tag
$action1 = $toastImageNotificationXML.CreateElement('action')
$action1.SetAttribute('content', $buttonText1)
$action1.SetAttribute('activationType', 'protocol')
$action1.SetAttribute('arguments', 'https://www.google.com')
$toastImageNotificationXML.SelectSingleNode('//actions').AppendChild($action1) | Out-Null



# Preview the XML file and store it in temp.html file
$toastImageNotificationXML.GetXml()

# Send the toast notification
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($toastImageNotificationXML)
