#!/usr/bin/env bash
set -ex

#centos7还是6
sysver=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`

cd  /etc/yum.repos.d/

if [ ! -f  CentOS-Base.repo.bak ]
then
    cp -rf CentOS-Base.repo{,.bak}
fi
#
echo "配置base软件源"
curl -o CentOS-Base.repo -sSL https://lug.ustc.edu.cn/wiki/_export/code/mirrors/help/centos?codeblock=$((sysver-4))

echo "配置epel源"
yum remove -y epel-release || true
yum install -y epel-release
sed -e 's!^mirrorlist=!#mirrorlist=!g' \
        -e 's!^#baseurl=!baseurl=!g' \
        -e 's!//download\.fedoraproject\.org/pub!//mirrors.ustc.edu.cn!g' \
        -e 's!http://mirrors\.ustc!https://mirrors.ustc!g' \
        -i /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo


yum install -y yum-utils || true

echo "配置ius源"
yum install -y https://centos${sysver}.iuscommunity.org/ius-release.rpm

yum install -y yum-plugin-replace || true

echo "配置remi源"
yum install -y http://rpms.famillecollet.com/enterprise/remi-release-${sysver}.rpm
echo "if you want update php ,execute follow command:"
echo " yum install php php-gd php-mysql php-mcrypt "
echo ""

yum-config-manager --enable remi-php56

echo "配置codeit源"
cd /etc/yum.repos.d && curl -o codeit.el${sysver}.repo -sSL https://repo.codeit.guru/codeit.el${sysver}.repo
echo "if you want update httpd ,execute follow command:"
echo " yum install httpd "
echo ""

yum repolist