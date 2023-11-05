!/bin/bash

# Define the cluster name
CLUSTER_NAME="k8s-cluster"

# Create a Kind cluster
kind create cluster --name $CLUSTER_NAME --config cluster-config.yaml

#validate if cluster is up
kubectl cluster-info --context kind-$CLUSTER_NAME

# Set the kubeconfig context to the Kind cluster
kubectl config use-context kind-$CLUSTER_NAME

#Install the manifests
kubectl apply -k base/.

# Add the Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

#create prometheus namespace
kubectl create namespace prometheus && helm install prometheus prometheus-community/prometheus -n prometheus

# Add the Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts

#create grafana namespace
kubectl create namespace grafana && helm install grafana stable/grafana -n grafana


# Get the Grafana admin password
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Print instructions to port-forward Grafana to access the dashboard
echo "To access Grafana, run the following command:"
kubectl port-forward  --namespace prometheus svc/prometheus-server 9090:9090
kubectl port-forward --namespace default svc/grafana 3000:3000

