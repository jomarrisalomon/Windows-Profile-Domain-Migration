#Parameter bindings

[CmdletBinding()]
param (
       [Parameter(Mandatory=$True)]
       [string]$TargetComputer = "hostname",
       [Parameter(Mandatory=$True)]
       [string]$Olduser = "olduser",
       [Parameter(Mandatory=$True)]
       [string]$Newuser = "hostname",
       [Parameter(Mandatory=$True)]
       [securestring]$AdminPwd = "password"
)

# Ensures that powershell scripts can be used prior to running code

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Set target server that contains the Domain-User State Migration tool folder/kit

cmdkey /add:inari-srv1 /user:inaritech\storageadmin /pass:$AdminPwd

$computer = (Get-WmiObject win32_computersystem).Name
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$mutarget = ('/' + 'mu' + ':' + $olduser + ':' + 'inaritech\' + $newuser )
$path = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\amd64"
$WindowsKitPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool"

If ($WindowsKitPath -eq $false )
	{Copy-Item -Path "\\inari-srv1\User_Profile_Backup\Windows Kits" -Recurse -Destination "C:\Program Files (x86)" -Force}
	Elseif ($WindowsKitPath -eq $true) 
		{Write-Verbose -Message "Windows Kit Folder already installed, proceeding with script"}

#If ($ARCH -eq "32-bit") 
#	{$path = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\x86"} 
#	Elseif ($ARCH -eq "64-bit") 
#		{$path = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\amd64"} 
#		Else {write-host -ForegroundColor red "Invalid system Architecture"}


New-PSDrive -Name "K" -PSProvider FileSystem -Root "\\inari-srv1\User_Profile_Backup" -Persist 

cd $path

cmd /c "loadstate \\inari-srv1\User_Profile_Backup\$targetcomputer /i:migapp.xml /i:migdocs.xml $mutarget /c /v:13 /l:scan.log"

Remove-PSDrive -Name "K"

