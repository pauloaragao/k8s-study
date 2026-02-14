# K3D

## Instalação do K3D no WSL2

```bash
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
```
## Criar um cluster K3D

```bash
k3d cluster create mycluster
```
## Verificar os clusters disponíveis

```bash
k3d cluster list
```

## Excluir o cluster
```bash
k3d cluster delete mycluster
```
## Configurar o kubectl para usar o cluster K3D

```bash
export KUBECONFIG=$(k3d kubeconfig write mycluster)
```

# Kubectl

## Acessar o cluster

```bash
kubectl cluster-info
```

## Verificar os nós do cluster

```bash
kubectl get nodes
```

## Verificar os pods em execução

```bash
kubectl get pods 
```

## Cria os pods de um .yaml

```bash
kubectl apply -f deployment.yaml
```

## Deletar os pods criados

```bash
kubectl delete -f deployment.yaml
```

## Criar um deployment de exemplo

```bash
kubectl create deployment nginx --image=nginx
```

## Expor o deployment como um serviço

```bash
kubectl expose deployment nginx --port=80 --type=NodePort
```

## Verificar os serviços disponíveis

```bash
kubectl get services
```

## Acessar o serviço

```bash
kubectl port-forward service/nginx 8080:80
```

Agora você pode acessar o serviço Nginx em `http://localhost:8080` no seu navegador.

## Limpar os recursos criados

```bash
kubectl delete service nginx
kubectl delete deployment nginx
```
