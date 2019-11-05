#!/bin/sh

# Disable Internet Sharing System Preference

echo "Disabling Internet Sharing System Preference..."
/usr/bin/defaults write "/Library/Preferences/SystemConfiguration/com.apple.nat NAT" -dict Enabled

exit 0