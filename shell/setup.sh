#!/bin/bash
## -----------------------
## Version setting
## -----------------------

URL=http://10.134.3.8/software
APP_HOME=/home/work/local
APP_DW_HOME=/home/software/tmp

JDK_VERSION=jdk1.7.0_80

MAVEN_VERSION=apache-maven-3.0.5

TOMCAT_VERSION=tomcat_vpn

REDIS_VERSION=redis-3.2.3

MYSQL_VERSION=mysql-server_5.7.14-1ubuntu14.04_amd64.deb-bundle

NGINX_VERSION=nginx-1.10.1
NGINX_REDIS_VERSION=ngx_http_redis-0.3.7
NGINX_REDIS2_VERSION=redis2-nginx-module-0.11
NGINX_SRCACHE_VERSION=srcache-nginx-module-0.26
NGINX_DEVEL_VERSION=ngx_devel_kit-0.2.19
NGINX_MISC_VERSION=set-misc-nginx-module-0.24
NGINX_SLOWFS_VERSION=ngx_slowfs_cache-1.10
NGINX_PURGE_VERSION=ngx_cache_purge-2.1
NGINX_PHP_VERSION=ngx_http_php_session-0.3
NGINX_ACCOUNTING_VERSION=ngx_http_accounting_module-0.2
NGINX_CONSISTENT_VERSION=ngx_http_consistent_hash
NGINX_ECHO_VERSION=echo-nginx-module
NGINX_PCRE_VERSION=pcre-8.39

mkdir -p ${APP_HOME}
mkdir -p ${APP_HOME}

## -----------------------
## Setup JDK
## -----------------------
setup_jdk() {
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer
	sudo apt-get install oracle-java8-set-default
	sudo sudo update-java-alternatives -s java-8-oracle
	sudo java -version
	sudo which java
	#　update-alternatives --config java
	#修改path 
	#    cd ${APP_HOME}
	#    rm -f ${APP_DW_HOME}/${JDK_VERSION}*
	#    rm -rf ${JDK_VERSION}
	#    wget ${URL}/jdk/${JDK_VERSION}.tar.gz -O  ${APP_DW_HOME}/${JDK_VERSION}.tar.gz
	#    tar -zxvf ${APP_DW_HOME}/${JDK_VERSION}.tar.gz 
	#    echo "yes" | ${APP_HOME}/${JDK_VERSION} | cat
	#    rm -rf ${APP_HOME}/jdk
	#    ln -s ${APP_HOME}/${JDK_VERSION} ${APP_HOME}/jdk

}

## -----------------------
## Setup maven
## -----------------------
setup_maven() {
	#sudo apt-get install maven2
    cd ${APP_HOME}
    rm -f ${APP_DW_HOME}/${MAVEN_VERSION}-bin.tar.gz
    rm -rf ${MAVEN_VERSION}
    wget ${URL}/maven/${MAVEN_VERSION}-bin.tar.gz -O ${APP_DW_HOME}/${MAVEN_VERSION}-bin.tar.gz
    tar zxvpf ${APP_DW_HOME}/${MAVEN_VERSION}-bin.tar.gz
     rm -rf ${APP_HOME}/maven
    ln -s ${APP_HOME}/${MAVEN_VERSION} ${APP_HOME}/maven
    #wget ${URL}/setup/conf/maven/settings.xml -O ${APP_HOME}/maven/conf/settings.xml
}

## -----------------------
## Setup tomcat
## -----------------------
setup_tomcat() {
#	useradd -r -m -s /bin/bash work 
#	su -work
#	alias rtm='ps -aux| grep tomcat_vpn |awk '\''{print$2}'\''|xargs kill -9 ;/home/work/local/tomcat_vpn/bin/startup.sh'
#	alias vpu='cd /home/work/webroot/vpn-api ;ps -aux| grep tomcat_vpn |awk '\''{print$2}'\''|xargs kill -9 ;mvn clean;git pull;mvn install -Ppro; rtm;'
#	
	
 	cd ${APP_HOME}
    rm -f ${APP_DW_HOME}/${TOMCAT_VERSION}.tar.bz2
    rm -rf ${TOMCAT_VERSION}
    wget ${URL}/tomcat/${TOMCAT_VERSION}.tar.bz2 -O ${APP_DW_HOME}/${TOMCAT_VERSION}.tar.bz2
    tar -jxvf ${APP_DW_HOME}/${TOMCAT_VERSION}.tar.bz2
}

