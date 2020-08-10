#! /bin/bash

function Debian() {
read -r -p "Enter your static ip: " ip
read -r -p "Enter dns: " dns
read -r -p "Enter subnet mask: " mask
read -r -p "Enter gateway: " gateway

interface="$(ip addr | grep -Eo "en.*:")"
chmod 777 /etc/netplan/50-cloud-init.yml
echo "# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}" > /etc/netplan/50-cloud-init.yaml
echo "network:
  version: 2
  renderer: networkd
  ethernets:
    interface
     dhcp4: no
     addresses: [$ip/$mask]
     gateway4: $gateway
     nameservers:
       addresses: [$dns]" >> /etc/netplan/50-cloud-init.yaml
sudo netplan apply
}

function Rhel() {
sed -i 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-en*
#знаходження і збереження шлюза за замовчуванням
gateway="$(ip route | grep -Eo "via [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
#присвоєння маски за замовчуванням
netmask=255.255.255.0
#присвоєння DNS за замовчуванням 
dns=8.8.8.8
#ввід даних
	read -r -p "Enter a static ip: " ip

	read -r -p "Do you want to enter netmask?(y/n) (default 255.255.255.0)" choise
	if [[ $choise == y ]]; then
	read -r -p "Enter netmask: " netmask
	else 
	echo "Default netmask filled!"
	fi

	read -r -p "Do you want to enter gateway?(y/n) (default $gateway)" choise
	if [[ $choise == y ]]; then
	read -r -p "Enter gateway: " gateway
	else 
	echo "Default gateway filled!"
	fi

	read -r -p "Do you want to enter DNS?(y/n) (default 8.8.8.8)" choise
	if [[ $choise == y ]]; then
	read -r -p "Enter DNS: " dns
	else 
	echo "Default DNS filled!"
	fi
	#видалення рядків з даними ір, маски, шлюза за замовчуванням та днс
	sed -i '/IPADDR/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/DNS/d' /etc/sysconfig/network-scripts/ifcfg-en*
	#запис даних у файл en*
	echo "IPADDR=$ip" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "NETMASK=$netmask" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "GATEWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "DNS1=$dns" >> /etc/sysconfig/network-scripts/ifcfg-en*
	systemctl restart network
}


OS="$(cat /etc/os-release | grep -E "ID_LIKE=.*" | grep -E "[^\"]"| sed "s/.*=//")"
echo "You are at $OS now"
if [[ $OS == debian ]]; then Debian;
elif [[ $OS == "rhel fedora" ]]; then Rhel;
fi	
