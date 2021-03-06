PANEL_WORKDIR=/home/web/webroot
PANEL_TMP_HOME=/home/web/soft
PANEL_SHELL_HOME=/home/web/work/myconf/shell


WORKDIR=/root/work
TMP_HOME=/root/soft
SHELL_HOME=/root/work/myconf/shell
#https://doub.io/ss-jc13/
setup_sspanel() 
{
	cd ${PANEL_WORKDIR}
	rm -rf ss-panel
	git clone https://github.com/orvice/ss-panel.git -b master
	cd ss-panel
	curl -sS https://getcomposer.org/installer | php
	php composer.phar  install
	cp ${PANEL_SHELL_HOME}/../ss_panel/env  .env
	php xcat migrate
	chmod -R 777 storage
	
	#cp ${PANEL_SHELL_HOME}/../php/config.php ${PANEL_WORKDIR}/ss-panel/lib
	#mysql -u vpn@server -p -hmysql.sspacee.com vpn < ${PANEL_WORKDIR}/ss-panel/invite_code.sql
	#mysql -u vpn@server -p -hmysql.sspacee.com vpn < ${PANEL_WORKDIR}/ss-panel/ss_node.sql
	#mysql -u vpn@server -p -hmysql.sspacee.com vpn < ${PANEL_WORKDIR}/ss-panel/ss_reset_pwd.sql
	#mysql -u vpn@server -p -hmysql.sspacee.com vpn < ${PANEL_WORKDIR}/ss-panel/ss_user_admin.sql
	#mysql -u vpn@server -p -hmysql.sspacee.com vpn < ${PANEL_WORKDIR}/ss-panel/user.sql
	#echo 'http://hostggg.com/pwd.php?pwd=1993'
}
setup_ssr() 
{
	cd ${WORKDIR}
	#	git clone -b manyuser https://github.com/ToyoDAdoubi/shadowsocksr.git
	
	git clone  https://github.com/themass/shadowsocksr.git
	cd shadowsocksr
	bash setup_cymysql.sh
	bash initcfg.sh
	cp ${SHELL_HOME}/../ssr_conf/* .
}

## -----------------------
## Show help message
## -----------------------
usage() 
{
    echo "Available arguments as below:"
    echo "sspanel           Setup setup_sspanel"
    echo "ssr          Setup setup_ssr"
}

## =====================================
## The main process
## =====================================
if [ $# != 0 ]; then
    for arg in $*; do
        case "$arg" in
            sspanel)            setup_sspanel;;
            ssr)          setup_ssr;;
        esac
    done
else
    usage
fi
