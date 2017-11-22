------------------------- 自动安装过程 -------------------------

此安装包可在阿里云所有centos 6.5 64位系统上部署安装。

此安装包包含的软件及版本为：
tengine：2.1.2
mysql：5.1.73、5.5.40、5.6.34
php：5.6.28
php扩展：redis
ftp：（yum安装）

安装步骤：

xshell/xftp上传lnmp-tengine目录

chmod –R 777 lnmp-tengine
cd lnmp-tengine
./install.sh

安装完成后请查看account.log文件，数据库密码在里面。


--------------------------- version 1.0.0 测试记录 --------------------------

以下为此脚本在阿里云linux系统测试记录（抽样测试）:
centos 6.5/64位/1核512M/无数据盘     --->测试ok
centos 6.5/64位/4核4G/50G数据盘      --->测试ok
