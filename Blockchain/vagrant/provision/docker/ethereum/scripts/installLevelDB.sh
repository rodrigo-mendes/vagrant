#!/bin/bash

set -e

#LEVELDB FIX
git clone https://github.com/google/leveldb.git
cd leveldb/
make
scp -r out-static/lib* out-shared/lib* /usr/local/lib/
cd include/
scp -r leveldb /usr/local/include/
ldconfig
cd ../..
rm -r leveldb

set +e