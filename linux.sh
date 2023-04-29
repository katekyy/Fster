#!/bin/bash

lib="/lib/fster/fster_lib"

if [ ! -d "/lib/fster" ]; then
  sudo mkdir "/lib/fster"
fi

sudo cp ./bin/fster_lib $lib

if [ ! -d "/bin/fster" ]; then
  sudo rm /bin/fster
fi

sudo bash -c "echo \"#!/bin/bash
lua $lib \\\$@\" >> /bin/fster"

sudo chmod +x /bin/fster
