kubectl cluster-info

kubectl get nodes
kubectl get nodes -o wide

kubectl get pods
kubectl get pods --namespace kube-system
kubectl get pods --namespace kube-system -o wide

kubectl get all --all-namespaces | more

kubectl api-resources | more
kubectl api-resources | grep volume

kubectl get nodes
kubectl get no

kubectl explain pod | more
kubectl explain pod.spec | more
kubectl explain pod.spec.containers | more
kubectl explain pod --recursive | more

kubectl describe nodes c1-cp1 | more
kubectl describe nodes c1-node1 | more

kubectl -h
kubectl get -h | more
kubectl create -h | more

# AUTO-COMPLETION
sudo apt install -y bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
