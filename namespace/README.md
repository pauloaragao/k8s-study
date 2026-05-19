# Namespaces — Isolamento e Comunicação entre Ambientes

## Conceito

**Namespaces** no Kubernetes são clusters virtuais dentro do mesmo cluster físico. Permitem isolar recursos por ambiente (dev, homologacao, producao) sem precisar de clusters separados.

## Estrutura deste exemplo

```
namespace/
├── namespace.yaml        # define o namespace 'producao'
├── deployment.yaml       # Deployment + Service dentro do namespace 'producao'
└── external-service.yaml # ExternalName Service no namespace 'default'
                          # aponta para o Service dentro de 'producao'
```

## Como funciona a comunicação

```
[default namespace]                    [producao namespace]
                                       
Pod qualquer                           Pod web
    │                                      │
    │  curl http://web-producao           │
    ▼                                      │
Service: web-producao                      │
type: ExternalName                         │
externalName: web.producao.svc.cluster.local ──► Service: web
                                               ClusterIP port 80
```

O Kubernetes resolve `web.producao.svc.cluster.local` automaticamente via DNS interno. O `ExternalName` funciona como um **alias DNS** — redireciona a chamada para o serviço no outro namespace sem expor IP externo.

## Arquivos

### namespace.yaml
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: producao
```

### deployment.yaml
Deployment e Service do app `web` isolados no namespace `producao`:
```yaml
metadata:
  name: web
  namespace: producao   # ← recurso pertence ao namespace producao
```

### external-service.yaml
Service do tipo `ExternalName` criado no namespace `default` para alcançar o serviço em `producao`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-producao    # nome usado para chamar de dentro do default namespace
spec:
  type: ExternalName
  externalName: web.producao.svc.cluster.local  # DNS interno do service em producao
```

## Formato DNS interno do Kubernetes

```
<service-name>.<namespace>.svc.cluster.local
```

| Componente | Valor |
|---|---|
| `service-name` | `web` |
| `namespace` | `producao` |
| `svc.cluster.local` | sufixo padrão do cluster |

## Comandos úteis

```bash
# Aplicar o namespace primeiro
kubectl apply -f namespace.yaml

# Aplicar deployment e service em producao
kubectl apply -f deployment.yaml

# Aplicar o ExternalName no namespace default
kubectl apply -f external-service.yaml

# Listar recursos por namespace
kubectl get all -n producao
kubectl get svc -n default

# Testar a comunicação a partir de um pod no default namespace
kubectl run test --image=curlimages/curl --rm -it -- \
  curl http://web-producao

# Ver todos os namespaces
kubectl get namespaces

# Descrever o ExternalName service
kubectl describe svc web-producao
```

## Por que usar ExternalName?

| Situação | Benefício |
|---|---|
| Comunicação entre namespaces | Sem necessidade de expor porta externa |
| Migração gradual de serviços | Redireciona sem mudar o código cliente |
| Abstração de endpoints externos | Funciona também para URLs fora do cluster |
