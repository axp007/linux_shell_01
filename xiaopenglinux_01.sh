#!/usr/bin/bash
echo "欢迎使用初始化jio本"
read -p "是否安装epel源？Y/N:" an1
if [ $an1 = 'y' ] || [ $an1 = 'Y' ];then
#安装epel源
  echo "正在安装epel源，请耐心等待..."
  yum -y install epel-release &> /dev/null
else
  break
fi
{
read -p "是否需要配置base源?Y/N:" an2
if [ $an2 = 'y' ] || [ $an2 = 'Y' ];then
#配置yum源
/bin/cp  /etc/yum.repos.d/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo.bak
sed -ri "s/\(mirrorlist=\)/#1/g" /etc/yum.repos.d/CentOS-Base.repo
sed -ri "s/#\(baseurl=\)/1/g" /etc/yum.repos.d/CentOS-Base.repo
else
  break
fi
}
{
read -p "是否需要配置epel源？Y/N:" an3
if [ $an3 = 'y' ] || [ $an3 = 'Y' ];then
  /bin/cp /etc/yum.repos.d/epel.repo  /etc/yum.repos.d/epel.repo.bak
  sed -ri "s/\(mirrorlist=\)/#1/g" /etc/yum.repos.d/epel.repo
  sed -ri "s/.*\(baseurl=\)/1/g" /etc/yum.repos.d/epel.repo
else
  break
fi
}
read -p "是否清楚缓存并建立新的缓存？Y/N:" an4
if [ $an4 = 'y' ] || [ $an4 = 'Y' ];then
  echo "正在清理缓存并建立新的缓存，请稍后..."
  #清除缓存
  yum clean all  &> /dev/null
  #新建缓存
  yum makecache &> /dev/null
  if [ $? -eq 0 ];then
    echo "缓存建立完成！"
  else 
    echo "缓存建立失败，请检查网络或者日志文件！"
  fi
else
  break
fi
#关闭防火墙
systemctl stop firewalld  &> /dev/null
systemctl disable firewalld &> /dev/null

#关闭selinux
setenforce 0 &> /dev/null
sed -ri 's/\(SELINUX=\)enforcing/\1disabled' /etc/selinux/config &> /dev/null
yum -y install vim wget lsfo   &> /dev/null
if [ $? -eq 0 ];then
    echo "常用工具安装完成,祝您使用愉快！"
else
    echo "常用工具安装失败，请检查网络或日志"
fi
