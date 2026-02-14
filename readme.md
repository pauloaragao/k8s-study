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

## Verificar os pods com wide

```bash
kubectl get pods -o wide
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

# Replicaset 

Replicaset é um recurso do Kubernetes que garante que um número específico de réplicas de um pod esteja em execução a qualquer momento. Ele é responsável por criar e gerenciar os pods para garantir que o número desejado de réplicas esteja sempre disponível. Ele não é responsável por atualizar os pods, para isso é necessário usar um Deployment.

## Criar um replicaset de exemplo

```bash
kubectl create replicaset nginx --image=nginx --replicas=3
```

## Criar um replicaset a partir de um arquivo .yaml

```bash
kubectl apply -f replicaset.yaml
```

## Verificar os replicasets disponíveis

```bash
kubectl get replicasets
```

## Deletar o replicaset criado

```bash
kubectl delete replicaset nginx
```

## Deletar o replicaset a partir de um arquivo .yaml

```bash
kubectl delete -f replicaset.yaml
```

## Limpar os recursos criados

```bash
kubectl delete replicaset nginx
```

## Describe o replicaset

```bash
kubectl describe replicaset
```

## Verificar os pods criados pelo replicaset

```bash
kubectl get pods -l app=nginx
```

## Escalar o replicaset

```bash
kubectl scale replicaset nginx --replicas=5
```

## Verificar os pods após escalar o replicaset

```bash
kubectl get pods -l app=nginx
```

# Deployment

Deployment é um recurso do Kubernetes que gerencia a criação e atualização de réplicas de pods. Ele é responsável por garantir que o número desejado de réplicas esteja sempre disponível, além de permitir a atualização dos pods de forma controlada, garantindo alta disponibilidade durante o processo de atualização.

## Criar um deployment de exemplo

```bash
kubectl create deployment nginx --image=nginx
```
## Criar um deployment a partir de um arquivo .yaml

```bash
kubectl apply -f deployment.yaml
```
## Verificar os deployments disponíveis

```bash
kubectl get deployments
```

## Deletar o deployment criado

```bash
kubectl delete deployment nginx
```

## Deletar o deployment a partir de um arquivo .yaml

```bash
kubectl delete -f deployment.yaml
```

## Limpar os recursos criados

```bash
kubectl delete deployment nginx
```

## Describe o deployment

```bash
kubectl describe deployment
```

