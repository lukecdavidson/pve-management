#!/bin/bash

function get-disks {
	pvesm list local-lvm --vmid $1 | cut -f1 -d ' ' | grep  -Ev "(*.state*.|Volid)"
}

for i in $(cat vms.txt)
do
	#VMNAME=$(qm list | grep ' "$1" ') #| tr -s ' ' | cut -f3 -d ' ')
	readarray -t DISKS < <(get-disks $i)
	for p in ${DISKS[@]} 
	do
		DISKPATH=$(pvesm path "$p")
		DISKBASE=$(basename $DISKPATH)
		qemu-img convert -O qcow2 -f raw "$DISKPATH" "/mnt/backup/${DISKBASE}.qcow2"
	done
done
