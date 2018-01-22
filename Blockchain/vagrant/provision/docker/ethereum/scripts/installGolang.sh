#!/bin/bash

set -e

GOREL="go1.7.3.linux-amd64.tar.gz"

#INSTALACION DE GO
PATH="$PATH:/usr/local/go/bin"
echo "Installing GO"
wget -q "https://storage.googleapis.com/golang/${GOREL}"
tar -xvzf "${GOREL}"
mv go /usr/local/go
rm "${GOREL}"

set +e