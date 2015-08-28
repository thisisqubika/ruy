#!/bin/bash

rm -rf build/*

grunt precompile
./node_modules/jade/bin/jade.js views/home/index.jade --out ./build/ --pretty

cp -r public/* build/

rm -rf ../dist ../fonts ../images ../index.html

cp -r build/* ../
