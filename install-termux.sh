#!/bin/bash

prefix="/data/data/com.termux/files/usr"
lib="$prefix/lib/fster"
bin="$prefix/bin"

cp *.lua bin/
rm bin/Fster.lua

if [ ! -d $lib ]; then
  sudo mkdir $lib/
fi

sudo cp ./bin/fster_lib $lib/
sudo cp ./bin/*.lua $lib/

if [ -d "$bin/fster" ]; then
  sudo rm "$bin/fster"
fi

sudo bash -c "echo \"#!/bin/bash
previous=\\\`/bin/pwd\\\`
cd $lib/
lua $lib/fster_lib \\\$@
cd \\\$previous
\" > $bin/fster"

sudo chmod +x /bin/fster
