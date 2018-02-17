#!/bin/bash

###########################################
################ Variables ################
###########################################
HOSTNAME='bula'
USERNAME='miner'
IPADDRESS='192.168.2.9'
NETMASK='255.255.240.0'
GATEWAY='192.168.2.1'
NAMESERVER='192.168.2.1'
#PACKAGES='htop nano sudo python-minimal vim rsync dnsutils less ntp'
PACKAGES='xz-utils screen git'

###########################################
################# Updates #################
###########################################
apt update && apt upgrade -y
apt dist-upgrade

###########################################
################## Apps ###################
###########################################
apt install $PACKAGES -y

###########################################
################## SSH ####################
###########################################

# Add SSH Key for default user
#mkdir /home/$USERNAME/.ssh/
#cat > /home/$USERNAME/.ssh/authorized_keys <<EOF
#SSH-KEY HERE
#EOF
#chmod 700 /home/$USERNAME/.ssh
#chmod 600 /home/$USERNAME/.ssh/authorized_keys
#chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
## Add SSH Key for root user
#mkdir /root/.ssh/
#cat > /root/.ssh/authorized_keys <<EOF
#SSH-KEY HERE
#EOF
#chmod 700 /root/.ssh
#chmod 600 /root/.ssh/authorized_keys
#chown -R root:root /root/.ssh

# Edit /etc/ssh/sshd_config
#sed -i '/^PermitRootLogin/s/prohibit-password/yes/' /etc/ssh/sshd_config
#sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config

###########################################
################# Network #################
###########################################
#mv /etc/network/interfaces /etc/network/interfaces.bk
#cat > /etc/network/interfaces <<EOF
#auto lo eth0
#iface lo inet loopback
#iface eth0 inet static
#address $IPADDRESS
#netmask $NETMASK
#gateway $GATEWAY
#dns-nameservers $NAMESERVER
#EOF

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

###########################################
############# Update Kernel ###############
###########################################
echo "Updating kernel"
apt install --install-recommends linux-image-generic-hwe-16.04

#cd /tmp
#wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400_4.14.0-041400.201711122031_all.deb
#wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-headers-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
#wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14/linux-image-4.14.0-041400-generic_4.14.0-041400.201711122031_amd64.deb
#dpkg -i *.deb
#reboot

# ~8 minutes

############################################
############## Get amdgpu-pro ##############
############################################
# Download via referer: http://www.easycryptomining.com/ethereum_ubuntu_16.html
echo "Installing amdgpu-pro"
cd /home/$USERNAME
wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.40-492261.tar.xz
tar -xvf amdgpu-pro-17.40-492261.tar.xz
cd amdgpu-pro-17.40-492261
#./amdgpu-pro-install -y --compute
./amdgpu-pro-install -y
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=nomsi amdgpu.vm_fragment_size=9"/g' /etc/default/grub
update-grub
reboot

# ~10 minutes


#############################################
############# rocm-amdgpu-pro ###############
#############################################
#echo "Installing rocm-amdgpu-pro"
#cd /home/$USERNAME
#wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | sudo apt-key add -
#sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list'
#apt update
#apt install -y rocm-amdgpu-pro
#echo 'export LLVM_BIN=/opt/amdgpu-pro/bin' | sudo tee /etc/profile.d/amdgpu-pro.sh
#reboot

# ~11 minutes

#############################################
################### ethereum ################
#############################################
echo "Installing ethereum"
apt install software-properties-common build-essential -y
add-apt-repository ppa:ethereum/ethereum -y
apt update
apt install ethereum -y
reboot

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
apt install -y cmake mesa-common-dev
git clone https://github.com/ethereum-mining/ethminer.git
cd ethminer
mkdir build; cd build
cmake ..
cmake --build .
make install

# ~15 minutes

#############################################
############ Dwarfpool Stratum ##############
#############################################
echo "Setting up Dwarfpool stratum proxy"
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
chmod 774 *.sh

# ~16 minutes

#
# Done
#
chown -R $USERNAME:$USERNAME .
reboot


