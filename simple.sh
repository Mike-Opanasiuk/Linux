function Menu() {
    echo "----------- MENU -----------"
    echo "1. Show all disks"
    echo " 2. Show disk space"
    echo "  3. Add partition on disk"
    echo "   4. Edit fstab"
    echo "    5. Restart system"
    echo "0. EXIT"
}

function ShowAllDisks() {
ls -l /dev/sd*
}

function ShowDiskSpace() {
#df -Th
parted -l

}
function AddPartition() {
read -r -p "Enter disk name to add partition(/dev/*) * - enter:" name
fdisk /dev/$name
}
function MakeFS() {
read -r -p "Enter partition name to make file system(/dev/*) * - enter:" namedisk
mkfs.ext4 /dev/$namedisk
}
function Mount() {
read -r -p "Enter partition name to mount folder(/dev/*) * - enter: " namepart
read -r -p "Enter folder name to mount: " folderpath
mount /dev/$namepart $folderpath 
}

function Fstab() {
read -r -p "Enter partition name to fstab:" part
uid=$(blkid | grep -Eo $part.* | grep -Eo "UUID=.* " | grep -Eo "[0-9]+[a-z].* " | grep -Eo '^[^" TYPE]*')
read -r -p "Enter path to fstab partition: " path
echo "UUID=$uid $path  ext4   defaults   0 0" >> /etc/fstab
}
exit=true
while [ $exit == true ]
do
    Menu;
read -r -p "Enter your choise : " choise
    if [[ $choise == 1 ]]
        then
        ShowAllDisks;
    elif [[ $choise == 2 ]]
         then
        ShowDiskSpace;
    elif [[ $choise == 3 ]]
        then
echo "--Menu--"
echo "a - Add partition"
echo "b - Make file system"
echo "c - Mount to folder"
read -r -p "Enter your choise: " choise3
if [[ $choise3 == a ]]
then
AddPartition;
elif [[ $choise3 == b ]]
then
MakeFS;
elif [[ $choise3 == c ]]
then
Mount;
else
echo "ERROR"
fi
        echo "Add new partition on disk"
    elif [[ $choise == 4 ]]
        then
        Fstab;
    elif [[ $choise == 5 ]]
        then
        echo "Restarting system"
        reboot now
    elif [[ $choise == 0 ]]
        then
        exit=false
    else
        echo "ERROR"
    fi
done


