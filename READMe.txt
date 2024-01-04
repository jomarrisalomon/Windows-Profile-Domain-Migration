Windows Utilizies User State Migration Tool (USMT) to import profiles from one domain to another

The common use case scenario is that a company performs an acquisition and would like to combine the other IT domain into theirs.

You can also use this to periodically backup profiles to a file server.

The USMT tool kit allows you to backup profiles and import them onto the new domain keeping profiles, settings, and data altogether.

Pre Reqs for using the scripts: Powershell 4.0 or higher

Preparing an Old Domain -> New Domain Migration

Part 1. ( Profile Back repository setup )

1. Identify and utilize a Data/File server with as much open space as possible (You only need User State Migration Tools)

2. In the chosen file server, create a folder called "User_Profile_Backup" so that the scripts can call for the profiles/USMT tools Example: \\Server1\User_Profile_Backup

3. Copy the "Windows Kits" Folder  onto the root of "User_Profile_Backup"                                Example: \\Server1\User_Profile_Backup\Windows Kits

Part 2. ( Backing up profiles from OLD domain / OLD computer )

1. On any of the old computers / computers you would like to backup profiles, copy the "USMT_Script_ScanState_Final.ps1". onto the workstation

2. Run Powershell ISE ( As administrator )

3. Open the "USMT_Script_ScanState_Final.ps1"

4. Run the script and fill the parameters with the appropriate values

5. Test and monitor that no errors populate - You will see a folder populate of the workstation name on the file server indicating that profile transfer is in progress

6. Utilize the user list generated from the script as you will need the correct username to perform the loadstate script / backup

Part 3. ( Loading profiles from OLD domain / OLD computer to New Computer of new Domain)

1. On the new/target workstation - copy the "USMT_Script_LoadState_Final.ps1". onto the workstation

2. Run Powershell ISE ( As administrator )

3. Open the "USMT_Script_ScanState_Final.ps1"

4. Run the script and fill the parameters with the appropriate values

5. Test and monitor that no errors populate - On ISE - it will give a % of progress of how many profiles are transferring and which profiles 

6. Test and login to the new Domain account

# Other tools

ProfWiz and Tranwiz.msi are applications that perform simialar function in a GUI format for smaller migrations

Simply install the program and select the profile to backup and load the profile of the backed up file