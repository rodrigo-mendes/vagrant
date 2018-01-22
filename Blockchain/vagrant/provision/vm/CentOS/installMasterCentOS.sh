#!/bin/bash

IP=$1
TOKEN=$2

##echo "Config Proxy"
#export HTTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
#export HTTPS_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
#export FTP_PROXY=http://rmendess:Banshee1981@10.0.8.102:8080
#export http_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
#export https_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
#export ftp_proxy=http://rmendess:Banshee1981@10.0.8.102:8080
#export no_proxy="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"
#export NO_PROXY="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"


echo 'INSTALL DOCKER'

#cat << EOF > /etc/docker/daemon.json
#{
#  "exec-opts": ["native.cgroupdriver=systemd"]
#}
#EOF
yum install -y docker 
systemctl enable docker && systemctl start docker

#cat <<EOF | tee -a /etc/sysconfig/docker
#http_proxy="http://rmendess:Banshee1981@10.0.8.102:8080"
#https_proxy="http://rmendess:Banshee1981@10.0.8.102:8080"
#no_proxy="127.0.0.1, 172.16.78.{0..255}, 10.{0..255}.{0..255}.{0..255}"
#EOF
# 
#sed -i '/\[Service\]/a EnvironmentFile=/etc/sysconfig/docker' /usr/lib/systemd/system/docker.service
# systemctl daemon-reload
#service docker restart

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

echo 'CREATE CLUSTER'
# INIT - Fora documentação
echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf
sysctl -p
systemctl stop firewalld
systemctl disable firewalld
swapoff -a
#Para ter o netstat instalado.
yum install -y net-tools
# END - Fora documentação

kubeadm init --apiserver-advertise-address=$IP --pod-network-cidr=10.244.0.0/16 --token=$TOKEN --token-ttl=0

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 1000:1000 /home/vagrant/.kube/config

echo 'INSTALL POD NETWORK'
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

echo 'INSTALL POD DASHBOARD'
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

echo 'VERIFY POD NETWORK PRESENCE'
kubectl --kubeconfig=/etc/kubernetes/admin.conf get pods --all-namespaces

echo 'Starting proxy as Background Process'
#kubectl --kubeconfig=/etc/kubernetes/admin.conf proxy &

echo 'Retrieve Secret token for access Kubernetes-dashboard '
#kubectl --kubeconfig=/etc/kubernetes/admin.conf get secret --namespace=kube-system  kubernetes-dashboard-token-nzllk --output=json

#kubectl -n kube-system describe secret kubernetes-dashboard-token-nzllk