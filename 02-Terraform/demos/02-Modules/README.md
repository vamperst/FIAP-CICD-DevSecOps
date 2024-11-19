1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/02-Modules/` para entrar na pasta do exercício.

<details>
<summary> 
<b>Explicação Estrutura de pastas</b>

</summary>

<blockquote>

No exercício, as pastas que possuem o sufixo **"-call"** são aquelas responsáveis por **chamar os módulos locais do Terraform**. Essas pastas atuam como pontos de entrada para a execução de configurações definidas em módulos reutilizáveis. 

## O que é um módulo no Terraform?

Um **módulo no Terraform** é um conjunto de arquivos de configuração agrupados que encapsulam recursos relacionados e fornecem uma forma de reutilização e organização. Ele permite que você componha infraestrutura complexa dividindo-a em partes menores, mais gerenciáveis e reutilizáveis. 

### Como funciona?
- **Pastas com o sufixo "-call"**: São usadas para **invocar os módulos** e especificar os parâmetros necessários para sua configuração. Elas simplificam o processo de execução ao fornecer a interface de chamada para os módulos já definidos.
- **Módulos locais**: Geralmente, são pastas contendo arquivos `.tf` que definem os recursos e lógica de infraestrutura. Essas definições são referenciadas nas pastas "-call" usando o bloco `module`.

### Exemplos de uso
```hcl
module "example" {
  source = "../modules/example-module"
  variable_1 = "value"
  variable_2 = "value"
}
```

</blockquote>
</details>

2. Entre na pasta vpc-call com o comando `cd vpc-call`
3. Execute o comando `terraform init`
4. Execute o comando `terraform plan`
5. Execute o comando `terraform apply -auto-approve`

<details>
<summary> 
<b>Explicação Configuração VPC</b>

</summary>

<blockquote>
# Como a Arquitetura Funciona

A arquitetura definida pelos arquivos Terraform cria uma infraestrutura básica na AWS com conectividade à Internet. Abaixo está uma explicação detalhada de como ela funciona e como os componentes se integram.

---

## 1. **Virtual Private Cloud (VPC)**

### O que é?
- A VPC é uma rede virtual isolada na AWS onde os recursos, como sub-redes e gateways, são criados.

### Como funciona?
- A configuração no arquivo `vpc.tf` cria uma VPC com:
  - **Bloco CIDR:** Define o intervalo de endereços IP (`9.0.0.0/16`).
  - **DNS e Hostnames:** Ativados para facilitar a resolução de nomes e a comunicação entre os recursos.

### Objetivo:
- Servir como base para todos os outros recursos, garantindo uma rede segura e personalizada.

---

## 2. **Sub-redes Públicas**

### O que são?
- As sub-redes são divisões dentro da VPC que permitem organizar e isolar os recursos.

### Como funciona?
- No arquivo `vpc.tf`:
  - É criada uma sub-rede pública para **cada zona de disponibilidade** na região configurada (`us-east-1`).
  - Cada sub-rede é configurada para:
    - **Atribuir IPs públicos automaticamente.**
    - **Ser mapeada a partir do bloco CIDR principal da VPC.**

### Objetivo:
- Hospedar recursos que precisam de acesso público, como servidores web.

---

## 3. **Internet Gateway (IGW)**

### O que é?
- Um componente que conecta a VPC à Internet, permitindo que os recursos públicos acessem e sejam acessados pela Internet.

### Como funciona?
- No arquivo `igw.tf`:
  - O Internet Gateway é associado à VPC.
  - Ele é essencial para permitir que as sub-redes públicas tenham conectividade externa.

### Objetivo:
- Prover conectividade externa para os recursos na VPC, como servidores ou containers.

---

## 4. **Integração entre os Componentes**

### Fluxo de Configuração:
1. **VPC criada:** Serve como a rede principal onde tudo será configurado.
2. **Sub-redes públicas configuradas:**
   - Cada zona de disponibilidade recebe uma sub-rede.
   - Estas sub-redes têm conectividade pública habilitada.
3. **Internet Gateway associado:** Permite a comunicação da VPC com a Internet.
4. **Recursos são implantados:** Os recursos podem ser instanciados nessas sub-redes públicas.

### Fluxo de Dados:
1. Um recurso (por exemplo, uma instância EC2) criado em uma sub-rede pública recebe um **endereço IP público**.
2. A sub-rede direciona o tráfego externo pelo **Internet Gateway**.
3. O gateway garante que os recursos da VPC possam se comunicar com a Internet.

---

## 5. **Por que usar essa arquitetura?**

- **Escalabilidade:** Adiciona sub-redes automaticamente para todas as zonas de disponibilidade.
- **Conectividade:** Permite que recursos públicos, como servidores web, se comuniquem com usuários externos.
- **Organização:** A estrutura modular permite reutilizar e adaptar o código para outros projetos.
- **Automação:** A integração com o Terraform reduz erros manuais e facilita alterações futuras.

---

# Resumo
A arquitetura funciona como uma **rede personalizada** na AWS:
1. **VPC** para isolar e organizar a infraestrutura.
2. **Sub-redes públicas** para hospedar recursos acessíveis externamente.
3. **Internet Gateway** para garantir a conectividade externa.

Com esta configuração, é possível hospedar e gerenciar recursos de maneira segura, escalável e organizada.


</blockquote>
</details>

<details>
<summary> 
<b>Explicação Código Terraform</b>

</summary>

<blockquote>

# Explicação Detalhada dos Arquivos Terraform

A configuração do Terraform utiliza diversos arquivos para organizar e gerenciar uma infraestrutura na AWS. A seguir, cada arquivo é explicado em ordem de execução lógica, começando pelo `main.tf`.

---

## 1. `main.tf`
``` hcl
module "vpc" {
  source = "../VPC"
}
```

### O que faz?
- Este é o ponto de entrada do Terraform.
- **Módulo:** Invoca o módulo `vpc`, localizado no diretório `../VPC`.
  - Um módulo é um conjunto de configurações reutilizáveis.
- **Objetivo:** Organizar a infraestrutura, delegando a criação da VPC e seus componentes ao módulo.

---

## 2. `vars.tf`
``` hcl
data "aws_availability_zones" "available" {}

