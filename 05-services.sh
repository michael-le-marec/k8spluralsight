ssh k8s-c1-cp1.westeurope.cloudapp.azure.com -i ~/.ssh/k8s_c1-cp1.ppk

kubectl expose deployment hello-world \
    --port=80 \
    --target-port=8080

kubectl get service hello-world

kubectl describe service hello-world

curl http://10.110.125.68:80

kubectl get deploy hello-world -o yaml | less
kubectl get deploy hello-world -o json | less

kubectl get all
kubectl delete service hello-world
kubectl delete deploy hello-world
kubectl delete pod hello-world-pod
kubectl get all

kubectl create deploy hello-world \
    --image=gcr.io/google-samples/hello-app:1.0 \
    --dry-run=client -o yaml > deployment.yaml

kubectl apply -f deployment.yaml

kubectl expose deploy hello-world \
    --port=80 --target-port=8080 \
    --dry-run=client -o yaml > service.yaml

kubectl apply -f service.yaml

kubectl get all

vi deployment.yaml
# change spec.replicas from 1 to 20

kubectl get deploy hello-world
kubectl get pods | less

kubectl get service hello-world
curl http://10.103.247.195

kubectl edit deploy hello-world
# change spec.replicas from 20 to 30

kubectl get deploy hello-world

kubectl scale deploy hello-world --replicas=20 

kubectl delete deploy hello-world
kubectl delete service hello-world
kubectl get all