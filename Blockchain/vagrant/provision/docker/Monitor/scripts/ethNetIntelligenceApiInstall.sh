#!/bin/bash


cd ~

[ ! -d "bin" ] && mkdir bin
[ ! -d "logs" ] && mkdir logs

# update packages
apt-get update -y
apt-get upgrade -y
apt-get install -y software-properties-common

# add ethereum repos
#sudo add-apt-repository -y ppa:ethereum/ethereum
#sudo add-apt-repository -y ppa:ethereum/ethereum-dev
#sudo apt-get update -y

# install ethereum & install dependencies
#sudo apt-get install -y build-essential git unzip wget nodejs npm ntp cloud-utils $ethtype
apt-get install -y build-essential git unzip wget nodejs npm ntp cloud-utils

# add node symlink if it doesn't exist
[[ ! -f /usr/bin/node ]] && ln -s /usr/bin/nodejs /usr/bin/node

# set up time update cronjob
bash -c "cat > /etc/cron.hourly/ntpdate << EOF
#!/bin/sh
pm2 flush
service ntp stop
ntpdate -s ntp.ubuntu.com
service ntp start
EOF"

chmod 755 /etc/cron.hourly/ntpdate

# add node service
cd ~/bin

[ ! -d "www" ] && git clone https://github.com/cubedro/eth-net-intelligence-api www
cd www
git pull

[[ ! -f ~/bin/processes.json ]] && cp -b ./processes-ec2.json ./../processes.json

npm install
npm install pm2 -g