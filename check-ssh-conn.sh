
# _LADDR="19"
_LADDR="22"

for i in `seq 1 5`
do

    nc -vz 192.168.2.$_LADDR$i 22
    # ssh-keyscan 192.168.2.$_LADDR$i
    ssh-keyscan 192.168.2.19$_LADDR >/dev/null 2>&1

done

