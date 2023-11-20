# Montaje isard-nas1 y isard-nas2



## instalaciones



> Habilitar **ssh-copy-id** como root a todas las interfaces en todas las direcciones entre nodos 

```bash
# cat /etc/hosts
127.0.0.1  localhost
::1 localhost
10.1.1.31  isard-nas1.escoladeltreball.org isard-nas1
10.1.1.32  isard-nas2.escoladeltreball.org isard-nas2
10.1.2.31  nas1
10.1.2.32  nas2
10.1.3.31  drbd1
10.1.3.32  drbd2
10.1.4.31  corosync1
10.1.4.32  corosync2
10.1.5.31  stonith1
10.1.5.32  stonith2
```



### raid

```bash
apt install mdadm 
```



### repo y instalar drbd

```bash
echo "deb http://ppa.launchpad.net/linbit/linbit-drbd9-stack/ubuntu xenial main" >> /etc/apt/sources.list
apt install dirmngr
apt-key adv --keyserver  keyserver.ubuntu.com --recv 34893610CEAA9512
apt update

apt install drbd-dkms drbd-utils python-drbdmanage
```



### ntp

```bash
nano /etc/systemd/timesyncd.conf 
...
NTP=ntp.escoladeltreball.org
...

 timedatectl set-ntp true

```



### zabbix

```bash
apt install zabbix-agent lm-sensors hddtemp
systemctl start zabbix-agent.service 
systemctl enable zabbix-agent.service 
```



### writeboost

```bash
apt install writeboost dm-writeboost-dkms
modprobe dm_writeboost

apt install git curl
wget https://sh.rustup.rs/
mv index.html runscript-init.sh
chmod +x runscript-init.sh 
./runscript-init.sh -y
echo "export PATH=$PATH:/root/.cargo/bin/" >> /etc/profile
git clone https://github.com/akiradeveloper/dm-writeboost-tools
/root/.cargo/bin/cargo install --path /tmp/dm-writeboost-tools/ --force    
```

#### cache
```bash
/root/.cargo/bin/wbcreate --reformat --read_cache_threshold=127  --writeback_threshold=80 cacheMd0 /dev/md0 /dev/nvme0n1p1
/root/.cargo/bin/wbcreate --reformat --read_cache_threshold=127  --writeback_threshold=80 cacheMd1 /dev/md1 /dev/nvme0n1p2
lsblk
  
# nano /etc/writeboosttab
....
cacheMd1     /dev/md1     /dev/nvme0n1p2    writeback_threshold=80,read_cache_threshold=127
cacheMd0     /dev/md0     /dev/nvme0n1p1    writeback_threshold=80,read_cache_threshold=127
....

```
#### borrar y crear nuevo demonio
```bash
rm /etc/systemd/system/*/writeboost.service

  echo "[Unit]
        Description=(dm-)writeboost mapper
        Documentation=man:writeboost
        #DefaultDependencies=false
        #Conflicts=shutdown.target

        ## "Before=local-fs-pre" is significant as it influences correct order
        ## of stopping (after unmount).
        #Before=shutdown.target drbdmanaged.service cryptsetup.target local-fs-pre.target
        #Before=shutdown.target cryptsetup.target local-fs-pre.target

        Before=shutdown.target drbdmanaged.service

        [Service]
        Type=oneshot

        ## Must remain after exit to prevent stopping right after start
        ## and to stop on shutdown.
        RemainAfterExit=yes

        ## Scannong caching devices may take long time after unclean shutdown.
        TimeoutStartSec=3600

        ExecStart=/sbin/writeboost
        ExecStop=/sbin/writeboost -u

        ## Long "TimeoutStop" is essential as deadlock may happen if writeboost
        ## is killed during flushing of caches on shutdown, etc.
        TimeoutStopSec=3600

        StandardOutput=syslog+console

        [Install]
        #WantedBy=cryptsetup.target
        #WantedBy=local-fs.target
        WantedBy=drbdmanaged.service
        #Alias=dm-writeboost.service" > /etc/systemd/system/writeboost.service

```

```bash
systemctl start writeboost.service
systemctl enable writeboost.service
```



### nfs

```bash
apt install nfs-kernel-server
apt install nfs-common
```



###  pacemaker

