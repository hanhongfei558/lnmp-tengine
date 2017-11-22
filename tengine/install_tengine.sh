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

rm -rf openssl-1.0.2j
tar zxvf openssl-1.0.2j.tar.gz
##########################
groupadd  www
useradd -g www www
mkdir /alidata/server/nginx/logs -p
 rm -rf  tengine-2.1.2 
 if [ ! -f tengine-2.1.2.tar.gz ];then
    wget http://tengine.taobao.org/download/tengine-2.1.2.tar.gz
 fi
tar zxvf tengine-2.1.2.tar.gz
cd tengine-2.1.2
./configure --prefix=/alidata/server/nginx \
  --user=www \
  --group=www \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-http_gzip_static_module \
  --with-http_concat_module=shared \
  --with-http_flv_module \
  --with-openssl=$INSTALLDIR/openssl-1.0.2j \
  --with-zlib=$INSTALLDIR/zlib-1.2.8 \
  --with-pcre=$INSTALLDIR/pcre-8.36 \
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
chown -R www:www /alidata/server/nginx/logs
chmod -R 775 /alidata/www
chown -R www:www /alidata/www
cd tengine
cp -fR ./config-tengine/*  /alidata/server/nginx/conf
mv /alidata/server/nginx/conf/index.php /alidata/www/default/
chown www:www  /alidata/www/default/index.php
mv /alidata/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
/etc/init.d/nginx start
