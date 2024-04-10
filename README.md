# **📊 LGTM Stack com Prometheus + Otel Collector**

## **Descrição**

Este repositório contém a configuração da LGTM Stack com Prometheus para Kubernetes, utilizando Helm e Helmfile para implantação. A stack inclui serviços como Grafana, Loki, Mimir, Prometheus, Promtail e Tempo, oferecendo uma solução de monitoramento e análise de logs abrangente.

---

## **Arquitetura Integrada da Stack LGTM com Prometheus + Otel Collector**

A stack LGTM com Prometheus foi meticulosamente projetada para oferecer um sistema de monitoramento e análise de dados coeso em ambientes Kubernetes, onde cada componente desempenha um papel fundamental:

- **Grafana**: Serve como o painel de controle visual, onde métricas, logs e traces são não só visualizados mas também gerenciados. É a ferramenta para a criação de alertas e dashboards, promovendo uma visão integrada do desempenho do sistema.
- **Prometheus**: Age como o motor de coleta de métricas, monitorando incessantemente os serviços e capturando dados cruciais para avaliar o desempenho e a saúde do sistema.
- **Mimir**: Assume o papel de arquivista para o armazenamento de longa duração das métricas, garantindo que as informações recolhidas pelo Prometheus sejam preservadas de maneira segura e escalável para análises prolongadas.
- **Loki**: É o especialista em logs, processando e arquivando as informações de log de forma a torná-las prontamente acessíveis e analisáveis por meio do Grafana.
- **Promtail**: Funciona como os 'sentidos' da stack, capturando os logs emitidos pelos serviços variados e os encaminhando ao Loki.
- **Tempo**: Oferece uma visão das transações e interações complexas por meio do tracing distribuído, coletando e armazenando esses dados para uma exploração profunda via Grafana.
- **Otel Collector**: Este é o maestro da coleta de telemetria, que harmoniza a recepção de métricas e traces de várias fontes, como instrumentações, e as direciona aos sistemas apropriados. É a peça-chave que unifica e simplifica o fluxo de dados para Prometheus, Tempo e Loki. Age como um processador de dados, otimizando a ingestão e enriquecendo as informações antes de enviá-las para armazenamento e análise. Esta capacidade de transformação e padronização é vital para manter a eficácia e a confiabilidade da stack de monitoramento, reforçando a observabilidade no ambiente Kubernetes.

Cada componente é imprescindível, e a colaboração entre eles é o que possibilita uma visão holística e aprofundada do ambiente, o que é crucial para um monitoramento eficiente, resolução de problemas ágil e aprimoramento contínuo do desempenho.

