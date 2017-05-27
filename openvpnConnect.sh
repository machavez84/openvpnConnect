#!/bin/bash
#Openpvn connect script

#Resolv.conf restore function
clean()
{
echo "Restoring resolv.conf and deleting temporal files..."
mv /etc/resolv.conf.old /etc/resolv.conf
rm $OVPN.temp
sleep 2s
echo "Done"
}

#Initialising Varibles
HOST=$1
PORT=$2
OVPN=$3.ovpn

#test
echo $HOST
echo $PORT
echo $OVPN

echo "Resolving $HOST IP..."
IP=$(nslookup $HOST | grep Address | tail -1 | cut -c 10-25)
sleep 2s
echo "The ip is: $IP"

echo "Creating configuration file..."
sed '4s/.*/remote '$IP' '$PORT' /' $OVPN > $OVPN.temp
sleep 2s
echo "Done"

echo "Modificando resolv.conf"
mv /etc/resolv.conf /etc/resolv.conf.old
echo nameserver 192.168.1.1 > /etc/resolv.conf
sleep 2s
echo "cat /etc/resolv.conf"
echo "Done"

echo "Conectando...(CTRL-C para desconectar de la vpn)"
sleep 2s
trap "clean" 2
openvpn --config $OVPN.temp 

exit 0


