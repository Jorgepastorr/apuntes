https://access.redhat.com/documentation/es-es/red_hat_enterprise_linux/8/html/configuring_and_managing_high_availability_clusters/assembly_configuring-gfs2-in-a-cluster-configuring-and-managing-high-availability-clusters

3 maquinas 2 nodos 1 cliente

instalacion de pacemaker

    yum install -y epel-release
    yum install  -y pcs fence-agents-all
    systemctl enable --now pcsd.service
    echo reverse | passwd --stdin hacluster

    pcs cluster auth node01 node02
    pcs cluster setup --start --name mycluster node01 node02
    pcs cluster enable --all

    https://node01:2224

---

parte iscsi

node03

yum -y install targetcli
mkdir /var/lib/iscsi_disks

targetcli

crear 2 discos uno de datos y otro de fence

    cd backstores/fileio
    create disk00 /var/lib/isci_disks/disk00.img 1G
    create disk01 /var/lib/isci_disks/disk01.img 1G

    cd /iscsi
    create iqn.2019-07.lpic.lan:storage.target00
    create iqn.2019-07.lpic.lan:fence.target01

    cd iqn.2019-07.lpic.lan:storage.target00/tpg1/luns
    create /backstorage/fileio/disk00

    cd ../acls
    create iqn.2019-07.lpic.lan:node01.lpic.lan
    create iqn.2019-07.lpic.lan:node02.lpic.lan

    cd iqn.2019-07.lpic.lan:node01.lpic.lan/
    set auth userid=node01
    set auth password=reverse

    cd ../iqn.2019-07.lpic.lan:node02.lpic.lan
    set auth userid=node02
    set auth password=reverse

    cd /iscsi/iqn.2019-07.lpic.lan:fence.target00/tpg1/luns
    create /backstorage/fileio/disk01

    cd ../acls
    create iqn.2019-07.lpic.lan:node01.lpic.lan
    create iqn.2019-07.lpic.lan:node02.lpic.lan

    cd iqn.2019-07.lpic.lan:node01.lpic.lan/
    set auth userid=node01
    set auth password=reverse

    cd ../iqn.2019-07.lpic.lan:node02.lpic.lan
    set auth userid=node02
    set auth password=reverse

systemctl enable target
ss -ltn | grep 3260

nodo01 nodo02

yum install iscsi-initiator-utils

vim /etc/iscsi/initiatorname.iscsi
    InitiatorName=iqn.2019-07.lpic.lan:node02.lpic.lan

vim /etc/iscsi/iscsi.conf
    node.session.auth.authmethod = CHAP
    node.session.auth.username = node02
    node.session.auth.password = reverse

iscsiadm -m discovery -t sendtargets -p 192.168.33.13
iscsiadm -m node --login
iscsi -m session -o show

lsblk # ver los dos discos asignados

fin de parte iscsi

---

nodo01,2

yum install -y fence-agents-all lvm2-cluster gfs2-utils

lvmconf --enable-cluster
reiniciar maquinas

pcs stonith create scsi-shooter fence_scsi devices=/dev/disk/by-id/wwn-* meta provides=unfencing
pcs property set no-quorum-policy0freeze
pcs stonith show scsi-shooter

pcs resource create dlm ocf:pacemaker:controld op monitor interval=30s on-fail=fence clone interleave=true ordered=true
pcs resource create clvmd ocf:heartbeat:clvm op monitor interval=30s on-fail=fence clone interleave=true ordered=true
pcs constraint order start dlm-clone then clvmd-clone
pcs constraint colocation add clvmd-clone with dlm-clone

pcs status resources

---

vgcreate vg_cluster /dev/sdb
lvcreae -l100%FREE -n lv_cluster vg_cluster
mkfs.gfs2 -p lock_dlm -t ha_cluster:gfs2 -j 2 /dev/vg_cluster/lv_cluster

pcs resource create fs_gfs2 Filesystem device="/dev/vg_cluster/lv_cluster" directory="/mnt" \
    fstype="gfs2" options="noatime,nodiratime" op monitor interval=10s on-fail=fence \
    clone interleave=true