![arc-lgtm-2.png](https://cdn.discordapp.com/attachments/874697345898520596/1203016596675764255/arc-lgtm-2.png?ex=65cf8f83&is=65bd1a83&hm=d31b6c31ab9f68621e74c4a1ee092f25f7c982c9e0e3d41c9d31929dc87e827d&)

---

## ➕ **Dependências**4

- **Kubernetes**
- **Helm**
- **Helmfile**
- **Terraform**

---

## **📋 Pré-Requisitos**

- Instalação do Helm e Helmfile (consulte [este guia](https://www.notion.so/Helm-e7ad4d8009be47a8a9196de221f66d4e?pvs=21) para instruções detalhadas).
- Instalação do Terraform  (consulte [este guia](https://www.notion.so/Instalation-4a494c1fe97649d7af8b0f051f8edb51?pvs=21) para instruções detalhadas).

---

# **Configuração Inicial com Terraform**

Antes de prosseguir com a implantação da GTM Stack via Helmfile, é essencial configurar a infraestrutura AWS com Terraform. Este processo cria roles OIDC, políticas IA e buckets S3 necessários para os serviços Tempo e Mimir.

## **Configuração do Terraform**

1. **Provedor AWS**:
Defina o **`provider`** para especificar o perfil e a região da AWS.
2. **EKS Cluster**:
Utilize **`data`** para recuperar informações do seu cluster EKS existente.
3. **Buckets S3**:
    - **`module "s3-tempo"`, `module "s3-loki"`** e **** **`module "s3-mimir"`** criam buckets S3 para armazenar dados do Tempo, Loki e Mimir, respectivamente.
4. **Roles OIDC e Políticas IAM**:
    - **`module "s3-tempo"`, `module "s3-loki"`** e **** **`module "s3-mimir"`** configuram roles IAM com políticas que permitem acesso aos buckets S3 correspondentes.

## **Configuração do Backend para Produção**:

Para ambientes de produção, é recomendado configurar o Terraform para usar um bucket S3 como backend, adicionando o seguinte bloco no arquivo **`versions.tf`**:

```yaml
terraform {
  backend "s3" {
    bucket  = "SEU_BUCKET"
    key     = "tfstate"
    region  = "SUA_REGIAO"
    profile = "SEU_PROFILE"
  }
}
```

## **Aplicando o Terraform**

- Inicialize o Terraform:
    
    ```bash
    terraform init
    ```
    
- Planeje as alterações:
    
    ```bash
    terraform plan
    ```
    
- Aplique a configuração:
    
    ```bash
    terraform apply
    ```
    
- Para desfazer a infraestrutura, se necessário:
    
    ```bash
    terraform destroy
    ```
    

## **Outputs do Terraform**

Os outputs **`iam-mimir-arn`, `iam-loki-arn`** e **`iam-tempo-arn`** serão gerados. Inclua esses ARNs nas annotations do Helm para Mimir e Tempo, garantindo a correta autorização de acesso aos recursos AWS.

Inclua os ARNs fornecidos nas annotations dos Helms do Mimir e do Tempo, como mostrado abaixo:

```yaml
annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::<ID_DO_SEU_ACCOUNT>:role/<ROLE_NAME>
```

---

## **Configuração dos Serviços: Mimir, Loki e Tempo**

A stack LGTM dispõe de configurações flexíveis para os serviços Loki, Mimir e Tempo, projetadas para se adaptar a diferentes volumes de dados e requisitos de retenção.

**Os values ainda estão em revisão!**

- **Mimir**: **`small.yaml`** suporta até 1 milhão de métricas com 30 dias de retenção, **`large.yaml`** para até 10 milhões de métricas com 30 dias de retenção.
- **Tempo**: **`small.yaml`** acomoda até 1 milhão de traços com 7 dias de retenção, **`large.yaml`** para até 10 milhões de traços com 7 dias de retenção.

As definições para cada um desses serviços são facilmente gerenciáveis através do arquivo **`helmfile.yaml`**. Para ativar uma configuração específica, basta descomentar a linha correspondente ao arquivo **`small.yaml`** ou **`large.yaml`** desejado.

Para ambientes de teste ou desenvolvimento, recomenda-se utilizar as configurações padrão, que já são suficientes para a maioria dos cenários de laboratório.

---

## 🔧 **Instalação da Stack LGTM**

1. Clone o repositório:
    
    ```bash
    git clone git@github.com:leozw/lgtm.git
    ```
    
2. Navegue até o diretório e execute:
    
    ```bash
    helmfile apply
    ```
    
    para instalar a stack.
    

## 💡 **Atualizações e Manutenção**

- Para atualizar a stack, execute:
    
    ```bash
     helmfile sync
    ```
    
- Para remover toda a stack, use:
    
    ```bash
     helmfile delete
    ```
    
- Para remover um serviço específico, use:
    
    ```bash
     helm uninstall [release_name] -n lgtm
    ```
    

Após a remoção, o mesmo deverá ser removido do `helmfile.yaml`, para manter a consistência.

---

## 🔧 Instalação OpenTelemetry collector

Instação do OpenTelemetry collector basta aplicar o seguinte comando, a partir do diretório raiz:

```bash
kubectl apply -k ./kubernetes-otel-collector
```

---

## **Acessando o Grafana**

Para visualizar as métricas e consultar dados do Mimir e Tempo (caso tenha traces), você pode usar o port-forward para acessar a interface do Grafana:

1. Execute o comando abaixo para criar um port-forward para o Grafana:
    
    ```bash
    kubectl port-forward svc/grafana 3000:80 -n lgtm
    ```
    
    Isso tornará o Grafana acessível em **`localhost:3000`** no seu navegador.
    
2. Para obter a senha padrão do Grafana, use o seguinte comando:
    
    ```bash
    kubectl get secret -n lgtm grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
    
    Use este comando para recuperar a senha de administração do Grafana.
    
3. Acesse o Grafana em seu navegador e use as credenciais de administração para fazer login.
O usuário default é `admin`.
Explore as métricas disponíveis e faça consultas para validar os dados do Mimir.

---

## **Armazenamento de Objetos para Mimir e Tempo**

Nossa LGTM Stack utiliza o AWS S3 como solução padrão de armazenamento de objetos para Mimir e Tempo. Entretanto, é totalmente é possível substituir o AWS S3 por outras opções de armazenamento de objetos que sejam compatíveis. As alternativas incluem:

- AWS S3
- MinIO
- Google Cloud Storage
- Azure Blob Storage
- Qualquer sistema compatível com a API S3

Para integrar Mimir e Tempo com um sistema de armazenamento alternativo, como o AWS S3, é necessário adaptar as configurações nos respectivos arquivos de valores. Providenciamos um exemplo de como configurar a conexão com o AWS S3 no repositório. Ajuste as credenciais e outras configurações específicas de acordo com o seu provedor de armazenamento.

---

## **Configuração do Loki**

Embora o Loki venha com configurações pré-prontas **`small.yaml`** e **`large.yaml`** para diferentes escalas de uso, é crucial avaliar suas necessidades específicas e ajustar a configuração adequadamente. Essas configurações padrão servem como um bom ponto de partida, mas podem não atender a todos os requisitos de uso, especialmente em ambientes com padrões de tráfego ou retenção de dados únicos.

É recomendado revisar e personalizar as configurações para garantir que o Loki funcione de maneira otimizada no seu ambiente. Isso pode incluir ajustes na capacidade de armazenamento, no desempenho da consulta e nas políticas de retenção de dados.

---

## **Configuração do Promtail**

O Promtail está configurado para coletar logs de pods que têm annotaion.

Isso ajuda a filtrar e coletar logs de forma mais eficiente, concentrando-se em pods relevantes. 

A configuração padrão é:

```yaml
annotations:
  promtail_logs: "true"
```

Esta anotação deve ser adicionada aos pods dos quais você deseja coletar logs.

Além disso, existe uma configuração alternativa, que está comentada, para a filtragem de logs por namespace. Aqui estão as duas configurações:

**Filtragem por Annotation (Configuração Padrão):**

```yaml
# Filtro por annotation
- action: keep
  source_labels: [__meta_kubernetes_pod_annotation_promtail_logs]
  regex: "true"
```

**Filtragem por Namespace (Comentada):**

```yaml
# Filtro por namespace   
- action: keep
  source_labels: [__meta_kubernetes_namespace]
  regex:  "^(default|lgtm)$" # Adicione os namespaces desejados
```

Para ativar a filtragem por namespace, descomente essas linhas e ajuste o valor de **`regex`** para o nome do namespace que deseja monitorar.

---

## **Requisitos do Cluster/NodePool**

Para implantar esta stack com eficiência, é importante considerar os requisitos de recursos do cluster ou nodepool. Os valores a seguir representam o uso base da stack, mas é importante notar que, ao utilizar arquivos de recursos adicionais para o Mimir, Loki e Tempo, os requisitos de recursos podem aumentar significativamente.

É recomendável avaliar cuidadosamente as necessidades de CPU, memória e armazenamento, ajustando o Cluster ou NodePool de acordo com essas demandas. Esta avaliação ajudará a garantir que a stack opere de forma estável e eficiente.

![resources](https://media.discordapp.net/attachments/890968993110839316/1201887893917016104/image.png?ex=65e723d3&is=65d4aed3&hm=9afa359b3aee9ca08030b49992f940cc693c06ae3fc9cae075ac932fed970123&=&format=webp&quality=lossless&width=773&height=468)

---

## **Estrutura do Repositório**

O repositório está estruturado com diretórios para cada serviço (Grafana, Loki, Mimir, Prometheus, Promtail, Tempo), cada um contendo seus respectivos valores de configuração e arquivos de template Helm.

---

## **Contribuições**

Contribuições são bem-vindas.
