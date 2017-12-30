ethereum-miner-bula
===================

Find precise hardware specs and BIOS settings on the [_bula_ 6x RX580 Ethereum mining rig](https://theminingking.com/blog/2017/12/16/Hello-Bula-6-GPU-Ethereum-Rig/).

- Ubuntu Server 16.04.3
- Linux kernel v4.14
- AMDGPU-PRO 17.40
- ethereum via apt
- ethminer from source

bula is currently mining on [Dwarfpool](http://dwarfpool.com/eth/address/?wallet=7e5533116dbd23b113d3288aacbf4d2122f88ad3).

Though this is still a work in progress, I intend to lockdown and fully automate installation of the software required to mine Ethereum out of the box. Once configured, mining is as easy as typing:

```
./go.sh
```

## Make Ubuntu 16.04 image

The following steps were executed on an Ubuntu 16.04 installation.

Much of the following is adapted from: [dsgnr/Ubuntu-16.04-Unattended-Install](https://github.com/dsgnr/Ubuntu-16.04-Unattended-Install).

All that aside, you need a bootable USB!

This program will enable us to do just that:

```
sudo apt install xorriso
```

Create a directory in which to do your work:

```
mkdir myInstaller && cd myInstaller
```

Download the desired Ubuntu 16.04 image:

```
wget http://releases.ubuntu.com/16.04/ubuntu-16.04.3-server-amd64.iso
```

This is an unattended install, so we need to set installation parameters. Use `xorriso` to extract the files from the ISO:

```
xorriso -osirrox on -indev ubuntu-16.04.3-server-amd64.iso -extract / custom-iso
```

Now open the `grub.cfg` file with your favourite editor (mine is `vim`!):

```
cd custom-iso && vim boot/grub/grub.cfg
```

Paste the following and save:

```
if loadfont /boot/grub/font.pf2 ; then
  set gfxmode=auto
  insmod efi_gop
  insmod efi_uga
  insmod gfxterm
  terminal_output gfxterm
fi
set default=0
set timeout=1
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

menuentry "Mine Ethereum with the Mining King" {
  set gfxpayload=keep
  linux /install/vmlinuz gfxpayload=800x600x16,800x600 hostname=ubuntu16-04 --- auto=true url=https://raw.githubusercontent.com/TheMiningKing/ethereum-miner-bula/master/preseed.cfg quiet
  initrd  /install/initrd.gz
}
```

Note the URL location of the preseed file! It's currently linked to this repository, though there's nothing to say you can't serve up your configuration file from any server you choose.

You might do this, for example (_optional_): 

```
git clone https://github.com/TheMiningKing/ethereum-miner-bula.git
cd ethereum-miner-bula
python -m SimpleHTTPServer
```

This will serve up the all the files required of the unattended installer.


Let's make this sucker bootable (again, all credit to [dsgnr](https://github.com/dsgnr/Ubuntu-16.04-Unattended-Install). This is all just sorcery...

Obtain isohdpfx.bin for hybrid ISO:

```
cd ../
sudo dd if=ubuntu-16.04.3-server-amd64.iso bs=512 count=1 of=custom-iso/isolinux/isohdpfx.bin
```

Create new ISO:

```
cd custom-iso
sudo xorriso -as mkisofs -isohybrid-mbr isolinux/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -o ../custom-ubuntu-http.iso .
```

Confirm partitions:

```
cd .. # or `cd ~/myInstaller`
fdisk -l custom-ubuntu-http.iso
```

Write to USB drive:

```
sudo fdisk -l
sudo dd if=/home/daniel/test/myInstaller/custom-ubuntu-http.iso of=/dev/sde
```

At this point, you should have a working, bootable installation CD. I usually only attach one GPU the motherboard until installation is complete. After that, attach them one at a time (between reboots) to ensure all are working properly.


## Login

Your username is `miner` and your password is `secret`. Assuming all went well, your rig is rigged to run on `192.168.2.9`.

E.g.,

```
ssh miner@192.168.2.9
```

## A BUG!

_Grrrrrrr!_ I attempt to compile `ethminer` from source in `post-install.sh`. At the time of writing, this doesn't work yet. The process is not fully automated. It can be fixed, with the following _Ethminer installation_ instructions:


### Ethminer installation

Doesn't work in `post-install.sh` for some reason. Pull requests welcome...

```
cd ~/ethminer/build
cmake ..
cmake --build .
sudo make install
```

## Configure

At this point, you could simply type:

```
./go.sh
```

and your rig would start submitting shares on behalf of my wallet. You probably want the shares to be credited to your wallet ([though feel free to kick some change my way](https://etherscan.io/address/0xd24def0856636050cf891befc0fa69ecf96c160b)).

As it stands, everything is set up to join Dwarfpool and start mining. There are four scripts of which you need to be aware on your new installation:

- `~/go.sh`
- `~/dwarfpool-start.sh`
- `~/geth-start.sh`
- `~/eth-pool/eth-proxy.conf`

### geth-start.sh

Start the Ethereum node. This isn't absolutely necessary, though I find an improvement in my hashrate when it is running.


### dwarfpool-start.sh

There are a bunch of examples on how to connect to Dwarfpool. Really, just make sure you change your wallet address otherwise you'll be mining for me.

### ~/eth-pool/eth-proxy.conf

This is a Dwarfpool-heavy configuration. `eth-pool` is their stratum mining proxy. The file itself is well documented. I'll leave it to you to set your wallet address, et al.

### go.sh

This just runs all the required scripts:

```
./go.sh
```

Take a peak inside and you'll see calls to `./geth-start.sh` and `./dwarfpool-start.sh`.

## Contribute?

Yes please! This is meant to be helpful. Adapt it as you will.

If you can improve it, or have devised your own installation, let's hear all about it.

## Licence

MIT

