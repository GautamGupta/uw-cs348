#!/usr/bin/env bash
# Author: Dave Pagurek (https://gist.github.com/davepagurek/2504674142c1698f5ae5e9d76466f034)

# echo rlwrap
cd ~
git clone https://github.com/hanslub42/rlwrap.git
cd rlwrap
autoreconf --install
./configure --prefix=$HOME
make
make install

# add bash shortcuts
echo 'export PATH="$PATH:~/bin"' >> ~/.bashrc
echo 'alias db2c="rlwrap db2"' >> ~/.bashrc
source ~/.bashrc
