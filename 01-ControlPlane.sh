# CONTROL PLANE
ssh k8s-c1-cp1.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk

# NODES
ssh k8s-c1-node1.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk
ssh k8s-c1-node2.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk
ssh k8s-c1-node3.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk

# FOR EACH VM (CP & nodes)

# CONTAINERD
swapoff -a
vi /etc/fstab

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-ne-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

sudo apt update
sudo apt install -y containerd

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd

# KUBERNETES
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF'

sudo apt update
apt-cache policy kubelet | head -n 20

VERSION=1.20.1-00
sudo apt install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION
sudo apt-mark hold kubelet kubeadm kubectl containerd

sudo systemctl status kubelet.service
sudo systemctl status containerd.service

sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service

# Creating the CLUSTER

# LAUNCH ONLY ON CONTROL PLANE
wget https://docs.projectcalico.org/manifests/calico.yaml
vi calico.yaml

kubeadm config print init-defaults | tee ClusterConfiguration.yaml
sed -i 's/advertiseAddress: 1.2.3.4/advertiseAddress: 10.0.0.4/' ClusterConfiguration.yaml
sed -i 's/criSocket: \/var\/run\/dockershim\.sock/criSocket: \/run\/containerd\/containerd\/.sock/' ClusterConfiguration.yaml

cat <<EOF | cat >> ClusterConfiguration.yaml
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF

vi ClusterConfiguration.yaml

sudo kubeadm init \
    --config=ClusterConfiguration.yaml \
    --cri-socket /run/containerd/containerd.sock

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f calico.yaml

kubectl get pods --all-namespaces --watch

kubectl get nodes

sudo systemctl status kubelet.service

ll /etc/kubernetes/manifests

sudo more /etc/kubernetes/manifests/etcd.yaml
sudo more /etc/kubernetes/manifests/kube-apiserver.yaml

ll /etc/kubernetes