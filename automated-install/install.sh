#!/usr/bin/env bash
# Automated installer for owncloud fail2ban configuration.
#
# Install with this command on your server:
# curl -s "https://raw.githubusercontent.com/AykutCevik/owncloud-fail2ban/owncloud-8.0/automated-install/install.sh" | bash
# Or run the commands below in given order.
#
# Script may also run under other versions of owncloud.

clear
echo "  _____      ___ __   ___| | ___  _   _  __| |      / _| __ _(_) |___ \| |__   __ _ _ __  "
echo " / _ \ \ /\ / / '_ \ / __| |/ _ \| | | |/ _' |_____| |_ / _' | | | __) | '_ \ / _' | '_ \ "
echo "| (_) \ V  V /| | | | (__| | (_) | |_| | (_| |_____|  _| (_| | | |/ __/| |_) | (_| | | | |"
echo " \___/ \_/\_/ |_| |_|\___|_|\___/ \__,_|\__,_|     |_|  \__,_|_|_|_____|_.__/ \__,_|_| |_|"
echo "            __Owncloud 9.* fail2ban installer__"
echo ""

JAILFILE="/etc/fail2ban/jail.d/owncloud.conf"
FILTERFILE="/etc/fail2ban/filter.d/owncloud.conf"
OWNCLOUDLOG=""
if [[ -f $JAILFILE ]];then
    echo "Already installed, updating owncloud filter."
    OWNCLOUDLOG=$(awk -F "=" '/logpath/ {print $2}' $JAILFILE)
else
    echo "Installing. Please provide your owncloud log path once. Updates will fetch it automatically."
    echo "Owncloud logpath: "
    read OWNCLOUDLOG </dev/tty

    echo "Installing fail2ban if not already done..."
    sudo apt-get update > /dev/null
    sudo apt-get -y install fail2ban
fi

echo "Downloading configurations..."
sudo curl -o "$FILTERFILE" "https://raw.githubusercontent.com/AykutCevik/owncloud-fail2ban/owncloud-8.0/automated-install/fail2ban/filter.owncloud.conf"
sudo curl -o "$JAILFILE" "https://raw.githubusercontent.com/AykutCevik/owncloud-fail2ban/owncloud-8.0/automated-install/fail2ban/jail.owncloud.conf"

echo "Setting log path..."
echo "logpath = $OWNCLOUDLOG" | sudo tee -a "$JAILFILE"

echo "Activating new owncloud filter. Restarting fail2ban..."
sudo /etc/init.d/fail2ban restart

echo "Work is done!"
