# 01 - Setup e Configuração de ambiente


 1. Abra o console da AWS e va para o serviço `Cloud 9`.
   ![img/acharcloud9.png](img/acharcloud9.png)
1. garanta que a região que esta utilizando é `us-east-1/ Norte da Virgínia`. Você consegue ver isso no canto superior direiro da tela.
    ![img/regiao.png](img/regiao.png)
 2. Clique em `create environment`.
 3. Coloque o nome `lab-fiap` e avance.
 ![img/nomelab.png](img/nomelab.png)
 5. Deixe as configurações como na imagem a seguir. Se atente ao tipo da maquina que deve ser t2.medium:
![img/config.png](img/config.png)
 6. Caso os parametros estejam como na imagem a seguir clique em `Create Environment`
   ![img/review.png](img/review.png)
 7. A criação do ambiente pode levar alguns minutos.
![img/criando.png](img/criando.png)
 8. Após a criação clique em `abrir IDE`, caso o IDE não tenha aberto automaticamente.
   ![img/abriride.png](img/abriride.png)
9. Para os próximos comandos utilize o console bash que fica no canto inferior do seu IDE.
   ![img/bash.png](img/bash.png)
10. Execute o comando `npm install -g serverless` para instalar o serverless framework.
    ![img/installserverless.png](img/installserverless.png)
11. Execute o comando `sudo apt update -y && sudo apt  install jq -y` para instalar o software que irá nos ajudar a ler e manipular Jsons no terminal
12. Execute o comando `npm install -g c9` para baixar a extenãp que ajudará o Cloud9 a lidar melhor com o como abrir arquivos no IDE.
13. Execute o comando `git clone https://github.com/vamperst/FIAP-CICD-DevSecOps.git` para clonar o repositório com os exercicios.
14. Execute o comando `cd FIAP-CICD-DevSecOps/` para entrar na pasta criada pelo git
15. Execute o comando `cd 00-Setup-e-configuracao` para entrar na pasta com os scripts de Configuração.
16. Precisamos aumentar o tamanho do volume(HD) do cloud9. Para isso execute o comando  `sh resize.sh`
   ![img/resizeEBS](img/resizeEBS.png)
16. Para facilitar a criação e updates manualmente das stacks do cloudformation vamos utilizar o plugin 'cfn-create-or-update'. Para instalr utilize o comando `npm install -g cfn-create-or-update`
17. Para instalar o docker execute o comando `curl -sSL https://get.docker.com/ | sudo sh`
18. O docker daemon precisa de permissão para aceitar comandos do usuario padrão. O comando `sudo usermod -aG docker ubuntu` adiciona o usuário principal da mauqina a utilizar o Docker.
19. Agora vamos criar o Bucket S3 que irá receber todos os arquivos de configuração durante o curso. Para tal, abra uma aba do console AWS. Clique em serviços no canto superior esquerdo e pesquisa e clique em S3.
20. Clique em 'Criar bucket'
    ![](img/s3CreateBucket.png)
21. De o nome do bucket de `base-config-<SEU RM>` e clique em `Criar`.
    ![](img/createBucket.png)
22. Em outra aba do AWS Academy onde acessa a conta da AWS e no canto superior direito clique em 'AWS Details' e clique em 'show' nos campos de SSH Key.
![](img/academy-pem-1.png)
23. Copie o conteudo da chave privada para a area de transferência(Ctrl+C).
    ![](img/academy-pem-2.png)
24. Execute o comando `c9 open ~/.ssh/vockey.pem` para criar o arquivo que utilizaremos como chave para entrar nas instancias. 
25. Cole o conteudo da chave privada copiado nos passos anteriores e cole no ide no aquivo vockey.pem e salve utilizando "ctrl+S".
26.  Execute o comando `chmod 400 ~/.ssh/vockey.pem` para que a chave tenha a permissão correta.
27.  Execute o comando `aws s3 cp ~/.ssh/vockey.pem s3://base-config-<SEU RM>/instance-need/keys/` para copiar a chave que criou para o seu bucket de configurações do S3.
28. Execute o comando a seguir para instalar o terraform `sh installTerraform.sh`
