#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Criando cluster: desenvolvimento"
k3d cluster create --config "$SCRIPT_DIR/k8s-desenvolvimento.yaml"

echo "==> Criando cluster: homologacao"
k3d cluster create --config "$SCRIPT_DIR/k8s-homologacao.yaml"

echo "==> Criando cluster: producao"
k3d cluster create --config "$SCRIPT_DIR/k8s-producao.yaml"

echo ""
echo "==> Clusters criados:"
k3d cluster list

echo ""
echo "==> Contexts disponíveis:"
kubectl config get-contexts
