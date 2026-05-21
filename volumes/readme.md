# Volumes

Volumes no Kubernetes resolvem dois problemas fundamentais:
- **Ephemeral storage**: dados em containers são perdidos quando o container reinicia
- **Compartilhamento**: múltiplos containers no mesmo Pod precisam compartilhar dados

Existem dois modelos de provisionamento: **estático** e **dinâmico**.

---

## Estática

```
POD -> PV -> Volume
```

O administrador cria o `PersistentVolume` (PV) manualmente, apontando para um volume físico já existente (NFS, disco local, cloud disk, etc.). O Pod referencia o PV diretamente via `PersistentVolumeClaim` (PVC) que faz o bind com um PV disponível de capacidade compatível.

### Componentes

**PersistentVolume (PV)**
- Recurso do cluster (não pertence a um namespace)
- Representa o volume físico provisionado pelo admin
- Define capacidade, `accessModes` e `persistentVolumeReclaimPolicy`

| Access Mode       | Descrição                                      |
|-------------------|------------------------------------------------|
| `ReadWriteOnce`   | Leitura e escrita por um único nó              |
| `ReadOnlyMany`    | Leitura por múltiplos nós simultaneamente      |
| `ReadWriteMany`   | Leitura e escrita por múltiplos nós            |

| Reclaim Policy | Comportamento após liberação do PVC |
|----------------|-------------------------------------|
| `Retain`       | PV preservado, requer intervenção manual |
| `Delete`       | PV e volume subjacente são deletados |
| `Recycle`      | Depreciado — limpeza básica do volume |

**PersistentVolumeClaim (PVC)**
- Pertence a um namespace
- Requisição de armazenamento feita pelo Pod (capacidade + accessMode)
- Kubernetes faz o bind automático com um PV compatível

### Fluxo

```
Admin cria PV  -->  Dev cria PVC  -->  Kubernetes faz bind PVC<->PV  -->  Pod monta o PVC
```

### Limitação

Requer que o admin provisione volumes com antecedência. Não escala bem em ambientes dinâmicos.

---

## Dinâmica

```
POD -> PVC -> SC -> PV -> Volume
```

O `PersistentVolume` é criado **automaticamente** pelo Kubernetes quando um PVC é solicitado, usando um `StorageClass` (SC) que define o provisionador responsável por criar o volume no backend (AWS EBS, GCE PD, Azure Disk, etc.).

### Componentes adicionais

**StorageClass (SC)**
- Define o provisionador (`provisioner`) e parâmetros do backend
- Pode haver múltiplas StorageClasses por cluster (ex: `ssd`, `hdd`, `premium`)
- A StorageClass marcada como `default` é usada quando o PVC não especifica nenhuma

### Fluxo

```
Dev cria PVC com storageClassName
        |
        v
Kubernetes aciona o provisioner da StorageClass
        |
        v
Provisioner cria o volume no backend (ex: AWS EBS)
        |
        v
PV é criado automaticamente e vinculado ao PVC
        |
        v
Pod monta o PVC
```

### Vantagem sobre o modelo estático

- Sem intervenção manual do admin para cada volume
- Escala automaticamente conforme a demanda
- Padrão adotado em clusters gerenciados (EKS, GKE, AKS)
