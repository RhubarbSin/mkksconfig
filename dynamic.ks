#
# dynamic.ks
#
# Kickstart configuration is dynamically built based on kernel
# arguments; all logic is in mkksconfig bash script.
#

# keep pxelinux from going interactive
lang en_US
keyboard us
timezone --utc America/New_York

# keep anaconda from starting in graphical mode
text

reboot

# custom.ks built in %pre; this must match argument to mkksconfig (if used)
%include /tmp/custom.ks

%pre
#!/bin/sh

# display activity on vt 6
exec < /dev/tty6 > /dev/tty6 2>&1
# switch console to vt 6
chvt 6

# set environment variables based on kernel args
set -- $(cat /proc/cmdline)
for ASSIGNMENT in $*; do
    case "$ASSIGNMENT" in
        *=*) eval export $ASSIGNMENT;;
    esac
done

# make /tmp/custom.ks
MKKSCONFIG="http://10.1.0.1/linux-install/centos/mkksconfig"
wget -O - "$MKKSCONFIG" | bash -s /tmp/custom.ks

SLEEPTIME=10
# C6 installation environment has sleep(1); C5 has it in busybox
sleep "$SLEEPTIME" 2> /dev/null || busybox sleep "$SLEEPTIME"

# switch back to anaconda on vt 1
chvt 1

# remaining kickstart config is in /tmp/custom.ks
