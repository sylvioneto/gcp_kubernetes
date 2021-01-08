# gcp_kubernetes
This project deploys a GKE cluster with Ingress Controller and Prometheus.

## Pre-req
- terraform >=0.14
- helm >=3.4.0
- VPC and [Cloud NAT](https://cloud.google.com/nat/docs/overview) because it is a private cluster

## Deploy

1. Create a bucket to store the terraform state file, e.g spedroza-tf-state
2. Update the `gke/main.tf` values according to your project.
3. Run terraform to create the project core infrastructure & the GKE cluster.
```
cd gke
terraform init
terraform plan -out gke.tfplan
terraform apply "gke.tfplan"
```
4. Connect to your cluster and install Ingress Nginx
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n nginx -f ingress/values.yaml
```
5. Install for Prometheus Stack
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f monitoring/prometheus.yaml
```

## Uninstall
Run the commands below.
```
$ helm del kube-prometheus-stack -n monitoring
$ helm del ingress-nginx -n nginx
$ cd gke; terraform init; terraform destroy
```