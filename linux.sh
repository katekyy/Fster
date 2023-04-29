#!/bin/bash

lib="/lib/fster/fster_lib"

sudo bash -c "
if [ ! -d \"/lib/fster\" ]; then
  mkdir \"/lib/fster\"
fi
cp ./bin/fster_lib $lib

cat > /bin/fster <<EOM
#!/bin/bash
lua $lib $@
EOM

sudo chmod +x /bin/fster
"
