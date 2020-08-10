#! /bin/bash

sed -i 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-en*
#����������� � ���������� ����� �� �������������
gateway="$(ip route | grep -Eo "via [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
#��������� ����� �� �������������
netmask=255.255.255.0
#��������� DNS �� ������������� 
dns=8.8.8.8
#��� �����
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
	#��������� ����� � ������ ��, �����, ����� �� ������������� �� ���
	sed -i '/IPADDR/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-en*
	
	sed -i '/DNS/d' /etc/sysconfig/network-scripts/ifcfg-en*
	#����� ����� � ���� en*
	echo "IPADDR=$ip" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "NETMASK=$netmask" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "GATEWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-en*
	echo "DNS1=$dns" >> /etc/sysconfig/network-scripts/ifcfg-en*
	#���������������� �������� �����
	systemctl restart network