# Freenas + QuadstorVTL
Findings and guidance for setting up FreeNAS to back up to tape over iSCSI. Fun proof of concept with a few real implications. See paper for more nuanced steps

### Requirements:
1. Debian 8 or 9 server (CentOS is also an option, but Debian was most familiar)
2. FreeNAS or other NAS solution
3. QuadstorVTL

### FreeNAS Installation:

Follow installation steps in the text-based installer

### QuadstorVTL Installation:

#### Pre-requisites
1. apt install uuid-runtime build-essential sg3-utils apache2 psmisc linux-headers-`uname -r
2. Add "non-free" to /etc/apt/sources.list
3. apt update
4. apt install firmware-qlogic
5. a2enmod cgi

#### Actual setup

1. wget https://quadstor.com/vtldownloads/quadstor-vtl-ext-3.0.40-debian-x86_64.deb
2. dpkg -i quadstor-vtl-ext-3.0.40-debian-x86_64.deb
3. systemctl enable quadstorvtl
4. Run ip addr and go to the IP

### Very cursory steps for setting up FreeNAS with iSCSI to QuadstorVTL:

#### FreeNAS end
1. Add a drive in addition to the boot drive in the FreeNAS machine
2. Add it to a disk pool in FreeNAS
3. Create users and assign them SMB or other types of shares
4. Give FreeNAS an easily recognizable NetBIOS name and alias
5. Test access with another machine on the network

#### Debian end
1. Add a drive to the machine to act as the "tape"
2. Add the drive to a pool through the QuadstorVTL web interface
3. Go to "Virtual Drives" and click "Add VDrive" to add a tape drive
4. Add a VCartridge (non-WORM) and select the pool it will use
5. On subsequent boots you will need to manually "load" the VCartridge

#### iSCSI Setup with FreeNAS as initiator
1. Go into shell mode in FreeNAS
2. Edit the "require" line (7) in /conf/base/etc/ix.rc.d/ix-zfs to include iscsictl
3. Remove the block on port 3260 (iSCSI) in /conf/base/etc/ipfw.conf.block by deleting it from line 4
4. Go to "System" then "Tunables" and add the following 3 rc.conf variables to ensure iSCSI on boot
    a. iscsictl_enable with value "YES" and type rc
    b. iscsictl_flags with value "-Ad <ipaddress of Debian machine>" and type rc
    c. iscsid_enable with value "YES" and type rc
5. Go to "Tasks" then "Init/Shutdown Scripts"
    a. Add the command "zpool export <poolname>" as a shutdown script for proper shutdown after disk sync
6. Run "iscsictl -Ad <ipaddress of Debian machine>" to add all iSCSI devices on the Debian machine
7. Run iscsictl to make sure the tape drive's iqn, target IP, and mount point shows up
7. Basic commands
    a. tar -czf /dev/sa0 /mnt/<poolname>/* to back up the entire pool to the tape cartridge at /dev/sa0
    b. tar -tzf /dev/sa0 to list all files on the drive
    c. tar -xvzf /dev/sa0 -C / to actually restore the entire backup (this will overwrite from / so the path lines up
  
### Final things
1. Two scripts are included in the repo: tapebu.sh and taperes.sh. The backup script can be assigned as a weekly cronjob
2. The execution in real practice would probably need more fine tuning
3. The proper boot order is QuadstorVTL, clicking "load" on necessary tape cartridges, then booting FreeNAS
    a. This just ensures iSCSI drives are available before FreeNAS boots
3. Thanks to user thewizard231 on the FreeNAS forums for giving steps for making FreeNAS act as an iSCSI initiator
   https://www.ixsystems.com/community/threads/freenas-as-an-iscsi-initiator.22098/#post-462100