```bash
apt install corosync pacemaker pcs python-pycurl fence-agents fence-agents
```





# Montaje



## crear  dos raid1  

```bash
mdadm --create /dev/md0 --level=1 --raid-device=2 /dev/sd[b-c]
lsblk
mdadm --create /dev/md1 --level=1 --raid-device=2 /dev/sd[d-e]
lsblk
  
mdadm --detail /dev/md0
mdadm --detail /dev/md1
lsblk
```

### guardar configuración raid

```bash
mdadm --detail --scan > /etc/mdadm/mdadm.conf
update-initramfs -u
```

### particiones

```bash
fdisk /dev/nvme1n1 
nvme1n1     259:0    0   477G  0 disk  
├─nvme1n1p1 259:2    0   235G  0 part  
└─nvme1n1p2 259:3    0   235G  0 part  

```

```bash
fdisk /dev/nvme0n1 
nvme0n1     259:1    0 931,5G  0 disk  
├─nvme0n1p1 259:6    0   465G  0 part  
└─nvme0n1p2 259:7    0   465G  0 part 
```



### configurar writeboost para que monte al arrancar 

```bash
wbcreate --reformat --read_cache_threshold=127  --writeback_threshold=80 cacheMd0 /dev/md0 /dev/nvme1n1p1
wbcreate --reformat --read_cache_threshold=127  --writeback_threshold=80 cacheMd1 /dev/md1 /dev/nvme1n1p2
```

#### guardar configuración writeboost

```bash
nano /etc/writeboosttab
....
cacheMd1     /dev/md1     /dev/nvme1n1p2    writeback_threshold=80,read_cache_threshold=127
cacheMd0     /dev/md0     /dev/nvme1n1p1    writeback_threshold=80,read_cache_threshold=127
....
```



## drbd 



### crear pvs y vg

```bash
pvcreate /dev/nvme0n1p1
pvcreate /dev/nvme0n1p2
pvcreate /dev/mapper/cacheMd0
pvcreate /dev/mapper/cacheMd1
vgcreate drbdpool /dev/mapper/cacheMd1 /dev/mapper/cacheMd0 /dev/nvme0n1p1 /dev/nvme0n1p2
```

#### añadir filtro 

```bash
/etc/lvm/lvm.conf
...
filter = ["a|/dev/mapper/cacheMd0|","a|/dev/mapper/cacheMd1|", "a|/dev/nvme0n1p1|", "a|/dev/nvme0n1p2|", "r|.*|"]
...
```

#### iniciar drbd y añadir segundo nodo

```bash
drbdmanage init  10.1.3.32
drbdmanage add-node isard-nas2.escoladeltreball.org 10.1.3.32 # ( tiene que ser el hostname )
```

#### añadir volumenes

```bash
drbdmanage add-volume cacheMd1 7280G
drbdmanage deploy cacheMd1 1
drbdmanage add-volume cacheMd0 7280G
drbdmanage deploy cacheMd0 1
drbdmanage add-volume nvme0n1p2 465G
drbdmanage deploy nvme0n1p2 1
drbdmanage add-volume nvme0n1p1 465G
drbdmanage deploy nvme0n1p1 1

drbdmanage resources
drbdmanage volumes 
```

> **Nota:** verificar que los volumenes se montan en las particiones deseadas, si no es el caso, crear un pv para que ocupe espacio  donde quieres que 'no' se monte el recurso y luego borrar el pv.

#### añadir sistema de ficheros a las particiones

```bash
mkfs.ext4 /dev/drbd105
mkfs.ext4 /dev/drbd106
mkfs.ext4 /dev/drbd107
mkfs.ext4 /dev/drbd108
```
----



## cluster



### recursos

```bash
pcs resource create bases1 ocf:heartbeat:Filesystem device="/dev/drbd107" directory="/isard/bases1" fstype="ext4" "options=defaults,noatime" op monitor interval=10s 

pcs resource create bases2 ocf:heartbeat:Filesystem device="/dev/drbd108" directory="/isard/bases2" fstype="ext4" "options=defaults,noatime" op monitor interval=10s 


pcs resource create disck1 ocf:heartbeat:Filesystem device="/dev/drbd105" directory="/isard/disck1" fstype="ext4" "options=defaults,noatime" op monitor interval=10s 

pcs resource create disck2 ocf:heartbeat:Filesystem device="/dev/drbd106" directory="/isard/disck2" fstype="ext4" "options=defaults,noatime" op monitor interval=10s 
```
---

