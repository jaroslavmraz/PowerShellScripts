# Simple script to change ownership of folder and files inside to Admin group.
#
# Usage: ./TakeOwnerShipToAdminGroup.ps1 -dir "DIRECTORY TO CHANGE RIGHTS"
#
# v.1 Created by Jaroslav Mráz https://github.com/jaroslavmraz/

 param([string] $dir)
 
 takeown /f $dir /a /r /d Y