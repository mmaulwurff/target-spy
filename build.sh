#!/bin/bash

acc source/m8f_tspy.acs acs/m8f_tspy.o \
&& \
rm -f target-spy.pk3 \
&& \
zip target-spy.pk3 \
    acs/m8f_tspy.o \
    source/m8f_tspy.acs \
    cvarinfo.txt \
    loadacs.txt \
    menudef.txt \
    zscript.txt \
    README.txt \
&& \
gzdoom -glversion 3 -file \
       target-spy.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" \
       +map test \
       -nomonsters \
       +notarget
