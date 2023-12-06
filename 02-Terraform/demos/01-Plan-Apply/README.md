1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/01-Plan-Apply/` para entrar na pasta do exercício.
2. Entre na pasta EC2 `cd EC2`
3. Execute o comando `terraform init`
   ![init](images/terraforminit.png)
4. Agora execute um `terraform plan` para ver o que será executado.
   ![plan](images/plan.png)
5. Agora execute um `terraform apply -auto-approve` para que sejam criados os recursos na AWS.
    
    ![apply](images/apply.png)
    ![apply](images/apply-2.png)
6. Vá até o painel [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) para ver o recurso criados. Você verá que o recurso foi criado sem nome e que já tem uma maquina do cloud9 rodando.
    ![awspainelec2](images/painelec21.png)
7. Execute o comando `terraform destroy -auto-approve` para destruir os recursos criados.
   ![destroy](images/Destroy.png)
8.  Se for ao painel verá que o recurso realmente não esta mais lá
   ![ec22](images/painelec22.png)
9.  Agora saia dessa pasta com o comando `cd ..`
10. Enter na pasta EC2-ssh com o comando `cd EC2-ssh`
11. Nesse exemplo voce utilizará a chave fiap-lab que criou. Para iniciar o processo execute o comando `terraform init`.
12. Este exemplo irá criar maquinas ec2 e acessar as mesmas para instalar Nginx. Para planejar execute o comando `terraform plan`
13. Antes de executar o apply, abra uma aba no seu navegador e vá para o [painel do EC2 na AWS](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:).
14. No menu lateral esquerdo, clique em 'Security Groups' 
    ![](images/painelec2.png)
15. Selecione o Security Group que tem 'default' na coluna Group Name. Vá a aba `Regras de entrada` e clique em 'Editar regras de entrada' na lateral direita
    ![](images/sgpainel.png)
16. Apague todas as regras existentes e adicione uma regra que irá liberar `Todo o tráfego` para `Qualquer Local-IpV4` como na imagem abaixo e clique em `Salvar Regras`
    ![](images/anywhere.png)
17. Se tudo estiver certo execute o comando `terraform apply -auto-approve` no terminal do Cloud9 que estava antes.
18. Quando o trabalho for concluido com sucesso, você pode pegar o dns da maquina criada que esta no final outputs do terraform e colocar no navegar que irá ser exibida uma pagina inicial do Nginx.
    ![](images/apply-3.png)
    ![nginx](images/nginxworks.png)
19. Por fim execute `terraform destroy -auto-approve`
20. Se certifique que o destroy funcionou indo no [painel do EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:v=3) e verificando que não tem mais nenhuma maquina rodando.
    ![ec22](images/painelec22.png)