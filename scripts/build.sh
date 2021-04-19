#!/bin/bash

set -e

mkdir -p build

name=build/target-spy-$(git describe --abbrev=0 --tags).pk3

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt

rm  -f "$name"
zip -R "$name" \
    "*.lmp" \
    "*.png" \
    "*.txt" \
    "*.zs"  \
    "*.md"  \
    "*.fon2"

gzdoom -file "$name" "$@"
