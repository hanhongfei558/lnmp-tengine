当前版本version 1.4.0

------------------------- 自动安装过程 -------------------------

此安装包可在阿里云所有centos 7.4 64位系统上部署安装。

此安装包包含的软件及版本为：
tengine：2.2.2
mysql：5.6.38
php：7.2.2
php扩展：redis
ftp：（yum安装）

依赖软件说明：
在centos 7.X 64位系统上部署要求tengine依赖软件jemalloc版本为3.6.0
4.0以上版本在glibc版本比较老的系统下编译tengine会报undefined reference to `clock_gettime'错误

安装步骤：

xshell/xftp上传lnmp-tengine目录

chmod –R 777 lnmp-tengine
cd lnmp-tengine
./install.sh

安装完成后请查看account.log文件，数据库密码在里面。

如果环境不需要安装mysql则使用下面的脚本一键安装不包括mysql组件的环境
./install-nomysql.sh

--------------------------- version 1.3.0 测试记录 --------------------------

以下为此脚本在阿里云linux系统测试记录（抽样测试）:
centos 7.4/64位/1核512M/无数据盘     --->测试ok
centos 7.4/64位/4核4G/50G数据盘      --->测试ok