variable "project" {
  default = "fiap-lab"
}
variable "vpc_cidr" {
  default = "9.0.0.0/16"
}
variable "subnet_escale" {
  default = 6
}

variable "env" {
  default = "prod"
}

variable "AWS_REGION" {
  default = "us-east-1"
}
```

### O que faz?
- Define as **variáveis** usadas em outros arquivos:
  - `project`: Nome do projeto, usado em tags e identificadores.
  - `vpc_cidr`: Define o bloco de IPs da VPC (intervalo de endereços IP).
  - `subnet_escale`: Controla o tamanho das sub-redes.
  - `env`: Especifica o ambiente (`prod`, `dev`, etc.).
  - `AWS_REGION`: Define a região da AWS (padrão: `us-east-1`).
- O bloco `data "aws_availability_zones"` lista as zonas de disponibilidade para a região selecionada.

---

## 3. `vpc.tf`
``` hcl
resource "aws_vpc" "vpc_created" {
  cidr_block         = "${var.vpc_cidr}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.project}"
    env  = "${var.env}"
  }
}

resource "aws_subnet" "public_igw" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.vpc_created.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", "${var.subnet_escale}", count.index+1)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "${var.project}_public_igw_${data.aws_availability_zones.available.names[count.index]}"
    Tier = "Public"
    env  = "${var.env}"
  }
}
```

### O que faz?
1. **Criação da VPC:**
   - Configura uma Virtual Private Cloud (VPC) usando o bloco CIDR definido na variável `vpc_cidr`.
   - Habilita suporte a DNS e hostnames.

2. **Criação de Sub-redes Públicas:**
   - Gera uma sub-rede pública para cada zona de disponibilidade.
   - Cada sub-rede é configurada para:
     - Atribuir IPs públicos automaticamente.
     - Ser mapeada de forma dinâmica a partir do CIDR principal.

---

## 4. `igw.tf`
``` hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc_created.id}"

  tags = {
    Name = "igw-${var.project}"
    env  = "${var.env}"
  }
}
```

### O que faz?
- Cria um Internet Gateway (IGW) que conecta a VPC à Internet.
- **Associação:** Vincula o IGW à VPC criada no arquivo `vpc.tf`.

---

# Fluxo de Funcionamento

1. **Execução Inicial (`main.tf`):**
   - O Terraform inicia no arquivo `main.tf`, invocando o módulo `vpc`.
   - O módulo utiliza os demais arquivos (`vars.tf`, `vpc.tf`, `igw.tf`) para configurar os recursos.

2. **Definição da VPC (`vpc.tf`):**
   - Uma VPC é criada como a rede principal para todos os recursos.
   - Sub-redes públicas são geradas automaticamente em cada zona de disponibilidade.

3. **Conexão com a Internet (`igw.tf`):**
   - O Internet Gateway conecta as sub-redes públicas à Internet, permitindo tráfego de entrada e saída.

4. **Variáveis Compartilhadas (`vars.tf`):**
   - Controla as configurações principais, como bloco CIDR, região da AWS e ambiente.

---

# Benefícios dessa Organização

- **Modularidade:** Cada parte da infraestrutura é gerenciada separadamente, facilitando a manutenção e reutilização.
- **Escalabilidade:** Sub-redes são criadas dinamicamente para todas as zonas de disponibilidade.
- **Conexão Pública:** Recursos na VPC podem acessar e ser acessados pela Internet.
- **Automação:** Reduz erros manuais, permitindo a recriação rápida da infraestrutura.

Para mais informações, consulte a [documentação oficial do Terraform](https://developer.hashicorp.com/terraform).

</blockquote>
</details>

6. Após o termino vá ao painel da aws e confira se a VPC, subnets e Rotas foram [criadas](https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1#subnets:)

   ![vpc](images/vpccreated.png)
-------
   ![sub](images/subnetscreated.png)

7. Agora vamos subir as Route Tables. Para tal volte uma pasta com o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/02-Modules/` e entre em rt-call com o comando `cd RT-call/`
8. Execute o comando `terraform init`
9.  Execute o comando `terraform plan`
10. Execute o comando `terraform apply -auto-approve`
<details>
<summary> 
<b>Explicação Código Terraform</b>

