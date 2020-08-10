#! /bin/bash

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
	#перезавантаження мережевої карти
	systemctl restart network