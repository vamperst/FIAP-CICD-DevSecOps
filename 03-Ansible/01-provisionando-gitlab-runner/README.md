1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/` para entrar na pasta principal do repositório e então execute o comando `git reset --hard && git pull origin master` para garantir que esta com a versão mais atualizada do exercicio.'.
2. Para entrar na pasta do exercicio execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/03-Ansible/01-provisionando-gitlab-runner/`.
3. Primeiramente é necessário instalar o ansible além de atualizar o python e utilizar virtual env. Para tal vamos utilizar a sequência de comandos abaixo.
```bash

#Atualizando o python para 3.8
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.8 -y
python3.8 --version
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
python --version

#Instalando Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y

#Instalando pip3
sudo apt-get -y install python3-pip -y

#Instalando e utilizando virtualEnv
sudo pip3 install virtualenv
python3 -m venv ~/venv 
source ~/venv/bin/activate
```

4. Antes de excutar os scripts para criação do runner do gitlab é necessário criar uma conta no serviço. Caso já tenha, apenas faça o login. [GITLAB](https://gitlab.com/).
5. Para conseguir fazer os commits para o gitlab você irá precisar criar uma chave de conexão. Para tal siga os passos:
   1. Vá ao terminal do Cloud9 e utilize o seguinte comando para criar a chave:
   ```shell
    ssh-keygen -t rsa -b 2048 -C "gitlab key" -f /home/ubuntu/.ssh/gitlab
   ```
   2. Pressione enter duas vezes para sinalizar que não quer senha para a chave
   ![](img/gitlab-1.png)
   3. Abre a parte publica da sua chave no IDE do cloud9 com o comando `c9 open /home/ubuntu/.ssh/gitlab.pub` e copie o conteúdo para a área de transferência do seu computador.
   4. Acesse o link da configuração de chaves do seu gitlab: [Chaves Gitlab](https://gitlab.com/-/profile/keys)
   5. Cole o conteúdo copiado no campo destacado e clique em `Add Key`
   ![](img/gitlab-2.png)
   6. Devolta ao terminal do cloud9 exetuce os comandos abaixo para ativar a chave na sessão de terminal que esta utilizando:
   ```shell
    eval $(ssh-agent -s) 
    ssh-add -k /home/ubuntu/.ssh/gitlab
   ```
6. Vamos criar um primeiro projeto no gitlab. Para isso acesse o [link](https://gitlab.com/projects/new). Clique em `Create Blank Projet`.
7. De o nome de `primeiro-projeto` ao projeto. Marque como `Public` e desmarque a opção de inicializar com README. 
   ![](img/gitlab-3.png)
8. Clique em `Create project`
9. De volta ao Cloud9 você vai subir o código desse primeiro projeto no gitlab. Para isso siga os comandos abaixo tomando o cuidado com os pontos onde precisa colocar suas informações
```bash
git config --global user.name "SEU NOME"
git config --global user.email "SEU EMAIL DO GITLAB"

#Copia o código para outra pasta para que possa criar outro repo git
cp -frv /home/ubuntu/environment/FIAP-CICD-DevSecOps/03-Ansible/01-provisionando-gitlab-runner/primeiro-projeto/ ~/environment/

cd /home/ubuntu/environment/primeiro-projeto

git init
git remote add origin git@gitlab.com:SEU-USUARIO/primeiro-projeto.git
git add .
git commit -m "Initial commit"
git push -u origin master
```
![](img/gitlab-4.png)
![](img/gitlab-5.png)

10. No seu repositório do gitlab clique em settings na lateral esquerda e então clique em `CI/CD`
    ![](img/gitlab-6.png)
11. Em `Runners` clique em `Expand`
    ![](img/gitlab-7.png)
12. Desabilite a opção `Enable shared runners for this project` 
    ![](img/gitlab-8.png)
13. Copie o token e mantenha na área de transferência.
    ![](img/gitlab-9.png)
14. De volta ao cloud9 você vai colar o token do gitlab no arquivo ansible que registra o runner. Para tal execute o comando `c9 open ~/environment/FIAP-CICD-DevSecOps/03-Ansible/01-provisionando-gitlab-runner/ansible-gitlab-runner/tasks/register-runner.yml` e altere a linha 48. Não esqueça de salvar.
15. O runner do gitlab será uma EC2 que será provisionada com terraform. Para entrar na pasta com o código execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/03-Ansible/01-provisionando-gitlab-runner/terraform-gitlab-runner/`
16. Atualize o estado remoto do repositório para utilizar um bucket S3 disponivel na sua conta. Abra o arquivo com `c9 open state.tf`
17. Agora que já alterou o bucket e salvou. Execute o comando `terraform init`
18. Verifique o que será criado com o comando `terraform plan`
19. Execute o `terraform apply --auto-approve` para subir a maquina que será o runner. lembrando que esse script executa alguns comandos na maquina criada para preprar tudo para que o ansible consiga executar no host criado.
20. Execute o comando `terraform output ec2_dns` para copiar o ip publico da instancia para a área de transferência.
    ![](img/gitlab-11.png)
21. Agora entre na pasta onde vai executar o ansible. Para isso utilize o comando `cd ~/environment/FIAP-CICD-DevSecOps/03-Ansible/01-provisionando-gitlab-runner/ansible-gitlab-runner/`
22. Utilize o comando `c9 open hosts` para abrir o arquivo onde é configurado quais maquinas e como serão acessadas pelo ansible. Altere adicionando o IP publico da instancia criada no local indicado.
    ![](img/gitlab-12.png)
23. Execute o comando abaixo para executar o ansible que vai configurar o EC2 como gitlab runner:
``` shell
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u 'ubuntu' -i hosts  --extra-vars 'gitlab_runner_name=gitlab-runner-fleet-001' play.yaml    
```
![](img/gitlab-14.png)
22. Se voltar a mesma página do gitlab onde pegou o token notará que agora tem um runner registrado.
![](img/gitlab-13.png)