</summary>

<blockquote>

### Explicação Detalhada do Código

#### **1. Arquivo `main.tf`**
O arquivo `main.tf` faz a chamada do módulo que gerencia as tabelas de rotas:

```hcl
module "routetable" {
  source = "../RouteTables"
}
```

**Explicação**:
- **`module`**: Chama o módulo `routetable` que está localizado no diretório `../RouteTables`.
- O módulo encapsula os recursos necessários para configurar a tabela de rotas.

#### **2. Arquivo `routetable.tf`**
Configura a tabela de rotas associada ao Internet Gateway:

```hcl
resource "aws_route_table" "to-igw" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "to-igw-${var.project}"
    env  = "${var.env}"
  }
}
```

**Explicação**:
- **`aws_route_table`**: Cria uma tabela de rotas chamada `to-igw`.
- **`route`**: Configura uma rota padrão (`0.0.0.0/0`) que direciona o tráfego ao Internet Gateway.
- **`tags`**: Adiciona tags ao recurso, como nome do projeto e ambiente.

#### **3. Arquivo `public.tf`**
Associa as sub-redes públicas à tabela de rotas:

```hcl
data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

resource "aws_route_table_association" "public_association" {
  for_each       = data.aws_subnet.public
  subnet_id      = "${each.value.id}"
  route_table_id = "${aws_route_table.to-igw.id}"
}
```

**Explicação**:
- **`aws_subnets`**: Busca as sub-redes na VPC com a tag `Tier=Public`.
- **`aws_route_table_association`**: Associa cada sub-rede pública à tabela de rotas `to-igw`.

#### **4. Arquivo `vars.tf`**
Define variáveis reutilizáveis para o projeto:

```hcl
variable "project" {
  default = "fiap-lab"
}

variable "env" {
  default = "prod"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}"
  }
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}
```

**Explicação**:
- **`variable`**: Define variáveis como o nome do projeto, ambiente e região AWS.
- **`data aws_vpc`**: Recupera informações da VPC usando o nome como filtro.
- **`data aws_internet_gateway`**: Busca o Internet Gateway associado à VPC.

---

Aqui está um diagrama para resumir o funcionamento:

```
+-----------------------------+
|          AWS VPC           |
|       (fiap-lab-prod)       |
|                             |
|  +-----------------------+  |
|  |    Public Subnet 1    |  |
|  +-----------------------+  |
|          . . .             |
|  +-----------------------+  |
|  |    Public Subnet N    |  |
|  +-----------------------+  |
|                             |
|  +-----------------------+  |
|  |    Route Table (to-igw) | |
|  |  --------------------   | |
|  |  Default Route:         | |
|  |  0.0.0.0/0 -> IGW       | |
|  +-----------------------+  |
|                             |
+-------------+---------------+
              |
              v
   +-----------------------+
   |  Internet Gateway     |
   |       (IGW)           |
   +-----------------------+
              |
              v
        Internet Access
```

Esse desenho reflete como os componentes estão conectados:
1. As sub-redes públicas associadas à tabela de rotas.
2. A tabela de rotas apontando para o Internet Gateway.
3. O acesso à internet configurado pela rota padrão.

</blockquote>
</details>

11.  Analise o código, olhe os resultados no painel do serviço VPC e faça questionamentos. Foi criada uma VPC com uma subnet publica para cada zona de disponibilidade e as rotas para um internet gateway também criado via código.
