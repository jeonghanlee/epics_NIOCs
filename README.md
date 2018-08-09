# epics_NIOCs

This envrionment may help users to setup the multiple soft IOCs on a Linux Host. The information comes from *How to Make Channel Access Reach Multiple Soft IOCs on a Linux Host* [1]. Please lookt at Ref.[1] for further detailed information. 


## Target OSs

* Debian
* CentOS

##

```sh
epics_NIOCS (master)$ bash nioc_setup.bash 
#
Creating epicsNIOCs for Debian System
#
#
Installing epicsNIOCs to /etc/network/if-up.d/
#
Installing epicsNIOCs to /etc/network/if-post-down.d/
#
Can you see them in there? >>> 
-rwxr-xr-x 1 root root 826 Aug  9 14:39 /etc/network/if-up.d/epicsNIOCs
-rwxr-xr-x 1 root root 826 Aug  9 14:39 /etc/network/if-post-down.d/epicsNIOCs
#
Please check the following EPICS VARIABLES:
# 
EPICS_CA_AUTO_ADDR_LIST : 
EPICS_CA_ADDR_LIST      : 
#
# ---------------------------------------------------
# "If you need connections between IOCs on one host,
#  please add the broadcast address of the loopback  
#  interface (usually 127.255.255.255) to each IOC's 
#  EPICS_CA_ADDR_LIST"                         Ralph
# ---------------------------------------------------

epics_NIOCS (master)$ sudo systemctl restart NetworkManager
epics_NIOCS (master)$ sudo systemctl status -l NetworkManager

```


## Note

When a client gets a pv, the host IOC will show the following messages:

```sh
CAS: UDP send to 10.0.6.172:44648 failed - Operation not permitted
CAS: UDP send to 10.4.8.12:35674 failed - Operation not permitted
CAS: UDP send to 10.4.8.12:56210 failed - Operation not permitted
CAS: UDP send to 10.4.8.12:57296 failed - Operation not permitted
```


## References

[1] https://wiki-ext.aps.anl.gov/epics/index.php/How_to_Make_Channel_Access_Reach_Multiple_Soft_IOCs_on_a_Linux_Host

