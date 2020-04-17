#!/bin/sh
echo "This is an script will disable all mios programs on your vera plus/secure and make it a zwave and zigbee device over IP"
echo "You will require socat on the host controller to capture the signal and create a virtual serial port out of it"
while true; do
    read -p "Are you ready?   " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes, no or press Ctrl + c to exit";;
    esac
done
echo "Installing and configuring ser2net"
opkg update
opkg install ser2net
echo '3333:raw:0:/dev/ttyS0:115200 8DATABITS NONE 1STOPBIT' >> /etc/ser2net.conf
echo "zwave configured on port 3333"
echo '3300:raw:0:/dev/ttyS2:57600 8DATABITS NONE 1STOPBIT' >> /etc/ser2net.conf
echo "zigbee configured on port 3000"
echo "Disabling vera programs"
sed -i '9s/.*/#&/' /etc/init.d/lighttpd
sed -i '10s/.*/#&/' /etc/init.d/lighttpd
sed -i '11s/.*/#&/' /etc/init.d/lighttpd
sed -i '3 a exit 0' /etc/init.d/ntpclient
sed -i '2 a wifi down' /usr/bin/Start_NetworkMonitor.sh
sed -i '3 a ser2net' /usr/bin/Start_NetworkMonitor.sh
sed -i '4 a exit 0' /usr/bin/Start_NetworkMonitor.sh
sed -i '2 a exit 0' /usr/bin/Start_LuaUPnP.sh
sed -i '2 a exit 0' /usr/bin/cmh-ra-daemon.sh
sed -i '2 a exit 0' /usr/bin/relay-daemon.sh
sed -i '2 a exit 0' /usr/bin/tech-ra-daemon.sh
sed -i '2 a exit 0' /usr/bin/Start_serproxy.sh
opkg remove odhcpd
echo "vera disabled, now checking serial ports"
ser2net
netstat -antp
echo
while true; do
    read -p "check ports 3333 and 3000 are listening. Are they there? Y/N" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes, no or press Ctrl + c to exit";;
    esac
done
echo "rebooting"
reboot
