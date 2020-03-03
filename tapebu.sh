#!/usr/bin/env zsh

#This is a simple script (to run on a zsh system like FreeNAS) to back up 
#a FreeNAS drive pool to tape through QuadstorVTL over iSCSI. Change paths as needed

echo "Running NAS to tape backup on $(date)" > /tmp/tapebu.log

tar -czf /dev/sa0 /mnt/backups

echo "##Backup of Tape 0##" >> /tmp/tapebu.log

echo "Backup complete, please check the outputs logged"

exit 0
