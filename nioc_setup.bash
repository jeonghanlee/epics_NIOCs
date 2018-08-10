#!/bin/bash
#
#  Copyright (c) 2017 -2018 Jeong Han Lee
#  Copyright (c) 2018  European Spallation Source ERIC
# 
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Friday, August 10 16:48:39 CEST 2018
# version : 0.0.3

# All technical information one can find the following site:
# https://wiki-ext.aps.anl.gov/epics/index.php/How_to_Make_Channel_Access_Reach_Multiple_Soft_IOCs_on_a_Linux_Host


declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME=${0##*/}
declare -gr SC_TOP="${SC_SCRIPT%/*}"

declare -gr SUDO_CMD="sudo";


declare -gr NIOC_SCRIPT="epicsNIOCs"

declare -gr NIOC_TMP_PATH=".tmp/"


function create_debian_script
{
    printf "#\n"
    printf "Creating %s for Debian System\n" "${NIOC_SCRIPT}"
    printf "#\n"

    cat > ${NIOC_TMP_PATH}/${NIOC_SCRIPT} << 'EOL'
#!/bin/sh -e
# Called when an interface goes up / down
#
# Author: Ralph Lange <Ralph.Lange@gmx.de>
#       : Jeong Han Lee <jeonghan.lee@gmail.com>
#
# Make any incoming Channel Access name resolution queries go to the broadcast address
# (to hit all IOCs on this host)

# Change this if you run CA on a non-standard port
PORT=5064

[ "$METHOD" != "none" ] || exit 0
[ "$IFACE" != "lo" ] || exit 0

line=`ip addr show $IFACE`
addr=`echo $line | grep -Po 'inet \K[\d.]+'`
bcast=`echo $line |  grep -Po 'brd \K[\d.]+'`

[ -z "$addr" -o -z "$bcast" ] && return 1

if [ "$MODE" = "start" ]
then
    iptables -t nat -A PREROUTING -d $addr -p udp --dport $PORT -j DNAT --to-destination $bcast
elif [ "$MODE" = "stop" ]
then
    iptables -t nat -D PREROUTING -d $addr -p udp --dport $PORT -j DNAT --to-destination $bcast
fi

exit 0
EOL

}


function create_centos_script
{
    printf "#\n"
    printf "Creating %s for CentOS System\n", "${NIOC_SCRIPT}"
    printf "#\n"
    cat > ${NIOC_TMP_PATH}${NIOC_SCRIPT}  <<'EOL'

#!/bin/sh -e
# Called when an interface goes up / down

# Author: Ralph Lange <Ralph.Lange@gmx.de>
#       : Jeong Han Lee <jeonghan.lee@gmail.com>
# Make any incoming Channel Access name resolution queries go to the broadcast address
# (to hit all IOCs on this host)

# Change this if you run CA on a non-standard port
PORT=5064

IFACE=$1
MODE=$2

[ "$IFACE" != "lo" ] || exit 0

line=`/sbin/ip addr show $IFACE`
addr=`echo $line | grep -Po 'inet \K[\d.]+'`
bcast=`echo $line |  grep -Po 'brd \K[\d.]+'`

[ -z "$addr" -o -z "$bcast" ] && return 1

if [ "$MODE" = "up" ]
then
    /sbin/iptables -t nat -A PREROUTING -d $addr -p udp --dport $PORT -j DNAT --to-destination $bcast
elif [ "$MODE" = "down" ]
then
    /sbin/iptables -t nat -D PREROUTING -d $addr -p udp --dport $PORT -j DNAT --to-destination $bcast
fi

exit 0
EOL

}



function find_dist
{

    local dist_id dist_cn dist_rs PRETTY_NAME
    
    if [[ -f /usr/bin/lsb_release ]] ; then
     	dist_id=$(lsb_release -is)
     	dist_cn=$(lsb_release -cs)
     	dist_rs=$(lsb_release -rs)
     	echo $dist_id ${dist_cn} ${dist_rs}
    else
     	eval $(cat /etc/os-release | grep -E "^(PRETTY_NAME)=")
	echo ${PRETTY_NAME}
    fi

 
}


function setup_nioc
{
    
   
    if ! [ -z "${debian}" ]; then
	create_debian_script

	# 
	# On Debian 8/9, 01ifupdown in /etc/NetworkManager/dispatcher.d will execute
	# files in /etc/network/if-up.d and /etc/network/if-post-down.d
	# through systemctl start NetworkManager if one uses NetworkManager
	# 
	local TARGET1=/etc/network/if-up.d/
	local TARGET2=/etc/network/if-post-down.d/
	
	printf "#\n"
	printf "Installing %s to %s\n" "${NIOC_SCRIPT}" "${TARGET1}"
	${SUDO_CMD} install -m 755 ${SC_TOP}/${NIOC_TMP_PATH}/${NIOC_SCRIPT} ${TARGET1}
	printf "#\n"
	printf "Installing %s to ${TARGET2}\n" "${NIOC_SCRIPT}"
	${SUDO_CMD} install -m 755 ${SC_TOP}/${NIOC_TMP_PATH}/${NIOC_SCRIPT} ${TARGET2}
	printf "#\n"
	printf "Can you see them in there? >>> \n"
	ls -lta ${TARGET1}${NIOC_SCRIPT}
	ls -lta ${TARGET2}${NIOC_SCRIPT}
    elif ! [ -z "${centos}" ]; then
	create_centos_script
	printf "#\n"
	printf "Installing %s to /etc/NetworkManager/dispatcher.d/\n" "${NIOC_SCRIPT}"
	${SUDO_CMD} install -m 755 ${SC_TOP}/${NIOC_TMP_PATH}/${NIOC_SCRIPT} /etc/NetworkManager/dispatcher.d/
	printf "#\n"
	printf "Can you see them in there? >>> \n"
	ls -lta /etc/NetworkManager/dispatcher.d/${NIOC_SCRIPT}
    else
	printf "\n";
	printf "Doesn't support this case\n";
	printf "Please contact jeonghan.lee@gmail.com\n";
	printf "\n";
	exit;
    fi

     
}


function epics_env
{
    printf "#\n"
    printf "Please check the following EPICS VARIABLES:\n"
    printf "# \n"
    printf "EPICS_CA_AUTO_ADDR_LIST : %s\n" "${EPICS_CA_AUTO_ADDR_LIST}"
    printf "EPICS_CA_ADDR_LIST      : %s\n" "${EPICS_CA_ADDR_LIST}"
    printf "#\n";
    printf "# ---------------------------------------------------\n"
    printf "# \"If you need connections between IOCs on one host,\n"
    printf "#  please add the broadcast address of the loopback  \n"
    printf "#  interface (usually 127.255.255.255) to each IOC's \n";
    printf "#  EPICS_CA_ADDR_LIST\"                         Ralph\n";
    printf "# ---------------------------------------------------\n"



    
}

debian=""
centos=""

## Determine CentOS or Debian, because systemd path is different

dist=$(find_dist)

case "$dist" in
    *Debian*)
	debian="1"
	;;
    *CentOS*)
	centos="1"
	;;
    *)
	printf "\n";
	printf "Doesn't support the detected $dist\n";
	printf "Please contact jeonghan.lee@gmail.com\n";
	printf "\n";
	exit;
	;;
esac

${SUDO_CMD} -v

mkdir -p ${SC_TOP}/${NIOC_TMP_PATH}

setup_nioc 

epics_env
