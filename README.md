# epics_NIOCs

This envrionment may help users to setup the multiple soft IOCs on a Linux Host. The information comes from *How to Make Channel Access Reach Multiple Soft IOCs on a Linux Host* [1]. Please lookt at Ref.[1] for further detailed information.


## Target OSs

* Debian
* CentOS

##

```sh
epics_NIOCs (master)$ bash nioc_setup.bash
#
Creating epicsNIOCs for Debian System
#
#
Installing epicsNIOCs to /etc/network/if-up.d/
#
Installing epicsNIOCs to /etc/network/if-down.d/
#
Can you see them in there? >>> 
-rwxr-xr-x 1 root root 820 Aug  9 12:37 /etc/network/if-down.d/epicsNIOCs
-rwxr-xr-x 1 root root 820 Aug  9 12:37 /etc/network/if-up.d/epicsNIOCs
#
Please check the following EPICS VARIABLES:
# 
EPICS_CA_AUTO_ADDR_LIST : no
EPICS_CA_ADDR_LIST      : 
#
# ---------------------------------------------------
# "If you need connections between IOCs on one host,
#  please add the broadcast address of the loopback  
#  interface (usually 127.255.255.255) to each IOC's 
#  EPICS_CA_ADDR_LIST"                         Ralph
# ---------------------------------------------------


```

## References

[1] https://wiki-ext.aps.anl.gov/epics/index.php/How_to_Make_Channel_Access_Reach_Multiple_Soft_IOCs_on_a_Linux_Host

