#!/bin/bash

###########################################
################ Variables ################
###########################################
HOSTNAME='bula'
USERNAME='miner'
PACKAGES='xz-utils screen git xfce4'

###########################################
################# Updates #################
###########################################
#apt update && apt upgrade -y
#apt dist-upgrade

# 13:06 - 13:12 ~6 minutes

###########################################
############# Update Kernel ###############
###########################################
# cd /tmp
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400_4.14.0-041400.201711122031_all.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-image-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
# dpkg -i *.deb
# reboot

# echo "Installing kernel 4.10.17"
# cd /tmp
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.17/linux-headers-4.10.17-041017_4.10.17-041017.201705201051_all.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.17/linux-headers-4.10.17-041017-generic_4.10.17-041017.201705201051_amd64.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.17/linux-image-4.10.17-041017-generic_4.10.17-041017.201705201051_amd64.deb
# dpkg -i *.deb
# reboot

# echo "Installing kernel 4.15"
# cd /tmp
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000_4.10.0-041000.201702191831_all.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
# wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
# dpkg -i *.deb
# reboot

# echo "Installing kernel 4.10"
cd /tmp
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000_4.10.0-041000.201702191831_all.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-headers-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
dpkg -i *.deb
reboot


# echo "Getting HWE stuff"
# apt update && apt upgrade -y
# apt dist-upgrade
# apt install -y --install-recommends linux-image-generic-hwe-16.04 linux-headers-generic-hwe-16.04 xserver-xorg-hwe-16.04
# reboot

# 13:14 - 13:21 ~7 minutes

###########################################
################## Apps ###################
###########################################
apt install $PACKAGES -y
apt install -f -y
apt install $PACKAGES -y

###########################################
############# Change Hostname #############
###########################################
hostn=$(cat /etc/hostname)
sed -i "s/$hostn/$HOSTNAME/g" /etc/hosts
sed -i "s/$hostn/$HOSTNAME/g" /etc/hostname
reboot

###########################################
####### Add user to video group ###########
###########################################
usermod -a -G video $USERNAME

# 13:46-13:52 ~6 minutes

#############################################
################### ethereum ################
#############################################
echo "Installing ethereum"
apt install software-properties-common build-essential -y
add-apt-repository ppa:ethereum/ethereum -y
apt update
apt install ethereum -y
reboot

# ~11 minutes
# ~14 minutes

#############################################
################## ethminer #################
#############################################
# 
# Currently does not compile in post install!!
# See README.md
# 
echo "Installing ethminer"
cd /home/$USERNAME
apt install -y cmake mesa-common-dev libdbus-1-dev
git clone https://github.com/ethereum-mining/ethminer.git
cd ethminer
git submodule update --init --recursive
mkdir build; cd build
cmake ..
cmake --build .
make install

# ~15 minutes

#############################################
############ Dwarfpool Stratum ##############
#############################################
echo "Sehttp://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.17/linux-image-4.10.17-041017-generic_4.10.17-041017.201705201051_amd64.debtting up Dwarfpool stratum proxy"
cd /home/$USERNAME
apt install -y python-twisted
git clone https://github.com/Atrides/eth-proxy.git 
cd eth-proxy
rm eth-proxy.conf
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/eth-proxy.conf


#############################################
############### Pool scripts ################
#############################################
echo "Fetching pool scripts"
cd /home/$USERNAME
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/geth-start.sh
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/dwarfpool-start.sh
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/2miners-start.sh
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/go.sh
wget https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/scripts/install-ethminer.sh
chmod 774 *.sh


############################################
###### Remove forced kernel upgrade
############################################
# apt remove -y $(uname -r)
# apt autoremove -y
# update-grub
# reboot

############################################
############## Get amdgpu-pro ##############
############################################
# Download via referer: http://www.easycryptomining.com/ethereum_ubuntu_16.html
echo "Installing amdgpu-pro"
cd /home/$USERNAME
#wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.40-492261.tar.xz
wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/beta/ubuntu/amdgpu-pro-17.40-483984.tar.xz
#tar -xvf amdgpu-pro-17.40-492261.tar.xz
tar -xvf amdgpu-pro-17.40-483984.tar.xz
#cd amdgpu-pro-17.40-492261
cd amdgpu-pro-17.40-483984
./amdgpu-pro-install -y --compute
#./amdgpu-pro-install -y
#sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=nomsi amdgpu.vm_fragment_size=9"/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.vm_fragment_size=9"/g' /etc/default/grub
update-grub
reboot

# ~16 minutes

#
# Done
#
chown -R $USERNAME:$USERNAME .
reboot
