#!/bin/bash

# Start minikube
#minikube start

# Setup ArgoCD
helm repo add argo-cd https://argoproj.github.io/argo-helm
helm dep update charts/argo-cd/
helm install argo-cd --namespace argo-cd charts/argo-cd/ --wait
#kubectl port-forward svc/argo-cd-argocd-server 8080:443
kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Setup Crossplane
kubectl create namespace crossplane-system
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane --wait

# App of Apps install
helm template charts/root-app/ | kubectl apply -f -
