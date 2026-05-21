#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Criando cluster: desenvolvimento"
k3d cluster create --config "$SCRIPT_DIR/k8s-desenvolvimento.yaml"

echo "    -> Criando namespaces: dev, hk, prod"
kubectl create namespace dev  --context k3d-desenvolvimento
kubectl create namespace hk   --context k3d-desenvolvimento
kubectl create namespace prod --context k3d-desenvolvimento

echo "    -> Aplicando LimitRange e ResourceQuota"
kubectl apply -f "$SCRIPT_DIR/limitrange.yaml" --context k3d-desenvolvimento
kubectl apply -f "$SCRIPT_DIR/quota.yaml"      --context k3d-desenvolvimento

kubectl config set-context k3d-desenvolvimento --namespace=dev

echo ""
echo "==> Cluster criado:"
k3d cluster list

echo ""
echo "==> Context ativo:"
kubectl config current-context

