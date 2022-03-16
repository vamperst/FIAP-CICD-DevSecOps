1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/03-Count/` para entrar no diretório do exercício.
2. Execute o comando `terraform init`
3. Execute o comando `terraform apply -auto-approve`
4. Aguarde alguns minutos para que todas as maquinas estejam prontas no ELB. Para chegar até o painel de Load Balancers, entre no serviço EC2 e no menu esquerdo escolha 'Load Balancers'
   ![still](images/stillinregistration.png)
5. Quando estiverem todas prontas estarão como na imagem
   ![inservice](images/inservice2.png)
6. Utilize o dns do ELB fornecido como saida no terraform para colar no navegador e testar o funcoinamento da Stack
   ![nginx1](images/nginx1.png)
7. Agora vá até o arquivo `main.tf`(Hybrid-e-native-cloud-tutorial/02-Terraform/demos/Count) pelo IDE e altere o valor do count para 3
   ![countmod](images/countmod.png)
8. Execute novamente o comando `terraform apply -auto-approve`
   ![apply2](images/apply2.png)
9.  Note no painel da AWS que a maquina foi criada e já colocado no ELB
   ![inservice3](images/inservice3.png)
11. Vá novamente até o arquivo `main.tf` e altere o valor do count para 1
12. Execute novamente o comando `terraform apply -auto-approve`
    ![countmod2](images/countmod2.png)
13. Dessa vez foram 2 destruições de maquina e uma alteração no ELB
    ![service1](images/inservice1.png)
14. Execute o comando `terraform destroy -auto-approve`


### Exercicio
Caso deseje fazer um exercicio prático para ajudar a fixar o conteudo faça o proposto na seguinte página: [Exercício](../../exercicios/count/README.md)