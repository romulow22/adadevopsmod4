# Jornada Digital CAIXA| Devops | #1148

## Projeto do Modulo 4: *Provisionamento como código*

- Autor: Romulo Alves | c153824

### Descrição

Este projeto utiliza o Terraform para definição e provisão de infraestrutura, garantindo que todos os recursos sejam criados e gerenciados de forma consistente e idempotente. 

O código é estruturado em módulos, facilitando a reutilização e organização. Cada módulo representa um recurso ou um grupo de recursos relacionados, como um cluster de AKS ou uma conta de armazenamento, e contém toda a lógica necessária para provisionar esses recursos.

Além disso, o projeto também inclui scripts e arquivos de variáveis (.tfvars) para parametrizar a infraestrutura e permitir fácil customização e implantação em diferentes ambientes.

Esta abordagem assegura que a infraestrutura seja tratada como código, permitindo versionamento, revisão de mudanças e colaboração eficiente entre a equipe.

Foram provisionados os seguintes serviços:
- Azure Kubernetes Service (AKS)
- Azure Cache for Redis
- Azure Storage Account
- Azure Event Hub
- Azure Container Registry

Além disso, também foram habilitados serviços de monitoração como o Diagnostics Settings no Redis, Storage e Event Hub, e o Container Insights no AKS. Todos estes dados são armazenados em Log Analytics workspaces.

### Estrutura

```
PS C:\Users\User\repos\adadevopsmod4> tree
Folder PATH listing
C:.
├───.terraform
│   ├───modules
│   └───providers
│       └───registry.terraform.io
│           └───hashicorp
│               ├───azurerm
|               ├───helm
│               ├───local
│               └───tls
├───modules
│   ├───aks
│   ├───eventhub
│   ├───eventhubnamespace
│   ├───loganalytics
│   ├───producerapp
│   ├───redis
│   ├───resourcegroup
│   ├───storageaccount
│   ├───subnet
│   └───vnet
├───scripts
├───secrets
└───tfvars
```

### Pré-requisitos

1. Subscrição na Azure e usuário com perfil "Owner"
2. Módulos Azure CLI e Azure PowerShell
3. Git
4. Openssl
5. Terraform
6. Kubectl

## Instruções

**Atenção: Todos os comandos abaixo foram executados no Windows PowerShell**

1. Clonar o repositório

```
git clone https://github.com/romulow22/adadevopsmod4.git
```

2. Criar conta de serviço para ser utilizada pelo Terraform

```
cd .\secrets\
```

* Gerar um certificado auto-assinado 
```
openssl req -new -newkey rsa:4096 -sha256 -days 730 -nodes -x509 -keyout client.key -out client.crt
```
* Exportá-lo em *.pfx
```
openssl pkcs12 -export -password pass:"Pa55w0rd123" -out client.pfx -inkey client.key -in client.crt
```
* Criar um service principal com o client.crt
```
az ad sp create-for-rbac --name myServicePrincipalADA --role Owner --scopes /subscriptions/[colocar sua subscrição aqui] --cert "@C:\[colocar o caminho até o projeto]\adadevopsmod4\secrets\client.crt"
```
* Gerar o .pem para validar a autenticação localmente
```
openssl pkcs12 -password pass:"Pa55w0rd123" -in client.pfx -out client.pem -nodes
```
* Testar a autenticação
```
az login --service-principal --username [colocar o appId]  --tenant [colocar seu tenant] --password client.pem
```
* Deslogar da conta de serviço e voltar para a pasta principal do projeto
```
az logout
cd ..
```

**OBS**: Tutorial baseado da documentação oficial do [Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_certificate.html)


3. Preparar o ambiente

* Logar com sua conta de usuário
```
az login
az account set --subscription [incluir o subscriptionID aqui]
```
* Criação do Storage Account com as políticas necessárias onde o Tfstate ficará

**Atenção: é preciso incluir o seu subscriptionID no script**

```
.\scripts\New-TfStateStg.ps1
```

* Criar as variáveis de ambiente que o Terraform precisará com sua conta de serviço criada anteriormente

**Atenção: é preciso incluir subscriptionID, clientID (appID), tenantID e também o caminho completo até o certificado client.pfx no script**
```
.\scripts\Set-TfEnvVars.ps1
```

4. Provisionar o ambiente
```
terraform init -upgrade
terraform fmt
terraform validate
terraform plan -out main.tfplan -var-file="./tfvars/des.tfvars"
```


5. Validar o ambiente

* Passar o kubeconfig para o seu kubectl
```
cp -Force ./secrets/kubeconfig ~/.kube/config
```
* Testar AKS
```
kubectl get pods -A
kubectl cluster-info
kubectl get events -A --sort-by='.metadata.creationTimestamp'
```

* Executar um deploy demonstrativo
```
kubectl create namespace hello-web-app-routing
kubectl apply -f ./scripts/example.yaml -n hello-web-app-routing
kubectl get all -n hello-web-app-routing
```

* Pegar o Ip publico do ingress e adicioná-lo ao **hosts** com o domínio "myapp.com"
```
kubectl get svc -n ingress
```

* Acessar pelo browser
```
http://myapp.coom
```

1. Para finalizar o projeto e remover o laboratório

```
terraform plan -destroy -out main.destroy.tfplan -var-file="./tfvars/des.tfvars"
terraform apply main.destroy.tfplan
az logout
cd ..
Remove-Item -Path 'C:\[colocar aqui o caminho até o projeto]\adadevopsmod4' -Recurse -Force
```


