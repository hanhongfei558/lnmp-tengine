#!/bin/sh

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ ! -f libiconv-1.15.tar.gz ];then
	wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
fi
rm -rf libiconv-1.15
tar zxvf libiconv-1.15.tar.gz
cd libiconv-1.15
./configure --prefix=/usr/local
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f zlib-1.2.11.tar.gz ];then
	wget http://www.zlib.net/zlib-1.2.11.tar.gz
fi
rm -rf zlib-1.2.11
tar zxvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

if [ ! -f freetype-2.8.1.tar.gz ];then
	wget https://download.savannah.gnu.org/releases/freetype/freetype-2.8.1.tar.gz
fi
rm -rf freetype-2.8.1
tar zxvf freetype-2.8.1.tar.gz
cd freetype-2.8.1
./configure --prefix=/usr/local/freetype.2.8.1
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f libpng-1.2.59.tar.gz ];then
    wget ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng12/libpng-1.2.59.tar.gz
fi
rm -rf libpng-1.2.59
tar zxvf libpng-1.2.59.tar.gz
cd libpng-1.2.59
./configure --prefix=/usr/local/libpng.1.2.59
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

if [ ! -f libevent-1.4.14b.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/libevent-1.4.14b.tar.gz
fi
rm -rf libevent-1.4.14b
tar zxvf libevent-1.4.14b.tar.gz
cd libevent-1.4.14b
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f pcre-8.41.tar.gz ];then
	wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz
fi
rm -rf pcre-8.41
tar zxvf pcre-8.41.tar.gz
cd pcre-8.41
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f jpegsrc.v6b.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/jpegsrc.v6b.tar.gz
fi
rm -rf jpeg-6b
tar zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
if [ -e /usr/share/libtool/config.guess ];then
cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ];then
cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ];then
cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ];then
cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/usr/local/jpeg.6 --enable-shared --enable-static
mkdir -p /usr/local/jpeg.6/include
mkdir /usr/local/jpeg.6/lib
mkdir /usr/local/jpeg.6/bin
mkdir -p /usr/local/jpeg.6/man/man1
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install-lib
make install
cd ..

#load /usr/local/lib .so
touch /etc/ld.so.conf.d/usrlib.conf
echo "/usr/local/lib" > /etc/ld.so.conf.d/usrlib.conf
/sbin/ldconfig

#create account.log
cat > account.log << END
##########################################################################
# 
# thank you for using aliyun virtual machine
# 
##########################################################################

FTP:
account:www
ftp_password:ftp_password_value

MySQL:
account:root
mysql_password:mysql_password_value
END

