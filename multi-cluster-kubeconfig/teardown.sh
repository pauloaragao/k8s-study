#!/usr/bin/env bash
set -euo pipefail

echo "==> Deletando todos os clusters k3d..."
k3d cluster delete desenvolvimento
k3d cluster delete homologacao
k3d cluster delete producao

echo ""
echo "==> Clusters restantes:"
k3d cluster list
