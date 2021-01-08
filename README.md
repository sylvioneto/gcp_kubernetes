# gcp_kubernetes
This project deploys a GKE cluster with Ingress Controller

## Pre-req
- terraform >=0.14
- helm >=3.4.0
- VPC and [Cloud NAT](https://cloud.google.com/nat/docs/overview) because it is a private cluster

## Terraform
cd gke
terraform init
terraform plan -out dev.tfplan
terraform apply "dev.tfplan"


## Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n nginx -f ingress/values.yaml


## kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f monitoring/prometheus.yaml


## Uninstall
helm del kube-prometheus-stack -n monitoring
helm del ingress-nginx -n nginx
terraform destroy
