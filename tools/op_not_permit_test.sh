pv1="IOC1:Test:IocStats:HEARTBEAT"
pv2="IOC2:Test:IocStats:HEARTBEAT"
pv3="IOC3:Test:IocStats:HEARTBEAT"


caget_all() {
    caget $pv1
    caget $pv2
    caget $pv3
}


# caget_all() {
#     caget $pv1 $pv2 $pv3
# }

cam_all() {
    camonitor $pv1 $pv2 $pv3
}

while true;
do {
    caget_all
}
done
	  
#sleep 2
#caget_all
#sleep 2



