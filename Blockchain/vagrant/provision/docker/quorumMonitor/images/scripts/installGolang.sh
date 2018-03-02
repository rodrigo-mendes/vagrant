#!/bin/bash

set -e

GOREL="go1.8.linux-amd64.tar.gz"

#INSTALACION DE GO
#PATH="$PATH:/usr/local/go/bin"
echo "Installing GO"
wget -q "https://storage.googleapis.com/golang/${GOREL}"
tar -xvzf "${GOREL}"
mv go /usr/local/go
export GOPATH=~/go
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

echo "[*] GOROOT = $GOROOT, GOPATH = $GOPATH"

echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=~/go' >> $HOME/.bashrc
echo 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >> $HOME/.bashrc

rm "${GOREL}"

set +e