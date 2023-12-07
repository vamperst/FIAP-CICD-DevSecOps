
1. Execute o comando `cd ~/environment/FIAP-CICD-DevSecOps/02-Terraform/demos/05-Workspaces/` para entrar na pasta do exercicío.
2. tilize o comando `c9 open state.tf` para abrir o arquivo responsavel por configurar o estado remoto e adicione o do seu bucket S3 na linha 3. Caso não se lembre o nome do bucket execute o comando `aws s3 ls`.
3. Execute o comando `terraform init` para inicializar o terraform. Caso tenha dado erro porque o nome do bucket esta incorreto você terá que reconfigurar o estado remoto com o comando `terraform init -reconfigure`.
4. Crie um novo workspace com o comando `terraform workspace new dev`
5. Crie outro workspace com o comando `terraform workspace new prod`
6. Para voltar ao ambiente dev execute `terraform workspace select dev`
7. Para listar todos os workspaces execute `terraform workspace list`, note que um workspace default esta listado ele é criado pelo terraform automaticamente.
   ![](images/workspacescommands.png)
8. Rode o apply (`terraform apply -auto-approve`) com cada um dos ambiente e note que serão gerados arquivos diferentes para cada workspaces dentro da pasta 'modules'. Para trocar de ambiente utilize o comando `terraform workspace select NOMEDAWORKSPACE`.
9.  Se for no Bucket verá que foi criada uma estrutura de pastas para os workspaces que criou. E dentro das pastas prod e dev tem um arquivo 'workspaces' que é o estado do workspace em questão.
10. De volta ao terminal execute um comando `ls modules/file/*.txt`, vai ver para para cada apply que fez foi criado um arquivo para o workspace.
11. No workspace 'prod' execute o comando `terraform destroy -auto-approve`.
12. Verifique o arquivo txt do prod não esta mais na pasta mas o dev esta intacto.
13. Olhe no arquivo referente ao ambiente prod no bucket do S3, ao ler o mesmo irá notar que esta vazio, tamanho pequeno, mas não foi excluido. 

### Exercicio
Caso deseje fazer um exercicio prático para ajudar a fixar o conteudo faça o proposto na seguinte página: [Exercício](../../exercicios/State-e-workspace/README.md)