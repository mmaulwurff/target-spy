#!/bin/bash

name=target-spy

acc source/m8f_tspy.acs acs/m8f_tspy.o \
&& \
rm -f $name.pk3 \
&& \
git log --pretty=format:"-%d %ai %s%n" > changelog.txt \
&& \
zip $name.pk3 \
    acs/m8f_tspy.o \
    source/m8f_tspy.acs \
    graphics/*.lmp \
    graphics/*.png \
    *.txt \
    *.md \
    *.fon2 \
    *.lmp \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
gzdoom -glversion 3 \
       \ #-iwad ~/Programs/Games/wads/doom/freedoom2.wad \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" \
       +map test \
       \ #-nomonsters \
       +notarget \
       +summon doomimp
