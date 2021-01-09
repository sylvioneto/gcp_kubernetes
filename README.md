# gcp_kubernetes
This project deploys a GKE cluster with Ingress Controller and Prometheus.

## Pre-req
- terraform >=0.14
- helm >=3.4.0
- VPC and [Cloud NAT](https://cloud.google.com/nat/docs/overview) because it is a private cluster

## Deploy

1. Create a bucket to store the terraform state file, e.g spedroza-tf-state
2. Update the `terraform/main.tf` values according to your project.
3. Run terraform to create the project core infrastructure & the GKE cluster.
```
cd terraform
terraform init
terraform plan -out gke.tfplan
terraform apply "gke.tfplan"
```
4. Connect to your cluster and install Ingress Nginx
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 3.19.0 -n nginx -f helm/ingress-nginx.yaml
```
5. Install External Dns
```
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace external-dns
helm upgrade --install external-dns bitnami/external-dns --version 4.5.0 -n external-dns -f helm/external-dns.yaml
```
6. Install for Prometheus Stack
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 12.10.6 -n monitoring -f helm/prometheus.yaml
```

## Uninstall
Run the commands below.
```
$ helm del kube-prometheus-stack -n monitoring
$ helm del ingress-nginx -n nginx
$ cd gke; terraform init; terraform destroy
```
