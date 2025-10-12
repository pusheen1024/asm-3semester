#!/bin/bash

DOS_DIR="~/asm"
dosbox -c "mount d $DOS_DIR" -c "d:" -c "make $1" -exit
