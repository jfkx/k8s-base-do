#!/bin/bash

# ingress-nginx, load balancer and Let's Encrypt

# ingress-nginx is done in Digital Ocean UI or
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/do/deploy.yaml

echo "- cert-manager"
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml

echo "- ingress-nginx workaround"
kubectl apply -f 02-ingress_nginx_svc.yaml

echo "- issuer class"
sleep 30
kubectl apply -f 03_01-letsencrypt-prod.yml

# longhorn volumes
echo "- longhorn volumes"
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/longhorn.yaml

USER=admin; PASSWORD=Citronek123; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> /tmp/auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=/tmp/auth
/bin/rm /tmp/auth

echo "- longhorn ingress"
kubectl apply -f 04-longhorn-ingress.yml