#!/bin/bash

acc source/m8f_tspy.acs acs/m8f_tspy.o \
&& \
rm -f target-spy.pk3 \
&& \
git log --pretty=format:"-%d %ai %s%n" > changelog.txt \
&& \
zip target-spy.pk3 \
    acs/m8f_tspy.o \
    source/m8f_tspy.acs \
    cvarinfo.txt \
    loadacs.txt \
    menudef.txt \
    zscript.txt \
    README.txt \
    changelog.txt \
    MM2SFNTO.fon2 \
&& \
gzdoom -glversion 3 \
       \ #-iwad ~/Programs/Games/wads/doom/freedoom2.wad \
       -file \
       target-spy.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" \
       +map test \
       \ #-nomonsters \
       +notarget
