# Multi-Cluster com k3d — Kubeconfig e Contexts

## Pré-requisitos: kubectx e kubens (WSL/Linux)

`kubectx` e `kubens` são ferramentas que simplificam a troca de contexts e namespaces no Kubernetes.

```bash
# Download e instalação via binário (WSL/Linux x86_64)
curl -sLo /tmp/kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx_v0.9.5_linux_x86_64.tar.gz
curl -sLo /tmp/kubens.tar.gz  https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens_v0.9.5_linux_x86_64.tar.gz

tar -xzf /tmp/kubectx.tar.gz -C /tmp
tar -xzf /tmp/kubens.tar.gz  -C /tmp

sudo mv /tmp/kubectx /usr/local/bin/kubectx
sudo mv /tmp/kubens  /usr/local/bin/kubens
sudo chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# Verificar instalação
kubectx --version   # 0.9.5
kubens  --version   # 0.9.5
```

| Comando nativo (`kubectl`) | Atalho com `kubectx`/`kubens` |
|---|---|
| `kubectl config get-contexts` | `kubectx` |
| `kubectl config use-context <ctx>` | `kubectx <ctx>` |
| `kubectl config current-context` | `kubectx -c` |
| `kubectl config use-context -` (voltar ao anterior) | `kubectx -` |
| `kubectl config set-context --current --namespace=<ns>` | `kubens <ns>` |

## Conceito

Em cenários reais, existem múltiplos clusters Kubernetes para ambientes diferentes. O `kubectl` gerencia isso via **kubeconfig**, que armazena:

- **clusters** — endpoints dos clusters
- **users** — credenciais de acesso
- **contexts** — combinação de cluster + user + namespace padrão

```
~/.kube/config
├── clusters
│   ├── k3d-desenvolvimento
│   ├── k3d-homologacao
│   └── k3d-producao
├── users
│   ├── admin@k3d-desenvolvimento
│   ├── admin@k3d-homologacao
│   └── admin@k3d-producao
└── contexts
    ├── k3d-desenvolvimento  ─► cluster + user [+ namespace]
    ├── k3d-homologacao      ─► cluster + user [+ namespace]
    └── k3d-producao         ─► cluster + user [+ namespace]
```

## Clusters deste exemplo

| Cluster | API Port | HTTP Port | HTTPS Port | Agents |
|---|---|---|---|---|
| `desenvolvimento` | `6443` | `8000` | `8443` | 1 |
| `homologacao` | `6444` | `8100` | `8143` | 1 |
| `producao` | `6445` | `8200` | `8243` | 2 |

> Cada cluster usa portas distintas no host para não colidir.

## Criando os clusters

```bash
# Subir todos os clusters de uma vez (recomendado)
./setup.sh

# Ou criar um de cada vez
k3d cluster create --config k8s-desenvolvimento.yaml
k3d cluster create --config k8s-homologacao.yaml
k3d cluster create --config k8s-producao.yaml

# Verificar clusters criados
k3d cluster list

# Verificar nodes de cada cluster
kubectl get nodes --context k3d-desenvolvimento
kubectl get nodes --context k3d-homologacao
kubectl get nodes --context k3d-producao
```

## Gerenciando contexts

```bash
# Listar todos os contexts disponíveis
kubectl config get-contexts

# Exemplo de saída:
#   CURRENT   NAME                  CLUSTER               AUTHINFO
#             k3d-desenvolvimento   k3d-desenvolvimento   admin@k3d-desenvolvimento
#             k3d-homologacao       k3d-homologacao       admin@k3d-homologacao
#   *         k3d-producao          k3d-producao          admin@k3d-producao

# Trocar de context (trocar de cluster ativo)
kubectl config use-context k3d-desenvolvimento
kubectl config use-context k3d-homologacao
kubectl config use-context k3d-producao

# Ver o context atual
kubectl config current-context
```

## Configurar namespace padrão em um context

Por padrão, o context aponta para o namespace `default`. Para mudar:

```bash
# Sintaxe
kubectl config set-context <context-name> --namespace=<namespace>

# Exemplos práticos
kubectl config set-context k3d-desenvolvimento --namespace=dev
kubectl config set-context k3d-homologacao     --namespace=homologacao
kubectl config set-context k3d-producao        --namespace=producao
```

Após configurar, todos os comandos naquele context já operam no namespace definido sem precisar do flag `-n`:

```bash
kubectl config use-context k3d-producao

# Automaticamente usa namespace 'producao'
kubectl get pods          # equivalente a: kubectl get pods -n producao
kubectl get deployments   # equivalente a: kubectl get deployments -n producao
```

### Verificar a configuração atual do context

```bash
kubectl config get-contexts k3d-producao

# Saída:
# CURRENT   NAME            CLUSTER         AUTHINFO              NAMESPACE
# *         k3d-producao    k3d-producao    admin@k3d-producao    producao
```

## Executar comando em cluster específico sem trocar de context

```bash
# Flag --context para executar pontualmente em outro cluster
kubectl get pods --context k3d-homologacao -n homologacao
kubectl apply -f deployment.yaml --context k3d-desenvolvimento
```

## Deletando os clusters

```bash
# Deletar todos os clusters de uma vez (recomendado)
./teardown.sh

# Ou deletar individualmente
k3d cluster delete desenvolvimento
k3d cluster delete homologacao
k3d cluster delete producao

# Ou todos de uma vez via k3d
k3d cluster delete --all
```

## Fluxo completo de estudo

```bash
# 1. Criar os três clusters
k3d cluster create --config k8s-desenvolvimento.yaml
k3d cluster create --config k8s-homologacao.yaml
k3d cluster create --config k8s-producao.yaml

# 2. Confirmar contexts registrados no kubeconfig
kubectl config get-contexts

# 3. Definir namespace padrão para cada context
kubectl config set-context k3d-desenvolvimento --namespace=dev
kubectl config set-context k3d-homologacao     --namespace=homologacao
kubectl config set-context k3d-producao        --namespace=producao

# 4. Trabalhar no cluster de desenvolvimento
kubectl config use-context k3d-desenvolvimento
kubectl get nodes

# 5. Trocar para produção
kubectl config use-context k3d-producao
kubectl get nodes
```
