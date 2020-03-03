# Freenas + QuadstorVTL
Findings and guidance for setting up FreeNAS to back up to tape over iSCSI. Fun proof of concept with a few real implications. See paper for more nuanced steps

### Requirements:
Debian 8 or 9 server (CentOS is also an option, but Debian was most familiar)
FreeNAS or other NAS solution
QuadstorVTL

### FreeNAS Installation:

Follow installation steps in the text-based installer

### QuadstorVTL Installation:

#### Pre-requisites
1. apt install uuid-runtime build-essential sg3-utils apache2 psmisc linux-headers-`uname -r
2. Add "non-free" to /etc/apt/sources.list
3. apt update
4. apt install fimrware-qlogic
5. a2enmod cgi

#### Actual setup

1. wget https://quadstor.com/vtldownloads/quadstor-vtl-ext-3.0.40-debian-x86_64.deb
2. dpkg -i quadstor-vtl-ext-3.0.40-debian-x86_64.deb
3. systemctl enable quadstorvtl
4. Run ip addr and go to the IP

Very cursory steps for setting up FreeNAS with iSCSI to QuadstorVTL:

## FreeNAS end
1. Add a drive in addition to the boot drive in the FreeNAS machine
2. Add it to a disk pool in FreeNAS
3. Create users and assign them SMB or other types of shares
4. Give FreeNAS an easily recognizable NetBIOS name and alias
5. Test access with another machine on the network

## Debian end
1. Add a drive to the machine to act as the "tape"
2. Add the drive to a pool through the QuadstorVTL web interface
3. Go to "Virtual Drives" and click "Add VDrive" to add a tape drive
4. Add a VCartridge (non-WORM) and select the pool it will use
5. On subsequent boots you will need to manually "load" the VCartrdige

## iSCSI Setup with FreeNAS as initiator
1. Go into shell mode in FreeNAS
2. Edit the "require" line (7) in /conf/base/etc/ix.rc.d/ix-zfs to include iscsictl
3. Remove the block on port 3260 (iSCSI) in /conf/base/etc/ipfw.conf.block by deleting it from line 4
4. 
