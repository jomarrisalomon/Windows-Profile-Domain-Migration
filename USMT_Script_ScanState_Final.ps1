# Script is used on workstations of the OLD domain that will transfer the profiles/data to a file server
#
# BEFORE USING SCRIPT:
# 1. Ensure that the windows USMT kit is placed on the target file server so that it can download the windows USMT kit to the computer
# 2. Ensure Windows policies allow for remote file navigation
# 3. Ensure enough space is allocated on the file server for the profiles to write to
#


[CmdletBinding()]
param (
       [Parameter(Mandatory=$True)]
       [string]$TargetServer = "hostname",                             # Target File server of new domain server
       [Parameter(Mandatory=$True)]
       [string]$NewDomain = "NewDomain",                               # Target Domain name of new domain
       [Parameter(Mandatory=$True)]                           
       [string]$NewDomainAdminUsername = "NewDomainAdminUsername",     # Target Admin User of new domain
       [Parameter(Mandatory=$True)]
       [securestring]$AdminPwd = "password"                            # Target Admin User password of new domain
)

# Allow PowerShell Script execution

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Add Target file server of windows kit and domain admin credentials securely

cmdkey /add:$TargetServer /user:$NewDomain\$NewDomainAdminUsername /pass:$AdminPwd

# Set variables of old computer to allow profile copy to file server of new domain

$computer = (Get-WmiObject win32_computersystem).Name
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$WindowsVersion = [System.Environment]::OSVersion.Version | select -ExpandProperty major -First 1
$path = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\amd64"
$Userlist = "C:\Users dir"

# If the windows kit is already downloaded locally, skip

If (!(Test-Path 'C:\Program Files (x86)\Windows Kits\10\Assessment and Development Kit')){
    Write-Host -Message "Copying Windows Kit from file server..."
    Copy-Item -Path "\\$TargetServer\User_Profile_Backup\Windows Kits" -Recurse -Destination "C:\Program Files (x86)" -Force
    }
	Elseif (Test-Path 'C:\Program Files (x86)\Windows Kits\10\Assessment and Development Kit'){
        Write-Host -Message "Windows Kit Folder already installed, proceeding with script"
        continue
    } 


# Create a remote file share path to the target file server of new domain

New-PSDrive -Name "K" -PSProvider FileSystem -Root "\\$TargetServer\User_Profile_Backup"

# Changes path to the folder where profile will be created

cd $path

# Creates a folder of the OLD computer name and will input all user profiles in that folder for organization

cmd /c "scanstate \\$TargetServer\User_Profile_Backup\$computer /i:migapp.xml /i:migdocs.xml /v:13 /l:scan.log"

# Creates a .txt of all the existing users from the old computer for documentation and to call for the user profile on the loadstate script

dir C:\users | Out-File -path "\\$TargetServer\User_Profile_Backup\$computer\UserList.txt" -Force

# Disconnects and removes file path

Remove-PSDrive -Name "K"