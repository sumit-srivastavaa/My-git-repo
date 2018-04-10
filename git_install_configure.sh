#!/bin/bash

echo "[epel]" >> /etc/yum.repos.d/epel.repo
echo "name=Extra Packages for Enterprise Linux 7 - $basearch" >> /etc/yum.repos.d/epel.repo
echo "mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch" >> /etc/yum.repos.d/epel.repo
echo "failovermethod=priority" >> /etc/yum.repos.d/epel.repo
echo "enabled=1" >> /etc/yum.repos.d/epel.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/epel.repo
echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7" >> /etc/yum.repos.d/epel.repo


yum install git -y

cd ~
echo "enter project name: "
read p
git init $p
echo "project is ready start working now!!"
