# Instalando Kind em seu WSL2

Documentação de como utilizar o kind no wsl.

https://kind.sigs.k8s.io/docs/user/quick-start

On linux: 
```
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
```

# Accessing a Kubernetes Service running in WSL2 

Documentação de como utilizar wsl2 com kind. 

https://kind.sigs.k8s.io/docs/user/using-wsl2/#accessing-a-kubernetes-service-running-in-wsl2

## Criando Cluster WSL2
Criando cluster:
```
 kind create cluster --config=cluster-config.yml --name=paulo
```
Configurando contexto:
```
kubectl cluster-info --context kind-kind
```

## Destruindo Cluster WSL2
```
kind delete cluster
```

## Lister Cluster Kind
```
kind get clusters
```

## Deletar um Cluster Específico
```
kind get clusters NOME_CLUSTER
```
