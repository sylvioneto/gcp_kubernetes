# gcp_kubernetes
This project deploys a GKE cluster with Ingress controller, DNS, and Prometheus.

## Pre-req
- terraform >=0.14
- helm >=3.4.0

## Deploy

1. Update the `terraform/main.tf` backend values to save the state in your GCS project.
2. Update the `user_defined.auto.tfvars` with the desired settings.
3. Run terraform to create the project core infrastructure & the GKE cluster.
```
cd terraform
terraform init
terraform plan -out gke.tfplan
terraform apply "gke.tfplan"
```
4. Connect to the cluster and create the namespaces
```
$ kubectl apply -f helm\namespaces.yaml
```
4. Update the `helm/ingress-nginx.yaml` with the new external ip created.
5. Connect to your cluster and install Ingress Nginx
```
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 3.19.0 -n nginx -f helm/ingress-nginx.yaml
```
6. Update the project and domain on  `helm/external-dns.yaml`.
7. Install External Dns
```
helm upgrade --install external-dns bitnami/external-dns --version 4.5.0 -n external-dns -f helm/external-dns.yaml
```
8. Update the domains on `helm/prometheus.yaml`.
9. Install for Prometheus Stack
```
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 12.10.6 -n monitoring -f helm/prometheus.yaml
```

## Uninstall
Run the commands below.
```
$ helm del kube-prometheus-stack -n monitoring
$ helm del ingress-nginx -n nginx
$ helm del external-dns -n external-dns
$ cd terraform; terraform init; terraform destroy
```
