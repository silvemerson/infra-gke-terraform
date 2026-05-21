# Infra GKE com OpenTofu

Provisionamento de cluster GKE na GCP usando [OpenTofu](https://opentofu.org/) (compatível também com Terraform).

## Recursos provisionados

- Cluster GKE com node pool separado e autoscaling
- Regra de firewall
- Deployment do Super Mario (via provider Kubernetes)
- Service do tipo LoadBalancer
- Kubeconfig gerado automaticamente (`kubeconfig.yaml`)

## Pré-requisitos

- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.6
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- Service account GCP com permissões de Editor no projeto
- **Cloud Resource Manager API habilitada** (única que precisa ser habilitada manualmente — ver abaixo)

## Configuração

### 1. Clone o repositório

```bash
git clone https://github.com/silvemerson/infra-gke-terraform.git
cd infra-gke-terraform
```

### 2. Habilite a Cloud Resource Manager API

Essa é a única API que precisa ser habilitada manualmente — o OpenTofu cuida das demais (`compute`, `container`).

```bash
gcloud auth activate-service-account \
  --key-file=/caminho/para/sua-chave.json

gcloud services enable cloudresourcemanager.googleapis.com \
  --project=SEU_PROJECT_ID
```

### 3. Configure as variáveis

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edite o `terraform.tfvars` com seus valores reais:

```hcl
gcp_credentials_file = "/caminho/para/sua-chave.json"
gcp_project          = "seu-project-id"
cluster_name         = "sparta-cluster"
node_size            = "e2-medium"
```

> O arquivo `terraform.tfvars` e o `kubeconfig.yaml` estão no `.gitignore` e não serão commitados.

### 4. Inicialize e aplique

```bash
tofu init
tofu validate
tofu plan -var-file=terraform.tfvars
tofu apply -var-file=terraform.tfvars
```

O OpenTofu vai:
1. Habilitar as APIs `compute.googleapis.com` e `container.googleapis.com`
2. Criar o cluster GKE e o node pool
3. Fazer o deploy do Super Mario
4. Gerar o `kubeconfig.yaml` na raiz do projeto

### 5. Acesse o cluster e a aplicação

```bash
export KUBECONFIG=./kubeconfig.yaml

kubectl get nodes
kubectl get pods
kubectl get service supermario
```

Quando o campo `EXTERNAL-IP` estiver preenchido, acesse `http://<EXTERNAL-IP>` no navegador.

Ou use o output direto do OpenTofu:

```bash
tofu output supermario_ip
```

## Variáveis

| Variável | Descrição | Default |
|---|---|---|
| `gcp_credentials_file` | Caminho para o JSON da service account | *obrigatório* |
| `gcp_project` | ID do projeto GCP | *obrigatório* |
| `default_region` | Região de provisionamento | `us-central1` |
| `default_zone` | Zona de provisionamento | `us-central1-c` |
| `cluster_name` | Nome do cluster GKE | `sparta-cluster` |
| `node_size` | Tipo de máquina dos nodes | `e2-medium` |
| `node_count` | Número inicial de nodes | `1` |
| `disk_size_gb` | Tamanho do disco por node (GB) | `50` |
| `spot_nodes` | Habilitar nodes Spot | `false` |
| `min_node_count` | Mínimo de nodes (autoscaling) | `0` |
| `max_node_count` | Máximo de nodes (autoscaling) | `6` |
| `network_name` | Nome da rede VPC | `default` |
| `firewall_name` | Nome da regra de firewall | `asgard-prod-allow` |
| `supermario_replicas` | Número de réplicas do Super Mario | `2` |

## Destruir a infra

```bash
tofu destroy -var-file=terraform.tfvars
```

## Troubleshooting

### deployment already exists

Ocorre quando o OpenTofu perdeu o estado do deployment mas o recurso ainda existe no cluster. Importe o recurso de volta ao state:

```bash
tofu import -var-file=terraform.tfvars kubernetes_deployment.supermario default/supermario
tofu apply -var-file=terraform.tfvars
```

### Unexpected Identity Change

Bug conhecido do provider Kubernetes com OpenTofu quando o deployment ficou em estado inconsistente após uma falha. Remova do state e reimporte:

```bash
tofu state rm kubernetes_deployment.supermario
tofu import -var-file=terraform.tfvars kubernetes_deployment.supermario default/supermario
tofu apply -var-file=terraform.tfvars
```

### kubeconfig conectando em localhost:8080

O token do kubeconfig gerado pelo OpenTofu expira em ~1h. Para renovar, basta rodar `tofu apply` novamente — o arquivo `kubeconfig.yaml` será atualizado com um novo token.
