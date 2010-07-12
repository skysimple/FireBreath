#!/bin/bash

GEN='Xcode'

if [ "$1" = "examples" ]; then
    echo Building example projects
    BUILDDIR=buildex
    EXAMPLES='-DBUILD_EXAMPLES:BOOL=YES'
else
    echo Building projects
    BUILDDIR=build
fi

mkdir -p "$BUILDDIR"
pushd "$BUILDDIR"
cmake -G "$GEN" "$EXAMPLES" ..
popd

if [ -f "cmake/patch_xcode.py" ]; then
    while read target proj
    do
        python cmake/patch_xcode.py -f "$proj" -t "$target"
    done < $BUILDDIR/xcode_patch_desc.txt
fi
