node='cp1'

# NODES
ssh k8s-c1-$($node).westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk
# for Linux
ssh k8s-c1-$($node).westeurope.cloudapp.azure.com

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

# exit node in order to add node to control plane
exit

ssh k8s-c1-cp1.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk

kubeadm token list
kubeadm token create

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

kubeadm token create --print-join-command

exit

ssh k8s-c1-node1.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk

sudo kubeadm join 10.0.0.4:6443 \
    --token yg3azo.3ea41ouo5c052z0n \
    --discovery-token-ca-cert-hash sha256:6122573cf8b3af9031b06dfe781229db58e812abcbc6a07b92396427b00d408e

ssh k8s-c1-cp1.westeurope.cloudapp.azure.com -i /C/Users/mlemarec/OneDrive\ -\ SYMTRAX/.ssh/k8s/k8s_c1-cp1.ppk

kubectl get nodes

kubectl get pods --all-namespaces --watch