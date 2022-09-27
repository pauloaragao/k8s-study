# Comandos kubectl
## Listar clusters

```
    kubectl config get-clusters
```

## Deletar Cluster
```
    kubectl delete NOME-CLUSTER
```

## Mudar contexto
```
    kubectl config use-context NOME-DO-CLUSTER
```

## Listar 
### Nodes
```
    kubectl get nodes
```

### Replicaset
```
    kubectl get replicasets
```

## Aplicar arquivo de configuração
```
 kubectl apply -f CAMINHO/ARQUIVO.YAML
```

## Redirecionando porta do pod
```
kubectl port-forward pod/NOME-DO-POD PORTA-LOCAL:PORTA-DO-POD
```
## Detalhando informações do POD
```
kubectl describe pod NOME-DO-POD
```