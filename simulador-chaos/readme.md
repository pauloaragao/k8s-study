# Simulador do Caos — LivenessProbe via HTTP

## Conceito

O **Simulador do Caos** é uma aplicação que simula falhas aleatórias em produção para testar o comportamento do Kubernetes na recuperação automática de containers com falha.

Diferente do exemplo busybox (exec), aqui a **livenessProbe** usa `httpGet` — o Kubernetes faz uma requisição HTTP ao container e valida o status code:

- Status `2xx` ou `3xx` → container **saudável**
- Status `4xx`, `5xx` ou sem resposta → container **não saudável** → reinício automático

## Arquitetura

```
Usuário → Service (port 3001) → Pod (containerPort 3000) → /health (livenessProbe)
```

## Configuração

### deployment.yaml

```yaml
livenessProbe:
  httpGet:
    path: /health          # endpoint verificado pelo Kubernetes
    port: 3000             # porta do container
  initialDelaySeconds: 5   # aguarda 5s antes da 1ª verificação
  periodSeconds: 5         # verifica a cada 5s
  failureThreshold: 3      # 3 falhas consecutivas → reinicia o container
  successThreshold: 1      # 1 sucesso já marca como saudável
  timeoutSeconds: 5        # timeout por verificação
```

### service.yaml

```yaml
port: 3001        # porta exposta externamente
targetPort: 3000  # porta interna do container
type: LoadBalancer
```

## Comportamento esperado

O simulador retorna falhas aleatoriamente no endpoint `/health`. Quando falha por 3 ciclos consecutivos (`failureThreshold: 3`), o Kubernetes:

1. Marca o container como **não saudável**
2. **Reinicia** o container automaticamente
3. O pod volta a `Running` e o ciclo se repete

Isso simula um cenário real de **auto-healing** do Kubernetes.

## Comparação de tipos de livenessProbe

| Tipo | Método | Usado em |
|---|---|---|
| `exec` | Código de saída de comando | busybox (cat /tmp/health) |
| `httpGet` | Status code HTTP | simulador-chaos (/health) |
| `tcpSocket` | Conexão TCP bem-sucedida | bancos de dados, serviços TCP |

## Comandos úteis

```bash
# Aplicar os manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Observar restarts em tempo real
kubectl get pods -w

# Ver quantidade de restarts e status
kubectl get pods

# Detalhes dos eventos (ver falhas da probe)
kubectl describe pod <nome-do-pod>

# Acessar a aplicação (via k3d)
curl http://localhost:3001

# Testar o endpoint de health manualmente
curl http://localhost:3001/health

# Forçar o caos (se a aplicação expuser endpoint)
curl -X POST http://localhost:3001/chaos
```

## Fluxo de auto-healing

```
Pod Running
    │
    ▼
livenessProbe → GET /health
    │
    ├── 200 OK ──────────────→ continua Running
    │
    └── 500 / timeout
          │
          ▼ (após failureThreshold: 3)
       Container reiniciado
          │
          ▼
       Pod Running (RESTARTS +1)
```
