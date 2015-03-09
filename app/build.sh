#!/bin/bash

tarFileName='ruy-page.tar'

rm -rf build
rm $tarFileName

mkdir build

grunt precompile
jade views/home/index.jade --out ./build/ --pretty

cp -r public/* build/

tar czf $tarFileName ./build