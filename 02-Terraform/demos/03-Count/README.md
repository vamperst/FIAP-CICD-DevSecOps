1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/03-Count/` para entrar no diretório do exercício.
2. Execute o comando `terraform init`
3. Execute o comando `terraform apply -auto-approve`

<details>
<summary> 
<b>Explicação Código Terraform</b>

</summary>

<blockquote>

Aqui está uma explicação da ordem de execução dos arquivos `.tf`, detalhando o fluxo de trabalho do Terraform e como os recursos são criados com base no seu código:

---

### **1. `variables.tf`**

Este arquivo define as variáveis que serão usadas em outros arquivos do Terraform. É a base para parametrizar o código, permitindo flexibilidade sem alterar diretamente os arquivos principais.

**Exemplo do arquivo:**
```hcl
variable "instance_count" {
  description = "Number of EC2 instances"
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}
```

**Execução:**
- Carrega os valores padrão ou os valores fornecidos pelo usuário no momento da execução.
- Esses valores são usados em outros arquivos para configurar recursos dinamicamente.

---

### **2. `securitygroup.tf`**

Este arquivo cria um grupo de segurança para gerenciar regras de firewall de entrada e saída, garantindo acesso seguro às instâncias EC2.

**Exemplo do arquivo:**
```hcl
resource "aws_security_group" "web" {
  name_prefix = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Execução:**
- Este recurso é criado antes das instâncias EC2, pois é necessário definir regras de segurança que serão associadas às instâncias.
- Permite tráfego HTTP (porta 80) e todo o tráfego de saída.

---

### **3. `main.tf`**

Este é o arquivo principal que configura os recursos da AWS, como instâncias EC2. Ele faz referência ao grupo de segurança criado anteriormente e utiliza as variáveis definidas em `variables.tf`.

**Exemplo do arquivo:**
```hcl
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web.name]

  tags = {
    Name = "WebServer-${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "bash script.sh"
    ]
  }
}
```

**Execução:**
- Cria as instâncias EC2 com base nos valores de `variables.tf`.
- Associa o grupo de segurança criado em `securitygroup.tf`.
- O `provisioner` usa o script `script.sh` para instalar e configurar o NGINX nas instâncias criadas.

---

### **4. `script.sh`**

Este script é executado nas instâncias EC2 durante a criação para instalar e iniciar o servidor NGINX.

**Conteúdo do script:**
```bash
#!/bin/bash

# Instalação do NGINX
sudo yum update -y
sudo amazon-linux-extras list | grep nginx
sudo yum clean metadata -y
sudo yum -y install nginx -y
sudo amazon-linux-extras install nginx1 -y

# Inicialização do NGINX
sudo systemctl start nginx
```

**Execução:**
- É invocado pelo `provisioner` definido no `main.tf`.
- Realiza atualizações no sistema, instala o NGINX e garante que ele seja iniciado.

---

### **Ordem de Execução Completa**

1. **Carregamento de variáveis (`variables.tf`)**
   - Define os valores necessários para os recursos.

2. **Criação do grupo de segurança (`securitygroup.tf`)**
   - Configura as regras de acesso para as instâncias.

3. **Criação das instâncias EC2 (`main.tf`)**
   - Usa as variáveis e associa o grupo de segurança.
   - Configura o script para provisionar as instâncias.

4. **Execução do script (`script.sh`)**
   - Instala e configura o NGINX nas instâncias criadas.

</blockquote>
</details>


5. Aguarde alguns minutos para que todas as maquinas estejam prontas no ELB e o script terraform termine com sucesso. Após o termino no [painel](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancer:loadBalancerArn=terraform-example-elb;tab=targetInstances) note que o ELB estará com todas as maquinas em estado `Fora de serviço`.

<details>
<summary> 
<b>Explicação Tempo de demora para inserir instância EC2 no ALB</b>

</summary>

<blockquote>

Quando você adiciona uma instância EC2 a um Application Load Balancer (ALB) da AWS, pode levar alguns instantes para que ela fique disponível para acesso. Isso ocorre devido a vários fatores e processos que acontecem nos bastidores. Vamos explorar as principais razões:

## Registro do Alvo

Ao adicionar uma instância EC2 ao ALB, ela é registrada como um alvo em um [grupo de destino](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html). O ALB precisa de tempo para reconhecer o novo alvo e incluí-lo em seu processo de roteamento.

## Verificações de Integridade

O ALB realiza [verificações de integridade](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html) nos alvos registrados para garantir que estejam prontos para receber tráfego. Essas verificações incluem:

1. Tentativas de conexão com a instância EC2
2. Verificação da resposta da aplicação
3. Avaliação do status de saúde com base nas respostas recebidas

O ALB só começará a enviar tráfego para a instância quando ela passar nas verificações de integridade.

## Propagação de DNS

O ALB utiliza um [nome DNS](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#load-balancer-dns-name) para distribuir o tráfego. Quando uma nova instância é adicionada, pode haver um breve período para que as atualizações de DNS se propaguem, permitindo que o tráfego seja roteado para o novo alvo.

## Warm-up Time

Para evitar sobrecarregar novas instâncias, o ALB implementa um período de [warm-up](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#target-group-attributes) durante o qual o tráfego é gradualmente aumentado para o novo alvo.

## Considerações de Rede

Se a instância EC2 estiver em uma VPC diferente ou tiver configurações de segurança específicas, pode haver um tempo adicional para estabelecer as conexões de rede necessárias.

Esses processos garantem que o ALB distribua o tráfego apenas para instâncias saudáveis e prontas, melhorando a confiabilidade e o desempenho geral do sistema. Embora isso possa causar um pequeno atraso na disponibilidade, é crucial para manter a integridade e a eficácia do balanceamento de carga.

</blockquote>
</details>

   ![still](images/stillinregistration.png)

6. Aguarde até que todas estejam em `Em serviço`.

   ![inservice](images/inservice2.png)

7. Utilize o dns do ELB fornecido como saida no terraform no cloud9 para colar no navegador e testar o funcionamento da Stack

   ![dnsc9](images/dnsc9.png)

   ![nginx1](images/nginx1.png)

8. Abra o arquivo main.tf com o comando `c9 open main.tf` e altere o valor do count para 3 na linha 67.

   ![countmod](images/countmod.png)

9. Execute o comando `terraform plan` para verificar o que será alterado. Note que tem 1 item para adicionar e 1 para alterar. O item para adicionar é a nova maquina e o item para alterar é o ELB que terá que adicionar a nova maquina.

   ![plan](images/plan.png)

10. Execute novamente o comando `terraform apply -auto-approve`

   ![apply2](images/apply2.png)

11. Note no [painel da AWS](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancer:loadBalancerArn=terraform-example-elb;tab=targetInstances) que a maquina foi criada e já colocado no ELB

   ![inservice3](images/inservice3.png)

12. Vá novamente até o arquivo `main.tf` e altere o valor do count para 1

      ![countmod2](images/countmod3.png)

13. Execute novamente o comando `terraform apply -auto-approve`

    ![countmod2](images/countmod2.png)

14. Dessa vez no [painel da AWS](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancer:loadBalancerArn=terraform-example-elb;tab=targetInstances) foram 2 destruições de maquina e uma alteração no ELB

    ![service1](images/inservice1.png)

15. Execute o comando `terraform destroy -auto-approve`


### Exercicio
Caso deseje fazer um exercicio prático para ajudar a fixar o conteudo faça o proposto na seguinte página: [Exercício](../../exercicios/count/README.md)
