#!/bin/bash

################ Script Info ################		

## Program: SSH Trust V1.0
## Author:  Clumart.G(翅儿学飞)
## Date:    2014-03-20
## Update:  2014032100 None

################ Env Define ################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/sbin
LANG=C
export PATH
export LANG

################ Var Setting ################

InputVar=$*
HomeDir="/tmp/sshtrust/"
serveruser="root"
serverpasswd="Password"
sshport="22"
ipc="192.168.1"
ipd=`echo {2..254}`

################ Func Define ################ 
function _info_msg() {
_header
echo -e " |                                                                |"
echo -e " |                Thank you for use this script!                  |"
echo -e " |                                                                |"
echo -e " |                         Version: 1.0                           |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(Clumart.G)                   |"
echo -e " |                    Email:myregs6@gmail.com                     |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
echo -e " |          Hit [ENTER] to continue or ctrl+c to exit             |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"	
 read entcs 
clear
}

function _end_msg() {
echo -e "###################################################################"
echo ""
echo -e "                         Install Finish :)"
echo ""
echo -e "###################################################################"
echo ""
echo ""
_header
echo -e " |                                                                |"
echo -e " |                 Thank you for use this script!                 |"
echo -e " |                                                                |"
echo -e " |                The software has been installed!                |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(Clumart.G)                   |"
echo -e " |                    Email:myregs6@gmail.com                     |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"
}

function _header() {
	printf " o----------------------------------------------------------------o\n"
	printf " | :: SSH Trust                               v1.0.0 (2014/03/19) |\n"
	printf " o----------------------------------------------------------------o\n"	
}

function _error_exit() {
    cd
    rm -rf ${HomeDir}
    clear
    printf " o----------------------------------------------------------------o\n"
    printf " | :: Error                                   v1.0.0 (2014-03-19) |\n"
    printf " o----------------------------------------------------------------o\n"        
    printf " Error Message:$1 \n"
    exit 1
}

##User Function Define Here

################ Main ################
clear
_info_msg

if [ ! -d $HomeDir ]; then
	mkdir -p $HomeDir
fi

#cd $HomeDir || _error_exit "Enter ${HomeDir} Faild."

for i in ${ipd} ; do

    ip=${ipc}"."${i}

    sed -i "/^${ip}/d" ~/.ssh/known_hosts

    ./trust_root.sh ${ip} ${serverpasswd} ${sshport} &

    sleep 1

    ./trust_user.sh ${ip} ${serverpasswd} ${sshport}
    
    scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p${sshport} ./sshd_config ${serveruser}@${ip}:/etc/ssh/
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p${sshport} ${serveruser}@${ip} "/etc/init.d/sshd restart"
    
done

############  Clean Cache  ############
cd
rm -rf ${HomeDir}
_end_msg
