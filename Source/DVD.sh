#!/bin/bash
# script for Installer Mac OS X Install DVD Creator 
# chris1111

# Vars
apptitle="Mac OS X Install DVD Creator"
version="1.0" 
# Set Icon directory and file 
iconfile="/System/Library/CoreServices/Installer.app/Contents/Resources/Installer.icns"

# Confirmation Dialog
response=$(osascript -e 'tell app "System Events" to display dialog "Please read this before clicking OK\n\nNOTE: If you have already create 
Mac OS X Install DVD.iso on the desktop, it will automatically deleted by the program. ​So If you would like to create more disk images; put the images in a folder apart before continue." buttons {"Cancel", "OK"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'" ')
answer=$(echo $response | grep "OK")  

# Cancel is user does not select OK
if [ ! "$answer" ] ; then
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  exit 0
fi

if [[ $(mount | awk '$3 == "/Volumes/Mac-OSX-Install-DVD" {print $3}') != "" ]]; then
 hdiutil detach "/Volumes/Mac-OSX-Install-DVD"
fi

if [ "/Volumes/Mac OS X Install DVD" ]; then
	hdiutil detach "/Volumes/Mac OS X Install DVD"
fi

if [ "/tmp/Mac-OSX.sparseimage" ]; then
	rm -rf "/tmp/Mac-OSX.sparseimage"
fi

if [ "/$HOME/Desktop/Mac OS X Install DVD.iso" ]; then
	rm -rf "/$HOME/Desktop/Mac OS X Install DVD.iso"
fi

osascript ./Intro.app

Sleep 2


echo "**********************************************  "
echo "Starting Installer Mac OS X Install DVD!  "   
echo "**********************************************  "

Sleep 2
osascript ./Select.app

Sleep 2

echo "**********************************************  "
echo "Create sparseimage!  "   
echo "**********************************************  "
# create sparseimage
hdiutil create -size 8g -type SPARSE -fs HFS+J -volname Mac-OSX-Install-DVD -uid 0 -gid 80 -mode 1775 /tmp/Mac-OSX

echo "  "

echo "**********************************************  "
echo "Mount Installer image!  "
echo "**********************************************  "
Sleep 2
osascript -e 'display notification "Installer Mac OS X Install DVD" with title "Starting"  sound name "default"'

# Mount the dmg image
hdiutil attach -nobrowse /tmp/Mac-OSX.sparseimage

# Create the Package
pkgbuild --root ./Installer/Installer_OSX --scripts ./Installer/scripts --identifier com.Hackintosh.cloverbootloader --version 1 --install-location / Installer.pkg
echo " "
echo "**********************************************  "
echo " "
echo " "
echo "Installation  /Volumes/Mac-OSX-Install-DVD
Create /Desktop/Mac OS X Install DVD.iso 
Volume name /Mac OS X Install DVD
 
Wait, be patient! . . . "
echo " "		      
Sleep 2
# run the pkg
osascript -e 'do shell script "installer -allowUntrusted -verboseR -pkg ./Installer.pkg -target /Volumes/Mac-OSX-Install-DVD" with administrator privileges'


echo "  "
echo "**********************************************  "
echo "Unmount Installer image!  "
echo "**********************************************  "
Sleep 2
hdiutil detach -Force /tmp/Installer-OS

echo "  "
killall Finder


# remoove the pkg
rm ./Installer.pkg

echo "**********************************************  "
echo "Mount Mac OS X Install DVD!  "   
echo "**********************************************  "

osascript -e 'tell app "System Events" to display dialog "Click OK to Open Mac OS X Install DVD 
and Completed process! " with icon file "System:Library:CoreServices:CoreTypes.bundle:Contents:Resources:FinderIcon.icns" buttons {"OK"} default button 1 with title "Mac OS X Install DVD"'
echo " "
hdiutil attach ~/Desktop/"Mac OS X Install DVD.iso"

open /Volumes/"Mac OS X Install DVD"

echo "**********************************************  "
echo "Mac OS X Install DVD Done !  "
echo "**********************************************  "

