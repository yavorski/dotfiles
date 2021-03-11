#!/usr/bin/env bash

echo @start run script...

# PS3='Select PC to install arch on: '
# options=("desktop" "laptop")
# select opt in "${options[@]}"
# do
#   case "$opt" in
#     "desktop")
#       HDD_DISK=/dev/sda
#       SSD_DISK=/dev/sdb
#       PORT=22
#       echo -n "HOST: "
#       read HOST
#       break
#       ;;
#     "laptop")
#       HDD_DISK=NULL
#       SSD_DISK=/dev/nvme0n1
#       PORT=22
#       echo -n "HOST: "
#       read HOST
#       break
#       ;;
#     *) echo Invalid;;
#   esac
# done

PORT=22
HOST="192.168.0.42"

# echo -n "HOST: "
# read HOST

HDD_DISK=/dev/sda
SSD_DISK=/dev/sdb

echo @settings HDD_DISK="$HDD_DISK", SSD_DISK="$SSD_DISK", PORT="$PORT", HOST="$HOST"

ROOT_HOST="root@$HOST"
SSH_PUBLIC_KEY=$(cat ~/.ssh/id_ed25519.pub)

# WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
ssh-keygen -R $HOST

# copy your public key, so that you can ssh without a password later on
ssh -tt -p "$PORT" "$ROOT_HOST" "mkdir -p -m 700 ~/.ssh; echo $SSH_PUBLIC_KEY > ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys"

# copy install scripts from here to ./root folder on the new device
scp -P "$PORT" ./install.sh ./chroot.sh ./gpu.sh ./post-install.sh "$ROOT_HOST:/root"

# run the install script remotely
ssh -tt -p "$PORT" "$ROOT_HOST" "./install.sh $HDD_DISK $SSD_DISK"

echo @finish run script...
