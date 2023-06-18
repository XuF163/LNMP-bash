#!bin/bash
#这是给linux课设用的
#2023.6.18 于ujs
echo "root authening"
if [ $USER = root ]
then
     echo "获取到root,lnmp安装脚本，启动！"
else
     echo "root鉴权失败"
     exit
fi

clear
systemctl disable firewalld.service 
if [ $? -eq 0 ];then
  echo "防火墙已设置为开机不启动"
else
  echo "防火墙开机不启动设置失败，请重新开始"
  exit
fi

clear
echo "---------------------"
echo "安装epel源"
yum install -y epel-release
sleep 30
echo "Nginx installing..."
yum insatll -y nginx
sleep 20
clear 
echo "firewall resetting"
systemctl stop firwalld
sleep 3
echo "firewall closed"
echo "adding nginx to open machine staring.."
systemctl enable nginx.service
echo "sarting with machine done!"
echo "usr reset"
 groupadd www -g 666&&useradd www -u 666 -g 666 -s /sbin/nologin -M&&sed -i '/^user/c user www;' /etc/nginx/nginx.conf
systemctl start nginx
clear


sleep 5
echo "php installing"
cat>/etc/yum.repos.d/php.repo<<EOF
[php]
name = php Repository
baseurl = https://repo.webtatic.com/yum/el7/x86_64/
gpgcheck = 0
EOF
echo "usr rest for php"
sed -i '/^user/c user = www' /etc/php-fpm.d/www.conf
sed -i '/^group/c group = www' /etc/php-fpm.d/www.conf
clear
echo "auto staring for php..."
 systemctl start php-fpm&&systemctl enable php-fpm
echo "Finished intalling `php -v`"

clear
echo "Insatlling mdb ..."
 yum install mariadb-server mariadb -y&&systemctl start mariadb&&systemctl enable mariadb&&mysqladmin password '123456'&&mysql -uroot -p123456&&echo "database installed"
