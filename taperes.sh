#!/usr/bin/env zsh

echo -n "Running NAS tape restore. Input the volume to restore from: "
read backup

tar  --no-same-permissions -xvzf /dev/$backup -C /

echo "Restore complete for /dev/$backup"

echo -n "View restored directory structure? (y or n): " 
read yesno

if [[ ${yesno} == "y" ]] 
 then ls -l /mnt/backup/* | more
elif [[ ${yesno} != "y" ]]
 then exit 0
fi
exit 0
