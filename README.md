## BingWallpaperPs
Download Bing wallpaper via PowerShell.

As this is a PowerShell file, PowerShell v7 or higher has to be installed in order to run this script file.
In the case of Linux OS, I would highly recommend you to avoid the snap version and use the github release versions. More over after installing Powershell, you have to set the capabilities of powershell by running this command,

`sudo setcap cap_net_raw=eip /$location_of_pwsh/pwsh`

For example: If you install Powershell v7.x.y (deb/rpm), the command would be,

`sudo setcap cap_net_raw=eip /opt/microsoft/powershell/7/pwsh`

It is needed as my script checks whether the user has internet connection or not. 

This script file can be used in Windows and Linux. It won't have any problem and the file name will be same at both OSs.

Dependencies:
- For Windows:
	- Powershell v7 or later versions
- For Linux OS
	- Powershell v7 or later versions
	- `neofetch` (It is needed to determine the desktop environment.)

On Windows and on Linux, the command would be 

`pwsh BingWallpaperPs.ps1`

For Linux OS, the following desktop environments are supported.
- GNOME (Tested on Ubuntu 22.04.)
- KDE Plasma (Tested on Kubuntu 22.04.)
- Unity (Tested on Ubuntu Unity 22.10.)
- Budgie (Tested on Ubuntu Budgie 22.04.)
- Cinnamon (Tested on Linux Mint 20.3 Uma Cinnamon editon.)
- MATE (Tested on Ubuntu MATE 22.04.)
- Deepin (Tested on AcroLinux 22.11.02 having Deepin 20.6 environment. I don't know why but it is not working in Deepin 20.8.)
- LXDE (Tested on Fedora LXDE 36.)
- LXQt (Tested on Lubuntu 22.04.)

This is a forked project. This was forked from [caressofsteel](https://github.com/caressofsteel/bingwallpaper). I've made my own changes to enhance the functionality of the program.

The BashFile.sh and TashScheduler.ps1 was made for the Linux OSs in mind as they don't a program like the Windows Task Scheduler. It was made to solve that issue.

It is highly recommended to use this program for personal and non-commercial use only. Keep in mind, according to Bing's website, "Use of this image is restricted to wallpaper only".
