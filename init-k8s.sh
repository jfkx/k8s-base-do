#!/bin/bash

# nginx ingress is done in DO UI

kubectl apply -f 01-cert-manager.crds.yaml
kubectl apply -f 02-ingress_nginx_svc.yaml
kubectl apply -f 03_01-letsencrypt-prod.yml