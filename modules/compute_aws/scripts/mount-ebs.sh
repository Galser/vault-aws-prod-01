#!/usr/bin/env bash
# Safe EBS mount script for Ubuntu-derived instances; 
# It will try to use additionbal NVME volume information
# it it is available, otherwise - fall-back to mounting by device path, which is 
# normal behavriour for non-NVME disks, and deice path SHOUDL correspond to 
# EBS volume
#
# USAGE :
#  mount-ebs/sh EBS_volume_ID device_name mount_point

# NOTES:
# Check some docs, WHY we need to do this : 
# 1) General : https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
# 2) New Nitro-based instances https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html

# CHECK command arguments 
if [ $# -lt 3 ]; then
    echo "No arguments specified, expecting 3 parameters  "
    echo " - EBS volume ID, for example 'vol-081fa704ee54131b3' "
    echo " - device path that would be used as TF data need to be provided, for example '/dev/sdh'"
    echo " - mount point, for example '/tfe-data'"
    exit 1
fi
# GET command argumets 
VOLUME="${1//-}"  # strip dash from volume ID as nvme list return them wihtout dash
DEVICE=$2         # device path ( /dev/sdh ... and etc )
VOLMOUNTPOINT=$3  # mount-point
echo "Looking for attached EBS prod data volume $1"
# test type of disks present in the system
echo "Listing existing Nitro instance volumes (if we have them)"
# do we have ANY NVME disks???
sudo ls /dev/nvme* ; LSRET=$?
if [ $LSRET -eq 0 ]; then
  # ok, we got Nitro instance, getting the real attachment Nitro device name
  echo "Checkin NVME CLI tools ..."
  which nvme || (
    sudo apt update -q -y
    if [ $? -ne 0 ]; then
      echo "First APT update failed, retrying."
      for i in 1 2 3
      do
          echo "."
          sudo apt update -q -y
          if [ $? -eq 0 ]; then
          break;
          fi # APT success
      done # APT repeats
      exit 1
    fi
    sudo apt install -q -y nvme-cli
    if [ $? -ne 0 ]; then
      echo "ERROR : NVME tools install failed, exiting"
      exit 1
    fi
  )
  # 1-st try
  DEVICE=$(sudo nvme list | grep $VOLUME | cut -d " " -f1)
  if [ -z $DEVICE ]; then
    echo "Volume with ID : '$1' not attached yet to the instance, waiting for attachement.."
  fi
  echo " "
  while [ -z $DEVICE ]; do
     # going to wait for Nitro EBS volumes attachment
    DEVICE=$(sudo nvme list | grep $VOLUME | cut -d " " -f1)
    echo -n .
    sleep 3
  done # while - waiting for device
fi
if [ -n "$DEVICE" ]; then # do we have SOME device?
  echo "Checking for late mount" # this is the case for EBS volumes 
                                 # on non-nitro instances
  while [ ! -b $DEVICE ] ; do
    echo -n .
    sleep 2
  done
  # testing maybe it is already mounted
  sudo mount | grep "$DEVICE"
  if [ $? -eq 0 ]; then
    echo "ERROR : The specified device is already mounted, proceedinmg futher is unsafe. Exiting."
    exit 1
  fi # device already mounted! refusing to work
  # last effort , ls check
  if sudo ls $DEVICE; then # is device file present and accesible finally?
    echo -n "Creating file system..."
    sudo mkfs -t xfs -q $DEVICE && echo ". done"
    echo -n "Creating mountpoint.."
    sudo mkdir -p $VOLMOUNTPOINT && echo ". done"
    if sudo test -d $VOLMOUNTPOINT; then
      PUUID=$(sudo blkid $DEVICE | grep -E -o "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}")
      sudo sh -c 'echo UUID='$PUUID'   '$VOLMOUNTPOINT'  xfs  defaults,nofail  0  2 >> /etc/fstab'
      echo -n "Mounting volume.."
      sudo mount -a
      if [ $? -ne 0 ]; then
        echo "ERROR : Mounting failed or /etc/fstab corrupted, making emergency exit"
        exit 1
      fi
      echo ".done"
    else
      echo "ERROR : Mountpoint $VOLMOUNTPOINT cannot be used"
      exit 1
    fi  # can't use mountpoint
  else
    echo "ERROR : Device $DEVICE cannot be accessed"
    exit 1
  fi # can't access device
else
  echo "ERROR : Can't find EBS volume attachment device"
  exit 1
fi # can't even find volume  