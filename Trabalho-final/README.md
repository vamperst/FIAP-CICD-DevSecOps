# Exercicio Terraform

Utilize o código da demo Count e faça as seguintes mudanças:

1. Mude os arquivos para que os arquivos virem um módulo que recebe a quantidade de nós no load balancer
2. Monte o arquivo que chama o módulo recem criado.
3. Adicione estado remoto no S3 no arquivo que chama os módulos.
4. Os nomes das maquinas devem ser de acordo com o ambiente do workspace. Ex: nginx-workspace-002
5. O nome do ELB e do Securitygroup também devem conter o workspace
6. Crie um ambiente de dev e um de prod
7. Faça um zip dos arquivos desse exercicio e submeta no portal da fiap.


#### Ajuda
1. [How to create modules](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d)
2. [Modules Composition](https://www.terraform.io/docs/modules/composition.html)
3. [Creating Modules](https://www.terraform.io/docs/modules/index.html)
4. [AWS datasources](https://www.terraform.io/docs/providers/aws/d/instances.html)