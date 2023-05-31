#!/bin/bash
INSTALLDIR=`pwd`
##########################
rm -rf jemalloc-3.6.0
 if [ ! -f jemalloc-3.6.0.tar.bz2 ];then
     wget https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2
 fi
tar jxvf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure
make
make install
cd ..

if [ ! -f pcre-8.41.tar.gz ];then
    wget https://nchc.dl.sourceforge.net/project/pcre/pcre/8.41/pcre-8.41.tar.gz
fi
rm -rf pcre-8.41
tar zxvf pcre-8.41.tar.gz
cd pcre-8.41
./configure
make
make install
cd ..

if [ ! -f zlib-1.2.13.tar.gz ];then
    wget http://www.zlib.net/zlib-1.2.13.tar.gz
fi
rm -rf zlib-1.2.13
tar zxvf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure
make CFLAGS=-fpic
make install
cd ..

rm -rf openssl-1.0.2m
tar zxvf openssl-1.0.2m.tar.gz
##########################
groupadd  www
useradd -g www www
mkdir /alidata/server/nginx/logs -p
 rm -rf  tengine-2.3.3 
 if [ ! -f tengine-2.3.3.tar.gz ];then
    wget http://tengine.taobao.org/download/tengine-2.3.3.tar.gz
 fi
tar zxvf tengine-2.3.3.tar.gz
cd tengine-2.3.3
./configure --prefix=/alidata/server/nginx \
  --user=www \
  --group=www \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-http_gzip_static_module \
  --with-http_flv_module \
  --with-openssl=$INSTALLDIR/openssl-1.0.2m \
  --with-zlib=$INSTALLDIR/zlib-1.2.13 \
  --with-pcre=$INSTALLDIR/pcre-8.41 \
  --with-jemalloc=$INSTALLDIR/jemalloc-3.6.0
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j $CPU_NUM
else
    make
fi
 make install
cd ..

chmod 775 /alidata/server/nginx/logs
touch /alidata/server/nginx/logs/nginx.pid
chown -R www:www /alidata/server/nginx/logs
chmod -R 775 /alidata/www
chown -R www:www /alidata/www
cd tengine
cp -fR ./config-tengine/*  /alidata/server/nginx/conf
mv /alidata/server/nginx/conf/index.php /alidata/www/default/
chown www:www  /alidata/www/default/index.php
mv /alidata/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
sleep 2
/etc/init.d/nginx start
