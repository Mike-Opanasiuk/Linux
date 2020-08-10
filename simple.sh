#! /bin/bash
 
function Menu() {
    echo "----------- MENU -----------"
    echo "1. AddUser"
    echo " 2. RemoveUser"
    echo "  3. EditUser"
    echo "    4. CreateGroup"
    echo "      5. AddUserToTheGroup"
    echo "        6. RemoveUserFromTheGroup"
    echo "0. EXIT"
}
 
function AddUser()
{
read -r -p "Do you want to add user?: " choise
if [[ $choise == y || $choise == yes ]];
then 
echo -e "How are you going to add the user? \na) - Add user with name\nb) - Add user with name and uid\nc) - Add password to user\n"
read -r -p "Enter your choise: " choise2
fi
if [[ $choise2 == a ]]
then
read -r -p "Enter user name to add: " user
useradd $user
if [ $? != 0 ];
then 
echo "User $user already exists"
else 
echo "User $user complited"
fi
elif [[ $choise2 == b ]]
then
read -r -p "Enter user name to add: " user
read -r -p "Enter user uid to add: " uid
useradd $user -u $uid
if [ $? != 0 ];
then 
echo "User $user already exists"
else 
echo "User $user complited"
fi
elif [[ $choise2 == c ]]
then
read -r -p "Enter user name to add password: " user
sudo passwd $user
else echo "You have choosen a wrong variant"
fi
}
   
   function RemoveUser()
   {
   read -r -p "Enter a nick of user you are going to delete: " userdelete
   userdel $userdelete -r
   }
   function EditUser()
   {
   echo -e "How do you want to edit the user?\na) - User name\nb) - User id\nc) - User gid\n"
   read -r -p "Enter your choise: " choise
   if [[ $choise == a ]]
	then 
	read -r -p "Enter a user nick to change the nick: " nickOld
	read -r -p "Enter a new users nick: " nickNew
	usermod $nickOld -l $nickNew
	elif [[ $choise == b ]]
	then 
	read -r -p "Enter a user nick to change id: " nick
	read -r -p "Enter a new users id: " idNew
	usermod $nick -u $idNew
	elif [[ $choise == c ]]
	then 
	read -r -p "Enter a users nick to change id: " nick
	read -r -p "Enter a new users gid: " gidNew
	usermod $nick -g $gidNew
	else echo -e "You have entered a wrong variant\nError"
	fi
   }

   function CreateGroup()
   {
   read -r -p "Enter a group name to create: " group_name
   read -r -p "Enter a group ip to create the group: " group_id
   groupadd $group_name -g $group_id
   echo "The group was created successfully!"
   }
   
   function AddUserToTheGroup()
   {
   read -r -p "Enter a group name to add the user there: " group_name
      read -r -p "Enter a user nick to add to the group: " user_nick
	  usermod -aG $group_name $user_nick
	  echo "The user $user_nick was added to the group $group_name successfully!"
   }
   function RemoveUserFromTheGroup
   {
    read -r -p "Enter a group name to remove the user from there: " group_name
      read -r -p "Enter a user nick to remove from the group: " user_nick
	  gpasswd -d $user_nick $group_name
   	  echo "The user $user_nick was deleted from the group $group_name successfully!"
   }
 
exit=true
while [ $exit == true ]
do
    Menu;
read -r -p "Enter your choise : " choise
    if [[ $choise == 1 ]] 
        then
        AddUser;
    elif [[ $choise == 2 ]]
         then
         RemoveUser;
    elif [[ $choise == 3 ]]
        then
        EditUser;
    elif [[ $choise == 4 ]]
        then
        CreateGroup;
    elif [[ $choise == 5 ]]
        then
        AddUserToTheGroup;
    elif [[ $choise == 6 ]]
        then
        RemoveUserFromTheGroup;
    elif [[ $choise == 0 ]]
        then
        exit=false
    else
        echo "ERROR"
    fi
done