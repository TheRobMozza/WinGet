# winget
My WinGet auto updating batch file script
About
-----

WinGet Updates.bat is an simple batchfile that uses Microsoft's WinGet command to easily and automatically download and install 3rd party software updates. 


Dependancies
------------

If you have the ability to use the 'WinGet' command then this batchfile will make updating all of your non Microsoft programs a breeze.

You can install WinGet on Windows 10 with build 1709 or newer. Winget is already embedded into the image of the current Windows 11 21H2 and Windows 10 21H1 builds.

To check if winget is installed on your computer, open a PowerShell console and run the command:

Get-AppPackage *Microsoft.DesktopAppInstaller*|select Name,PackageFullName

If not installed, you can install WinGet from the Microsoft Store (but it's called 'App Installer' there) https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1#activetab=pivot:overviewtab

For problems relating to installing winget please see possible solutions at the bottom of this text file..


Installation
------------

(1) Create a directory or drop the 'WinGet Updates.bat' file somewhere (anywhere) on your computer.
(2) Right click on the batchfile and choose Send to.. Desktop (Create Shortcut), Windows 11 users will need to first click 'Show More Options'
(3) Single left click on your new shortcut to WinGet Updates batchfile, then right click and Cut (or press Ctrl+x)
(4) Load up Windows File Explorer, ensure you have 'hidden files' visable, then navigate to:
	C:\Users\YOURUSERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Start-up\
(5) Right click on the 'free space' anywhere inside this folder and select 'Paste' (or press Ctrl+v)
(6) Your newly creaded shortcut will now be in your startup folder and will run automatically at Windows launch.


Known Issues
------------

Historically SuperAntiSpyware has failed to update/reinstall so after the main update check has occured there is a second attempt to force update/reinstall SuperAntiSpyware. Ofcourse since I implemented this SAS double check, everything seems to of resolved itself. Maybe I will be removing this double check shortly.

For whatever reason 'initdebug.nfo' file is created and the batchfile will removed on finish.


Customisation
-------------

Highly customisable, change display text, change colours, position of text, etc. You are hereby given my permission to modify this in anyway you see fit.


WinGet Installation possible solutions
--------------------------------------

To install WinGet:

- Open Microsoft Store and search for 'App Installer' application, which 'winget' is part of.

If the 'App Installer' app downloads and installs correctly, double check 'winget' is working by opening a cmd or Powershell window and typing 'winget' to see if it works or not. If not continue with these steps:

- Download the large .msixbundle file from the GitHub page:
	https://github.com/microsoft/winget-cli/releases/tag/v1.3.2691

- Double click to run the .msixbundle file..

	..If you get this error "This app package is not supported for installation by App Installer because it uses certain restricted capabilities" then you need to update something manually. In my case this was;

	"x64 processor architecture and minimum version 14.0.30704.0, along with this package to install. The frameworks with name 'Microsoft.VCLibs.140.00.UWPDesktop' currently installed are: {Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe}"

	- So, basically my Visual C libraries needed updating from 14.0.29231 to 14.0.30704

	- To update them I downloaded 'Microsoft.VCLibs.x64.14.00.Desktop.appx' from;
		https://learn.microsoft.com/en-us/troubleshoot/developer/visualstudio/cpp/libraries/c-runtime-packages-desktop-bridge#how-to-install-and-update-desktop-framework-packages

- Another method is to open Powershell as administrator, type;
	add-appxpackage "THEN WRITE THE PATH OF THE DOWNLOADED .MSIXBUNDLE FILE"
		e.g.
	add-appxpackage "C:\Users\UserAccountName\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

- Once that completes (without error) retry the command 'winget' and see if it now installed?
