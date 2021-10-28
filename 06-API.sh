ssh k8s-c1-cp1.westeurope.cloudapp.azure.com -i ~/.ssh/k8s_c1-cp1.ppk

kubectl config get-contexts

kubectl config use-context kubernetes-admin@kubernetes

kubectl cluster-info

kubectl api-resources | less

kubectl explain pods | less

kubectl explain pods.spec | less

kubectl apply -f pod.yaml

kubectl get pods

kubectl delete pod hello-world

kubectl apply -f deployment.yaml --dry-run=server

kubectl get deploy

kubectl apply -f deployment.yaml --dry-run=client

kubectl apply -f deployment-error.yaml --dry-run=client

kubectl create deploy nginx --image=nginx --dry-run=client -o yaml | less

kubectl create deploy nginx --image=nginx --dry-run=client -o yaml > deployment-generated.yaml

kubectl apply -f deployment-generated.yaml

kubectl delete -f deployment-generated.yaml

# ***** DIFF *****

kubectl apply -f deployment.yaml

kubectl diff -f deployment-new.yaml

kubectl delete -f deployment.yaml

# ***** API GROUPS *****

kubectl api-resources | less

kubectl api-resources --api-group=apps

kubectl explain deployment --api-version apps/v1 | less

kubectl api-versions | sort | less

# ***** ANATOMY OF AN API REQUEST *****

kubectl apply -f pod.yaml
kubectl get pod hello-world

# add verbosity
kubectl get pod hello-world -v 6
kubectl get pod hello-world -v 7
kubectl get pod hello-world -v 8
kubectl get pod hello-world -v 9

kubectl proxy &
curl http://localhost:8001/api/v1/namespaces/default/pods/hello-world | head -n 20
fg

# Create a permanent watcher
kubectl get pods --watch -v 6 &

netstat -plant | grep kubectl
kubectl delete pods hello-world
kubectl apply -f pod.yaml
fg

kubectl logs hello-world
kubectl logs hello-world -v 6

kubectl proxy &
curl http://localhost:8001/api/v1/namespaces/default/pods/hello-world/log
fg

# Provoke authN error
cp ~/.kube/config ~/.kube/config.ORIGINAL
vi ~/.kube/config
kubectl get pods -v 6

cp ~/.kube/config.ORIGINAL ~/.kube/config
kubectl get pods

kubectl get pods nginx-pod -v 6

kubectl apply -f deployment.yaml -v 6
kubectl get deploy

kubectl delete deploy hello-world -v 6
kubectl delete pod hello-world

kubectl get all -v 6

# MANAGING OBJECTS WITH LABELS, ANNOTATIONS AND NAMESPACES

kubectl get namespaces

kubectl api-resources --namespaced=true | head
kubectl api-resources --namespaced=false | head

kubectl describe namespaces

kubectl describe namespaces kube-system

kubectl get pods --all-namespaces

kubectl get all --all-namespaces

kubectl get pods --namespace kube-system

kubectl create namespace playground1

kubectl create namespace Playground1 # only low case

kubectl apply -f deployment-namespace.yaml

kubectl run hello-world-pod \
    --image=gcr.io/google-samples/hello-app:1.0 \
    --generator=run-pod/v1 \
    --namespace playground1

kubectl get pods --namespace playground1
kubectl get pods -n playground1

kubectl get all -n playground1

# Operations on resources in a namespace

kubectl delete pods --all -n Playground1

kubectl delete namespaces playground1
kubectl delete namespaces playgroundinyaml --wait=false

kubectl get all --all-namespaces

# Working with Labels

kubectl apply -f podswithlabels.yaml

kubectl get pods --show-labels

kubectl describe pod nginx-pod-1 | head

kubectl get pods --selector tier=prod
kubectl get pods --selector tier=qa
kubectl get pods -l tier=prod
kubectl get pods -l tier=prod --show-labels

kubectl get pods -l 'tier=prod,app=MyWebApp' --show-labels
kubectl get pods -l 'tier=prod,app!=MyWebApp' --show-labels
kubectl get pods -l 'tier in (prod,qa)'
kubectl get pods -l 'tier notin (prod,qa)'

kubectl get pods -L tier # Add labels as column
kubectl get pods -L tier,app

kubectl label pod nginx-pod-1 tier=non-prod --overwrite # Change labels of a pod
kubectl get pod nginx-pod-1 --show-labels

kubectl label pod nginx-pod-1 another=Label
kubectl get pod nginx-pod-1 --show-labels

kubectl label pod nginx-pod-1 another- # remove label
kubectl get pod nginx-pod-1 --show-labels

kubectl label pod --all tier=non-prod --overwrite
kubectl get pod --show-labels

kubectl delete pod -l tier=non-prod --wait=false
kubectl get pod --show-labels

# LABELS FOR DEPLOYMENTS AND REPLICASETS

kubectl apply -f deployment-label.yaml

kubectl apply -f service.yaml

kubectl describe deployment hello-world

kubectl describe replicaset hello-world

kubectl get pods --show-labels

kubectl label pod hello-world-54575d5b77-7rk7d pod-template-hash=DEBUG --overwrite # Technique in order to debug a running pod

kubectl get pods --show-labels

kubectl get service

kubectl describe service hello-world

kubectl describe endpoints hello-world

kubectl get pod -o wide --show-labels

kubectl label pod hello-world-54575d5b77-7rk7d app=DEBUG --overwrite

kubectl get pod -o wide --show-labels
kubectl describe endpoints hello-world

kubectl delete deploy hello-world --wait=false
kubectl delete service hello-world --wait=false
kubectl delete pod hello-world-54575d5b77-7rk7d

kubectl get nodes --show-labels

kubectl label node c1-node2 disk=local_ssd
kubectl label node c1-node3 hardware=local_gpu

kubectl get node -L disk,hardware

kubectl apply -f podtonodes.yaml

kubectl get node -L disk,hardware
kubectl get pods -o wide

kubectl label node c1-node2 disk-
kubectl label node c1-node3 hardware-
kubectl delete pod nginx-pod --wait=false
kubectl delete pod nginx-pod-gpu --wait=false
kubectl delete pod nginx-pod-ssd --wait=false