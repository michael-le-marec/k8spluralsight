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

