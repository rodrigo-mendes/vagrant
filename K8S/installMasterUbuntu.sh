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
#export no_proxy="172.16.78.{0..255}, 10.{1..255}.{0..255}.{0..255}"

echo "INIT - Custom commands"
wget https://github.com/kubernetes-incubator/cri-tools/archive/v1.0.0-alpha.0.tar.gz
tar -xvf v1.0.0-alpha.0.tar.gz
cd v1.0.0-alpha.0
make
make install
echo "PATH=$PATH:/usr/local/bin" >> /etc/profile
source /etc/profile
echo "END - Custom commands"	  

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

echo 'CREATE CLUSTER'
kubeadm init --apiserver-advertise-address=$IP --pod-network-cidr=10.244.0.0/16 --token=$TOKEN --token-ttl=0

echo 'Change de user to ubuntu'
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown 1000:1000 /home/ubuntu/.kube/config

su - ubuntu

echo 'INSTALL POD NETWORK'
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

echo 'VERIFY POD NETWORK PRESENCE'
kubectl get pods --all-namespaces

echo 'Starting proxy as Background Process'
kubectl proxy &

echo 'Retrieve Secret token for access Kubernetes-dashboard '
kubectl get secret --namespace=kube-system  kubernetes-dashboard-token-bdmmw > /vagrant/dashboard-token-access
