#!/bin/bash
ifsuse=$(cat /proc/version | grep -i suse)

if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi

#redis
if [ ! -f redis-3.1.0.tgz ];then
	wget http://pecl.php.net/get/redis-3.1.0.tgz
fi
rm -rf redis-3.1.0
tar -xzvf redis-3.1.0.tgz
cd redis-3.1.0
/alidata/server/php/bin/phpize
./configure --with-php-config=/alidata/server/php/bin/php-config
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "extension=redis.so" >> /alidata/server/php/etc/php.ini
