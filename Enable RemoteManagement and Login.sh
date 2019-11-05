#!/bin/bash
## Enable ARD on a machine.  Must be done after joining to the domain.

# grant ssh rights to local admin 
dscl . append /Groups/com.apple.access_ssh user <username>
systemsetup -setremotelogin on

#Add Domain\groupname to admin group.
dseditgroup -o edit -a "Domian\groupname" -t group admin

# Create local group that will contain domain\groupname
dscl . -create /Groups/ard_admin

# The group must be manually assigned, and should be above 500.  We will standardize on 530
dscl . -create /Groups/ard_admin PrimaryGroupID "530"
dscl . -create /Groups/ard_admin RealName "ard_admin"

# Now the group is created, we must add the AD account to it
dseditgroup -o edit -a "Domain\groupname" -t group ard_admin

# Make sure access is only allowed for the Specified Users,
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers

# Set the ARD client options to allow directory logins, again do this via the ARD Kickstart command:
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setdirlogins -dirlogins yes

# Now that you have a local group with an AD group nested inside, you can give your group the necessary privileges via the ARD Kickstart command:
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -privs -all -users ard_admin -restart -agent

#grant Remote Management privilges to local admin
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -users <username> -access -on -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -activate -restart -console


