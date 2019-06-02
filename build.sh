#!/bin/bash

name=target-spy

rm -f $name.pk3 \
&& \
git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt \
&& \
zip $name.pk3        \
    graphics/*.lmp   \
    graphics/*.png   \
    graphics/*/*.png \
    *.zs             \
    zscript/*.zs     \
    zscript/*/*.zs   \
    zscript/*/*.zsc  \
    *.txt  \
    *.md   \
    *.fon2 \
    *.lmp  \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
gzdoom -glversion 3 \
       \ #-iwad ~/Programs/Games/wads/doom/freedoom1.wad \
       \ #-iwad ~/Programs/Games/wads/doom/freedoom2.wad \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test \
       \ #-nomonsters \
       +notarget \
       +summon doomimp
