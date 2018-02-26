#!/bin/bash

####---- global variables ----begin####
export tengine_version=2.2.2
export mysql_version=

####---- global variables ----end####
web=nginx
php72=7.2.2


####---- Clean up the environment ----begin####
echo "will be installed, wait ..."
./uninstall.sh in &> /dev/null
####---- Clean up the environment ----end####


web_dir=nginx-${tengine_version}
php72_dir=php-${php72}

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi


####---- global variables ----begin####
export web
export web_dir
export php72_dir
####---- global variables ----end####


ifredhat=$(cat /proc/version | grep redhat)
ifcentos=$(cat /proc/version | grep centos)
ifubuntu=$(cat /proc/version | grep ubuntu)
ifdebian=$(cat /proc/version | grep -i debian)
ifgentoo=$(cat /proc/version | grep -i gentoo)
ifsuse=$(cat /proc/version | grep -i suse)

####---- install dependencies ----begin####
if [ "$ifcentos" != "" ] || [ "$machine" == "i686" ];then
rpm -e httpd-2.2.3-31.el5.centos gnome-user-share &> /dev/null
fi

\cp /etc/rc.local /etc/rc.local.bak > /dev/null
if [ "$ifredhat" != "" ];then
rpm -e --allmatches mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
fi

if [ "$ifredhat" != "" ];then
  \mv /etc/yum.repos.d/rhel-debuginfo.repo /etc/yum.repos.d/rhel-debuginfo.repo.bak &> /dev/null
  \cp ./res/rhel-debuginfo.repo /etc/yum.repos.d/
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip bzip2 automake fiex* libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  iptables -F
elif [ "$ifcentos" != "" ];then
#	if grep 5.10 /etc/issue;then
	  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5 &> /dev/null
#	fi
  sed -i 's/^exclude/#exclude/' /etc/yum.conf
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip bzip2 automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  yum -y update bash
  #ln -s /usr/lib64/mysql/libmysqlclient.so   /usr/lib/libmysqlclient.so   mysql-devel mysql
  #ln -s /usr/lib64/mysql/libmysqlclient_r.so   /usr/lib/libmysqlclient_r.so
  iptables -F
elif [ "$ifubuntu" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip build-essential libncurses5-dev libfreetype6-dev libxml2-dev  libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  apt-get -y install --only-upgrade bash
  #ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so  mysql-client libmysqld-dev
  #ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so

  iptables -F
elif [ "$ifdebian" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip psmisc build-essential libncurses5-dev libfreetype6-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  apt-get -y install --only-upgrade bash
  iptables -F
elif [ "$ifgentoo" != "" ];then
  emerge net-misc/curl
elif [ "$ifsuse" != "" ];then
  zypper install -y libxml2-devel libopenssl-devel libcurl-devel
fi
####---- install dependencies ----end####

####---- install software ----begin####
rm -f tmp.log
echo tmp.log

./env/install_set_sysctl.sh
./env/install_set_ulimit.sh

if [ -e /dev/xvdb ] && [ "$ifsuse" == "" ] ;then
	./env/install_disk.sh
fi

if [ -e /dev/vdb ] && [ "$ifsuse" == "" ] ;then
	./env/install_disk_io.sh
fi

./env/install_dir.sh
echo "---------- make dir ok ----------" >> tmp.log

./env/install_env_php.sh
./env/update_openssl.sh
echo "---------- env ok ----------" >> tmp.log

./tengine/install_tengine.sh
echo "---------- tengine-2.2.2 ok ----------" >> tmp.log
####install multi php####
#$php72
for php_version in $php72
do
    ./php/install_nginx_php-${php_version}.sh
done

####set default php version####
ln -s /alidata/server/$php72_dir  /alidata/server/php

####install php extension####
./php/install_php_extension.sh
echo "---------- php extension ok ----------" >> tmp.log


####---- Environment variable settings ----begin####
if ! cat /etc/profile | grep "export PATH=$PATH:/alidata/server/nginx/sbin:/alidata/server/php/sbin:/alidata/server/php/bin" &> /dev/null;then
    echo 'export PATH=$PATH:/alidata/server/nginx/sbin:/alidata/server/php/sbin:/alidata/server/php/bin' >> /etc/profile
    #export PATH=$PATH:/alidata/server/nginx/sbin:/alidata/server/php/sbin:/alidata/server/php/bin
fi
source /etc/profile
####---- Environment variable settings ----end####

####---- Start command is written to the rc.local ----begin####
if ! cat /etc/rc.local | grep "/etc/init.d/php-fpm start" &> /dev/null;then
    echo "/etc/init.d/php-fpm start" >> /etc/rc.local
fi

if ! cat /etc/rc.local | grep "/etc/init.d/nginx start" &> /dev/null;then
    echo "/etc/init.d/nginx start" >> /etc/rc.local
fi

####---- Start command is written to the rc.local ----end####
echo "---------- rc init ok ----------" >> tmp.log

####---- centos yum configuration----begin####
if [ "$ifcentos" != "" ] && [ "$machine" == "x86_64" ];then
sed -i 's/^#exclude/exclude/' /etc/yum.conf
fi
if [ "$ifubuntu" != "" ] || [ "$ifdebian" != "" ];then
	mkdir -p /var/lock
	sed -i 's#exit 0#touch /var/lock/local#' /etc/rc.local
else
	mkdir -p /var/lock/subsys/
fi
####---- centos yum configuration ----end####

####---- restart ----begin####
/etc/init.d/php-fpm restart &> /dev/null
/etc/init.d/nginx restart &> /dev/null
####---- restart ----end####


####---- make configure soft link----start#### 
mkdir /etc/nginx
ln -s /alidata/server/nginx/conf /etc/nginx/
mkdir /etc/php
ln -s /alidata/server/php/etc/php.ini /etc/php/
ln -s /alidata/server/php/etc/php-fpm.conf /etc/php/

####---- make configure soft link----end#### 
if grep -i "CentOS Linux release 7" /etc/redhat-release  &> /dev/null; then
  chmod +x /etc/rc.d/rc.local
fi
####---- log ----begin####
cat tmp.log
source /etc/profile &> /dev/null
source /etc/profile.d/profile.sh &> /dev/null
####---- log ----end####
