#!/bin/bash

lib="/lib/fster/fster_lib"

if [ -n "$1" ] && [ "$1" = "lib_install" ]; then 
  if [ ! -d "/lib/fster" ]; then
    sudo mkdir "/lib/fster"
  fi
  sudo cp ./bin/fster_lib $lib
  sudo chmod +x ./linux.sh
  sudo cp ./linux.sh /bin/fster
  exit 0
fi

lua $lib $@
