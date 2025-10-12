#!/bin/bash

DOS_DIR="~/asm"
cp TASM.exe TD.exe TLINK.exe make.bat make_com.bat $1
dosbox -c "mount d $DOS_DIR/$1" -c "d:" -c "make $2" -exit
cd $1
rm TASM.exe TD.exe TLINK.exe make.bat make_com.bat
cd ..
