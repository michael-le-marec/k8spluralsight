ssh "k8s-c1-cp1.westeurope.cloudapp.azure.com"

kubectl create deploy hello-world --image=gcr.io/google-samples/hello-app:1.0 --replicas=5

ku run hello-world-pod --image=gcr.io/google-samples/hello-app:1.0

kubectl get pods -o wide

ssh "k8s-c1-node2.westeurope.cloudapp.azure.com"

sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps

exit

kubectl logs hello-world-pod

kubectl exec -it hello-world-pod -- /bin/sh
hostname
ip addr
exit

kubectl get deploy hello-world
kubectl get replicaset

kubectl describe deploy hello-world | more
kubectl describe replicaset hello-world | more

kubectl describe pod hello-world-[TAB]-[TAB]

