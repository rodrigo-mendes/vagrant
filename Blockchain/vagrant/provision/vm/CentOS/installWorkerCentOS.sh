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
#export no_proxy="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"

echo 'INSTALL DOCKER'
yum install -y docker

#cat << EOF > /etc/docker/daemon.json
#{
#  "exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
systemctl enable docker && systemctl start docker

echo 'INSTALL KUBERNETES'
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo 'LINUX UPDATE'
yum update -y

echo 'JOIN CLUSTER'
# INIT - Fora documentação
echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf
sysctl -p
systemctl stop firewalld
systemctl disable firewalld
swapoff -a
#Para ter o netstat instalado.
yum install -y net-tools
# END - Fora documentação

#kubeadm join --token=$TOKEN $IP:6443 --discovery-token-unsafe-skip-ca-verification


