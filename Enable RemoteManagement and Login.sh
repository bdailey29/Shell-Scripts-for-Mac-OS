#!/bin/bash
## Enable ARD on a machine.  Must be done after joining to the domain.

# grant ssh rights to poplocaladmin 
dscl . append /Groups/com.apple.access_ssh user poplocaladmin
systemsetup -setremotelogin on

#Add POP\workstationadministrators to admin group.
dseditgroup -o edit -a "POP\workstationadministrators" -t group admin

# Create local group that will contain pop\workstationadministrators
dscl . -create /Groups/ard_admin

# The group must be manually assigned, and should be above 500.  We will standardize on 530
dscl . -create /Groups/ard_admin PrimaryGroupID "530"
dscl . -create /Groups/ard_admin RealName "ard_admin"

# Now the group is created, we must add the AD account to it
dseditgroup -o edit -a "POP\workstationadministrators" -t group ard_admin

# Make sure access is only allowed for the Specified Users,
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers

# Set the ARD client options to allow directory logins, again do this via the ARD Kickstart command:
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setdirlogins -dirlogins yes

# Now that you have a local group with an AD group nested inside, you can give your group the necessary privileges via the ARD Kickstart command:
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -privs -all -users ard_admin -restart -agent

#grant Remote Management privilges to poplocaladmin
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -users poplocaladmin,ard_admin,tysons,jamescook,robmacgregor,garretnobile,silviamdriz -access -on -privs -all
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -activate -restart -console


