# epics_NIOCs

This envrionment may help users to setup the multiple soft IOCs on a Linux Host. The information comes from *How to Make Channel Access Reach Multiple Soft IOCs on a Linux Host* [1]. However, the reference [1] is incorrect to get ip address and broadcast within scripts. Here I update it in order to use the morden Linux network command line tools, i.e., ip. The new EPICS web site [3] has the up-to-date information. 


## Target OSs

* Debian 8/9
* CentOS 7.5


## Without ReStart NetworkManager

```sh
niocs (master)$ bash nioc_setup.bash 
#
Creating epicsNIOCs for Debian System
#
#
Installing epicsNIOCs to /etc/network/if-up.d/
#
Installing epicsNIOCs to /etc/network/if-post-down.d/
#
Can you see them in there? >>> 
-rwxr-xr-x 1 root root 826 Aug 13 23:27 /etc/network/if-up.d/epicsNIOCs
-rwxr-xr-x 1 root root 826 Aug 13 23:27 /etc/network/if-post-down.d/epicsNIOCs

>>>> NetworkManager will be restarted.
>>>> Do you want to continue (y/n)? n
#
One should restart NetworkManager later.
sudo systemctrl restart NetworkManager
#
#
Please check the following EPICS VARIABLES:
# 
EPICS_CA_AUTO_ADDR_LIST : xxx
EPICS_CA_ADDR_LIST      : x.x.x.x x.x.x.x
#
# ---------------------------------------------------
# "If you need connections between IOCs on one host,
#  please add the broadcast address of the loopback  
#  interface (usually 127.255.255.255) to each IOC's 
#  EPICS_CA_ADDR_LIST"                         Ralph
# ---------------------------------------------------

```

## With Restart NetworkManager

```sh
niocs (master)$ bash nioc_setup.bash 
#
Creating epicsNIOCs for Debian System
#
#
Installing epicsNIOCs to /etc/network/if-up.d/
#
Installing epicsNIOCs to /etc/network/if-post-down.d/
#
Can you see them in there? >>> 
-rwxr-xr-x 1 root root 826 Aug 13 23:29 /etc/network/if-up.d/epicsNIOCs
-rwxr-xr-x 1 root root 826 Aug 13 23:29 /etc/network/if-post-down.d/epicsNIOCs

>>>> NetworkManager will be restarted.
>>>> Do you want to continue (y/n)? y
#
NetworkManager is restarting .... 
#
● NetworkManager.service - Network Manager
   Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2018-08-13 23:29:19 CEST; 21ms ago
     Docs: man:NetworkManager(8)
 Main PID: 7374 (NetworkManager)
    Tasks: 4 (limit: 4915)
   CGroup: /system.slice/NetworkManager.service
           └─7374 /usr/sbin/NetworkManager --no-daemon

.....
Hint: Some lines were ellipsized, use -l to show in full.
#
Please check the following EPICS VARIABLES:
# 
EPICS_CA_AUTO_ADDR_LIST : xxx
EPICS_CA_ADDR_LIST      : x.x.x.x x.x.x.x
#
# ---------------------------------------------------
# "If you need connections between IOCs on one host,
#  please add the broadcast address of the loopback  
#  interface (usually 127.255.255.255) to each IOC's 
#  EPICS_CA_ADDR_LIST"                         Ralph
# ---------------------------------------------------


```

## Manual Setup

Please look at scripts directory, drop it into a proper directory.
* Debian : epicsNIOCs_Debian
* CentOS : epicsNIOCs_CentOS

## Note

If one calls *caget* or *camonnitor* with multiple PVs exist in multiple IOCs, each IOC may return the following message:

```sh
CAS: UDP send to x.x.x.x:44648 failed - Operation not permitted

```
The detailed discussion one can find in Issue #1 [2].

## References

[1] https://wiki-ext.aps.anl.gov/epics/index.php/How_to_Make_Channel_Access_Reach_Multiple_Soft_IOCs_on_a_Linux_Host      
[2] https://github.com/jeonghanlee/epics_NIOCs/issues/1   
[3] https://epics-controls.org/resources-and-support/documents/howto-documents/channel-access-reach-multiple-soft-iocs-linux/
