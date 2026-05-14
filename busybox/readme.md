# Busybox — LivenessProbe via Exec (código de saída)

## Conceito

A **livenessProbe** com `exec` executa um comando dentro do container e usa o **código de saída** para determinar se o container está saudável:

- Código `0` → container **saudável**
- Código diferente de `0` → container **não saudável** → Kubernetes reinicia o container

## Como funciona neste exemplo

```yaml
command:
  - /bin/sh
  - -c
args:
  - touch /tmp/heath; sleep 600;   # cria o arquivo /tmp/heath (typo intencional)

livenessProbe:
  exec:
    command:
      - cat
      - /tmp/health                 # verifica /tmp/health (correto)
  initialDelaySeconds: 5            # aguarda 5s antes da primeira verificação
  periodSeconds: 5                  # verifica a cada 5s
  failureThreshold: 3               # após 3 falhas consecutivas, reinicia o container
  successThreshold: 1               # 1 sucesso já marca como saudável
  timeoutSeconds: 5                 # timeout de cada verificação
```

> **Atenção:** o `touch` cria `/tmp/heath` (sem `l`), mas a probe verifica `/tmp/health`.  
> Isso simula uma falha — o pod ficará em loop de restart (`CrashLoopBackOff`) após `failureThreshold` falhas.

## Cenários

| Situação | Resultado |
|---|---|
| Arquivo `/tmp/health` existe | `cat` retorna `0` → pod **Running** |
| Arquivo não existe (este exemplo) | `cat` retorna `1` → pod **reiniciado** |

## Comandos úteis

```bash
# Aplicar o deployment
kubectl apply -f deployment.yaml

# Observar os restarts em tempo real
kubectl get pods -w

# Verificar eventos e motivo dos restarts
kubectl describe pod <nome-do-pod>

# Ver logs do container
kubectl logs <nome-do-pod>
```
