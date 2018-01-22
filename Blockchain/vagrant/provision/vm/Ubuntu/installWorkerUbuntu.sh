#!/bin/sh

IP=$1
TOKEN=$2

#echo "Config Proxy"
#export HTTP_PROXY=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export HTTPS_PROXY=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export FTP_PROXY=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export http_proxy=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export https_proxy=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export ftp_proxy=http://rmendess:Ban$#ee1981@10.0.8.102:8080
#export no_proxy="172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"

echo 'INSTALL DOCKER'
apt-get update
apt-get install -y docker.io
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF


echo 'INSTALL KUBERNETES'
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo 'LINUX UPDATE'
apt-get update && apt-get upgrade

kubeadm join --token=$TOKEN $IP:6443 --discovery-token-unsafe-skip-ca-verification