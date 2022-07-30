# This is the task scheduler file. 

# Since there is no "Task Scheduler" 
# type program or has the full features 
# of the Windows Task Scheduler, 
# I've to make my own task scheduler 
# script that will trigger a task at 
# a specific time and won't take too 
# system resources.

# The task is to run the program at 
# 06:00 am, 06:00 pm and 60 seconds 
# after the user logs in.
# Keep in mind that it is a string 
# variable and a two character 
# string.
$HourConst = "06"
$MinuteConst = "00"

# At first, wait 60 seconds. 
Start-Sleep -Seconds 60

# Now, run the command.
# The directory where the Bing wallpaper is located.
cd /mnt/sda6/BingWallpaperPs-0.0.4

# Run the powershell file.
pwsh BingWallpaperPs.ps1
# "libnotify" is a linux program. With the help of 
# this program, a toast notification can be sent 
# via "notify-send" command.
notify-send "Wallpaper refreshed."

# Now, make a loop and trap the 
# program inside the loop. The 
# program has to run all the time. 


# In while loop, the condition 
# should be set to true.
while (1) {

    # Get the current hour and minute. I'll 
    # take it in 12 hour format because 
    # both time are the same. The difference 
    # is in am and pm.

    # Get the hour 12 hour format
    $Hour = Get-Date -Format "hh"

    # Get the minute
    $Minute = Get-Date -Format "mm"

    # Check whether the current hour is as 
    # same as your selected desired hour.
    if ($Hour -eq $HourConst) {

        # Check whether the current minute is as 
        # same as your selected desired minute.
        if ($Minute -eq $MinuteConst) {
            

            # Now, run the command.
            # The directory where the Bing wallpaper is located.
            cd /mnt/sda6/BingWallpaperPs-0.0.4

            # Run the powershell file.
            pwsh BingWallpaperPs.ps1
            notify-send "Wallpaper refreshed."

            # Now, wait 11 hours 55 minutes.
            # Because the next schedule is 
            # not in the next 11 hours.
            Start-Sleep -Seconds 42900
        }
    }

    else {
        # Let the script wait 55 seconds before 
        # going to the next loop. In this way, 
        # the program won't take too much 
        # processing power and battery while 
        # running in the background.
        Start-Sleep -Seconds 55
    }
}
