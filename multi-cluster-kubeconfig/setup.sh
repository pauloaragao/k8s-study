#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Criando cluster: desenvolvimento"
k3d cluster create --config "$SCRIPT_DIR/k8s-desenvolvimento.yaml"
echo "    -> Criando namespaces: dev, hk, prod"
kubectl create namespace dev  --context k3d-desenvolvimento
kubectl create namespace hk   --context k3d-desenvolvimento
kubectl create namespace prod --context k3d-desenvolvimento
kubectl apply -f "$SCRIPT_DIR/limitrange.yaml" --context k3d-desenvolvimento
kubectl apply -f "$SCRIPT_DIR/quota.yaml"      --context k3d-desenvolvimento
echo "    -> LimitRange e ResourceQuota aplicados"
kubectl config set-context k3d-desenvolvimento --namespace=dev

echo "==> Criando cluster: homologacao"
k3d cluster create --config "$SCRIPT_DIR/k8s-homologacao.yaml"
echo "    -> Criando namespaces: dev, hk, prod"
kubectl create namespace dev  --context k3d-homologacao
kubectl create namespace hk   --context k3d-homologacao
kubectl create namespace prod --context k3d-homologacao
kubectl apply -f "$SCRIPT_DIR/limitrange.yaml" --context k3d-homologacao
kubectl apply -f "$SCRIPT_DIR/quota.yaml"      --context k3d-homologacao
echo "    -> LimitRange e ResourceQuota aplicados"
kubectl config set-context k3d-homologacao --namespace=hk

echo "==> Criando cluster: producao"
k3d cluster create --config "$SCRIPT_DIR/k8s-producao.yaml"
echo "    -> Criando namespaces: dev, hk, prod"
kubectl create namespace dev  --context k3d-producao
kubectl create namespace hk   --context k3d-producao
kubectl create namespace prod --context k3d-producao
kubectl apply -f "$SCRIPT_DIR/limitrange.yaml" --context k3d-producao
kubectl apply -f "$SCRIPT_DIR/quota.yaml"      --context k3d-producao
echo "    -> LimitRange e ResourceQuota aplicados"
kubectl config set-context k3d-producao --namespace=prod

echo ""
echo "==> Clusters criados:"
k3d cluster list

echo ""
echo "==> Contexts e namespaces configurados:"
kubectl config get-contexts
