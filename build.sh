#!/bin/bash

set -e

name=target-spy

rm -f $name.pk3

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt

zip -R $name.pk3 \
    "*.lmp" \
    "*.png" \
    "*.txt" \
    "*.zs"  \
    "*.md"  \
    "*.fon2"

cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3

gzdoom -file $name.pk3 +notarget +summon doomimp "$@"
