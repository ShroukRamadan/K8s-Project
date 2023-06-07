#!/usr/bash/bin


kubectl apply -n argocd-ns -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml



kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'