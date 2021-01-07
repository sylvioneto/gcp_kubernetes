# gcp_kubernetes
This project deploys a GKE cluster with Ingress Controller


## Terraform
cd gke
terraform init
terraform plan -out tfplan
terraform apply dev.tfplan

## Ingress Installation
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n nginx -f ./ingress/values.yaml 
