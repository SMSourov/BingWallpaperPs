# Capture the flags
$LNK = $args[0]
$UHD = $args[1]
$FHD = $args[2]
# Capture the FHD filepath
$FHD_filepath = $args[3]
# Capture the FHD title 
$FHD_title = $args[4]
# Capture the FHD info url
$FHD_info_url = $args[5]


# Now, run the command according to OS
if ($IsWindows) {
    # Get inside the windows directory
    Set-Location windows

    # Run the command
    pwsh setWindows.ps1 $LNK $UHD $FHD $FHD_filepath $FHD_title $FHD_info_url

    # Return to the current 
    Set-Location ..
}