## -----------------------
## Setup MySQL
## -----------------------
 setup_mysql() {
 	groupadd mysql
    useradd -d /home/mysql -g mysql mysql
 	killall -TERM mysqld
 	apt-get install mysql-server-5.6 mysql-client-5.6
    #groupadd mysql
    #useradd -d /home/mysql -g mysql mysql
    #dpkg -l |grep mysql | awk '{print$2}'|xargs dpkg -P
    #mkdir -p /home/mysql/data
    #chown mysql /home/mysql/data
    #chgrp mysql /home/mysql/data
    #cd ${APP_DW_HOME}
    #rm -f *mysql*
    #rm -rf /var/lib/mysql*
    #rm -rf /etc/mysql*
    #wget ${URL}/store/${MYSQL_VERSION}.tar
    #tar xvf ${APP_DW_HOME}/${MYSQL_VERSION}.tar
   	#dpkg -i mysql-common_5.7.14-1ubuntu14.04_amd64.deb 
   	##wget ${URL}/setup/myconf/mysql/my.cnf -O /etc/mysql/my.cnf
   	#dpkg-preconfigure  mysql-community-server_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i mysql-community-client_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i libmysqlclient20_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i libmysqlclient-dev_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i libmysqld-dev_5.7.14-1ubuntu14.04_amd64.deb 
   	#dpkg -i mysql-client_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i mysql-common_5.7.14-1ubuntu14.04_amd64.deb
   	#sudo apt-get -f install
   	#
   	##wget ${URL}/setup/myconf/mysql/my.cnf -O /etc/mysql/my.cnf
   	#
   	#dpkg -i mysql-community-server_5.7.14-1ubuntu14.04_amd64.deb
   	#dpkg -i mysql-server_5.7.14-1ubuntu14.04_amd64.deb 
    #
    ##mv /etc/mysql/my.cnf /etc/mysql/my.cnf_bak
    
    
    whereis mysql
}
## -----------------------
## Setup mysql_set
## -----------------------
# mysql_setshell() {
##	use mysql
##	UPDATE user SET password=PASSWORD('vpn@5296') WHERE user='root'
##	FLUSH PRIVILEGES
##	quit
##	create user vpn
##	update user set password=password("vpn@5296") where user="vpn"
##	create database vpn
##	grant all on vpn.* to 'vpn'
##	flush privileges
##	quit
#}

## -----------------------
## Setup redis
## -----------------------
setup_user() {
 	useradd -r -m -s /bin/bash work
 	passwd work  
 	chmod u+w /etc/sudoers
 	vi  /etc/sudoers
 	#root ALL=(ALL) ALL
 	su - work
 	mkdir local
 	mkdir  webroot 
 	mkdir -p var/log 

}