### recurso nfs:server and root

```bash
pcs cluster cib nfsserver_cfg

pcs resource create nfs-daemon systemd:nfs-server  op monitor interval=30s 

pcs resource create nfs-root ocf:heartbeat:exportfs \
clientspec=10.1.2.0/255.255.255.0 \
options=rw,crossmnt,async,wdelay,no_root_squash,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash \
directory=/isard fsid=0 

pcs cluster cib-push nfsserver_cfg

pcs resource group add nfs_server nfs_daemon nfs_root

pcs resource clone nfs_server master-max=2 master-node-max=1 clone-max=2 clone-node-max=1 on-fail=restart notify=true resource-stickiness=0
```
-----

### exports

```bash
pcs cluster cib exports_cfg

pcs -f exports_cfg resource create export_bases1 exportfs \
clientspec=10.1.2.0/255.255.255.0 \
wait_for_leasetime_on_stop=true \
options=rw,mountpoint,async,wdelay,no_root_squash,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash directory=/isard/bases1 \
fsid=11 \
op monitor interval=30s

pcs -f exports_cfg resource create export_bases2 exportfs \
clientspec=10.1.2.0/255.255.255.0 \
wait_for_leasetime_on_stop=true \
options=rw,mountpoint,async,wdelay,no_root_squash,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash directory=/isard/bases2 \
fsid=20 \
op monitor interval=30s

pcs -f exports_cfg resource create export_disck1 exportfs \
clientspec=10.1.2.0/255.255.255.0 \
wait_for_leasetime_on_stop=true \
options=rw,mountpoint,async,wdelay,no_root_squash,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash directory=/isard/disck1 \
fsid=20 \
op monitor interval=30s

pcs -f exports_cfg resource create export_disck2 exportfs \
clientspec=10.1.2.0/255.255.255.0 \
wait_for_leasetime_on_stop=true \
options=rw,mountpoint,async,wdelay,no_root_squash,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash directory=/isard/disck2 \
fsid=20 \
op monitor interval=30s

pcs cluster cib-push exports_cfg
```
-----

### Ip flotantes

```bash
pcs resource create IPbases1 ocf:heartbeat:IPaddr2 ip=10.1.2.41 cidr_netmask=32 nic=nas:0  op monitor interval=30 
pcs resource create IPbases2 ocf:heartbeat:IPaddr2 ip=10.1.2.42 cidr_netmask=32 nic=nas:1  op monitor interval=30 

pcs resource create IPdisck1 ocf:heartbeat:IPaddr2 ip=10.1.2.43 cidr_netmask=32 nic=nas:2 op monitor interval=30

pcs resource create IPdisck2 ocf:heartbeat:IPaddr2 ip=10.1.2.44 cidr_netmask=32 nic=nas:3 op monitor interval=30
```

------

### Grupos

```bash
pcs resource group  add group_bases1 bases1 export_bases1 IPbases1

pcs resource group  add group_bases2 bases2 export_bases2 IPbases2

pcs resource group  add group_disck1 disck1 export_disck1 IPdisck1

pcs resource group  add group_disck2 disck2 export_disck2 IPdisck2

```
-------

### Constranis 

```bash
pcs constraint order \
    nfs_server-clone then group_bases1 INFINITY \
    require-all=true symmetrical=true \
    setoptions kind=Mandatory \
    id=o_nfs_bases1

pcs constraint order \
    nfs_server-clone then group_bases2 INFINITY \
    require-all=true symmetrical=true \
    setoptions kind=Mandatory \
    id=o_nfs_bases2

pcs constraint order \
    nfs_server-clone then group_disck1 INFINITY \
    require-all=true symmetrical=true \
    setoptions kind=Mandatory \
    id=o_nfs_disck1

pcs constraint order \
    nfs_server-clone then group_disck2 INFINITY \
    require-all=true symmetrical=true \
    setoptions kind=Mandatory \
    id=o_nfs_disck2
```

------

#### habilitar servicios
```bash
systemctl enable pcsd corosync pacemaker
```