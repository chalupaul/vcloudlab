yum -y update
yum -y install @virt* dejavu-lgc-* xorg-x11-xauth tigervnc \
libguestfs-tools policycoreutils-python bridge-utils

sed -i 's/^\(net.ipv4.ip_forward =\).*/\1 1/' /etc/sysctl.conf; sysctl -p

chkconfig network on
service network restart
yum -y erase NetworkManager
cp -p /etc/sysconfig/network-scripts/ifcfg-{eth0,br0}
sed -i -e'/HWADDR/d' -e'/UUID/d' -e's/eth0/br0/' -e's/Ethernet/Bridge/' \
/etc/sysconfig/network-scripts/ifcfg-br0
echo DELAY=0 >> /etc/sysconfig/network-scripts/ifcfg-br0
echo 'BOOTPROTO="none"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo BRIDGE=br0 >> /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
brctl show

virt-install \
  --os-variant=rhel6 \
  --network model=virtio,bridge=br0 \
  --disk /var/lib/libvirt/images/esxi.qcow2,sparse=false,bus=virtio,size=1 \
  --location=http://mirror.centos.org/centos/6/os/x86_64 \
  --graphics vnc,password=octolibations \
  --vcpus=1 \
  --ram=256 \
  --name=esix