## -----------------------
## Setup redis
## -----------------------
setup_redis() {
 	cd ${APP_DW_HOME}
    rm -f ${APP_DW_HOME}/${REDIS_VERSION}.tar.bz2
    rm -rf ${REDIS_VERSION}
    rm -rf ${APP_HOME}/${REDIS_VERSION}
    rm -rf ${APP_HOME}/redis
    wget ${URL}/store/${REDIS_VERSION}.tar.gz -O ${APP_DW_HOME}/${REDIS_VERSION}.tar.gz
    tar -zxvf ${APP_DW_HOME}/${REDIS_VERSION}.tar.gz
    cd ${APP_DW_HOME}/${REDIS_VERSION}	
    make -j4
    mkdir -p ${APP_HOME}/${REDIS_VERSION}/bin 
    cp ${APP_DW_HOME}/${REDIS_VERSION}/src/redis*  ${APP_HOME}/${REDIS_VERSION}/bin/
    rm ${APP_HOME}/${REDIS_VERSION}/bin/*.o  ${APP_HOME}/${REDIS_VERSION}/bin/*.c ${APP_HOME}/${REDIS_VERSION}/bin/*.h
     
 	ln -s ${APP_HOME}/${REDIS_VERSION} ${APP_HOME}/redis 
 	wget ${URL}/setup/myconf/redis/redis.conf -O ${APP_HOME}/redis/redis.conf
 	${APP_HOME}/redis/bin/redis-server  ${APP_HOME}/redis/redis.conf
 	
}

## -----------------------
## Setup nginx
## -----------------------
setup_nginx() {
    cd ${APP_DW_HOME}
    rm -f ${NGINX_VERSION}.tar.gz
    rm -rf ${NGINX_VERSION}
    rm -rf ${APP_HOME}/${NGINX_VERSION}
    wget ${URL}/nginx/${NGINX_VERSION}.tar.gz
    tar zxvf ${NGINX_VERSION}.tar.gz

	rm -f ${NGINX_REDIS_VERSION}.tar.gz
    rm -rf ${NGINX_REDIS_VERSION}
    wget ${URL}/nginx/${NGINX_REDIS_VERSION}.tar.gz
    tar zxvf ${NGINX_REDIS_VERSION}.tar.gz
    
    rm -f ${NGINX_REDIS2_VERSION}.tar.gz
    rm -rf ${NGINX_REDIS2_VERSION}
    wget ${URL}/nginx/${NGINX_REDIS2_VERSION}.tar.gz
    tar zxvf ${NGINX_REDIS2_VERSION}.tar.gz
    
    rm -f ${NGINX_SRCACHE_VERSION}.tar.gz
    rm -rf ${NGINX_SRCACHE_VERSION}
    wget ${URL}/nginx/${NGINX_SRCACHE_VERSION}.tar.gz
    tar zxvf ${NGINX_SRCACHE_VERSION}.tar.gz
    
    rm -f ${NGINX_DEVEL_VERSION}.tar.gz
    rm -rf ${NGINX_DEVEL_VERSION}
    wget ${URL}/nginx/${NGINX_DEVEL_VERSION}.tar.gz
    tar zxvf ${NGINX_DEVEL_VERSION}.tar.gz
    
    rm -f ${NGINX_MISC_VERSION}.tar.gz
    rm -rf ${NGINX_MISC_VERSION}
    wget ${URL}/nginx/${NGINX_MISC_VERSION}.tar.gz
    tar zxvf ${NGINX_MISC_VERSION}.tar.gz
    
    rm -f ${NGINX_SLOWFS_VERSION}.tar.gz
    rm -rf ${NGINX_SLOWFS_VERSION}
    wget ${URL}/nginx/${NGINX_SLOWFS_VERSION}.tar.gz
    tar zxvf ${NGINX_SLOWFS_VERSION}.tar.gz
    
    rm -f ${NGINX_PURGE_VERSION}.tar.gz
    rm -rf ${NGINX_PURGE_VERSION}
    wget ${URL}/nginx/${NGINX_PURGE_VERSION}.tar.gz
    tar zxvf ${NGINX_PURGE_VERSION}.tar.gz
    
    rm -f ${NGINX_PHP_VERSION}.tar.gz
    rm -rf ${NGINX_PHP_VERSION}
    wget ${URL}/nginx/${NGINX_PHP_VERSION}.tar.gz
    tar zxvf ${NGINX_PHP_VERSION}.tar.gz
    
    rm -f ${NGINX_ACCOUNTING_VERSION}.tar.gz
    rm -rf ${NGINX_ACCOUNTING_VERSION}
    wget ${URL}/nginx/${NGINX_ACCOUNTING_VERSION}.tar.gz
    tar zxvf ${NGINX_ACCOUNTING_VERSION}.tar.gz
    
    rm -f ${NGINX_PCRE_VERSION}.zip
    rm -rf ${NGINX_PCRE_VERSION}
    wget ${URL}/nginx/${NGINX_PCRE_VERSION}.zip
    unzip ${NGINX_PCRE_VERSION}.zip
    
    rm -rf ${NGINX_ECHO_VERSION}
    git clone git://github.com/agentzh/echo-nginx-module.git

    rm -rf ${NGINX_CONSISTENT_HASH_VERSION}
    git clone https://github.com/replay/ngx_http_consistent_hash.git

	
    cd ${NGINX_VERSION}
	./configure --prefix=${APP_HOME}/${NGINX_VERSION} --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module \
	--with-pcre=../${NGINX_PCRE_VERSION}
	--add-module=../${NGINX_REDIS_VERSION} --add-module=../${NGINX_REDIS2_VERSION} --add-module=../${NGINX_SRCACHE_VERSION} \
	--add-module=../${NGINX_DEVEL_VERSION} --add-module=../${NGINX_PURGE_VERSION} --add-module=../${NGINX_SLOWFS_VERSION=} \
	--add-module=../${NGINX_PHP_VERSION} --add-module=../${NGINX_ACCOUNTING_VERSION} --add-module=../${NGINX_CONSISTENT_VERSION}  \
	--add-module=../${NGINX_CONSISTENT_VERSION} --add-module=../${NGINX_ECHO_VERSION}
	make -j4
    make install
    rm -rf ${APP_HOME}/nginx
    ln -s ${APP_HOME}/${NGINX_VERSION} ${APP_HOME}/nginx
    wget ${URL}/setup/myconf/nginx/conf/nginx.conf -O ${APP_HOME}/nginx/conf/nginx.conf
    rm -rf ${APP_HOME}/nginx/html
}

## -----------------------
## Setup all aboves
## -----------------------
setup_all() {
    setup_jdk
    setup_maven
    setup_nginx
    setup_mysql
    setup_mongodb
    setup_python
    setup_rsync
    setup_tomcat
}

## -----------------------
## Show help message
## -----------------------
usage() {
    echo "Available arguments as below:"
    echo "jdk           Setup JDK"
    echo "maven         Setup maven"
    echo "nginx         Setup nginx"
    echo "OpenResty     Setup OpenResty"
    echo "memcached     Setup memcached"
    echo "redis         Setup redis"
    echo "mysql         Setup MySQL"
    echo "mongodb       Setup MongoDB"
    echo "python        Setup Python 2.7.4"
    echo "rsync         Setup rsync 3.1.0"
    echo "tomcat        Setup tomcat 1.7"
    echo "all           Setup all aboves"
}

## =====================================
## The main process
## =====================================
if [ $# != 0 ]; then
    for arg in $*; do
        case "$arg" in
            jdk)            setup_jdk;;
            nginx)          setup_nginx;;
	    	OpenResty)      setup_openresty;;
            memcached)      setup_memcached;;
	    	redis)	    setup_redis;;
	    	tomcat)	    setup_tomcat;;
	    	mysql)	    setup_mysql;;
            mongodb)        setup_mongodb;;
            python)         setup_python;;
            rsync)          setup_rsync;;
            maven)          setup_maven;;
            all)            setup_all;;
            *)              usage;;
        esac
    done
else
    usage
fi

