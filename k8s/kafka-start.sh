export KUBECONFIG=../../../kubeconfig
aws eks --region eu-central-1 update-kubeconfig --name food-ordering-cluster
helm install gke-confluent-kafka confluentinc/cp-helm-charts  --version 0.6.0
kubectl apply -f kafka-client.yml
export KUBECONFIG=../../../kubeconfig
kubectl cp create-topics.sh kafka-client:/kafka-client-storage
kubectl exec -it kafka-client -- /bin/bash
cd ../..
cd kafka-client-storage
sh create-topics.sh gke-confluent-kafka-cp-zookeeper-headless
kubectl apply -f postgres-deployment.yml
kubectl apply -f application-deployment.yml


# Run Load Test (New Terminal)
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://app3-nginx-cip-service; done"