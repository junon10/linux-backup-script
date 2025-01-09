<h2>Linux Backup Script</h2>

<h2>Descrição</h2>

<p>Script de backup para Linux, com opções de backup espelhado (mirror) e incremental.<br>
Desenvolvido por Junon M.</p>

<h2>Requisitos</h2>

<p>
- Sistema operacional: Linux<br>
- Sistema de Arquivos: ext4, btrfs<br>
- Nota: o Backup espelhado (sync) também funciona no<br> 
sistema NTFS para cópia de arquivos comuns, isto é,<br> 
sem arquivos do sistema Linux.</p>
 
<h2>Instalação</h2>

<p>
1. Clone o repositório.<br>

2. É recomendado criptografar o SSD ou Flash-Drive de<br> 
destino com LUKS, e definir uma senha forte que só você conheça.<br>

3. Para (Sync Backup) copie os scripts (make_backup.sh),<br>
(restore_backup.sh) e o arquivo de configuração (backup_path.txt)<br> 
para o diretório raiz da unidade de armazenamento de destino,<br>
em seguida crie uma pasta de backup escolhida dentro da unidade.<br> 

4. Para (Incremental Backup) copie o script<br> 
(make_incremental_backup.sh) e o arquivo de<br> 
configuração (inc_backup_path.txt) para o diretório<br> 
raiz da unidade de armazenamento de destino,<br> 
em seguida crie uma pasta de backup escolhida<br> 
dentro da unidade.<br> 

5. Configure as variáveis no arquivo de<br>
configuração (backup_path.txt) ou (inc_backup_path.txt).<br>

6. Escolha qual dos scripts você vai usar, o<br> 
Sync Backup(make_backup.sh) ou incremental<br>
(make_incremental_backup.sh), pois cada um deles<br> 
criará suas próprias cópias das suas pastas,<br> 
duplicando o espaço utilizado no disco de destino.<br>

7. A primeira cópia de backup será completa (demorada),<br>
mas as seguintes serão bem mais rápidas por copiar somente<br> 
os arquivos modificados desde o último backup.

<h2>Configuração</h2>

<h3>Mirror Backup</h3>

<p>
- FROM_PATH: caminho da pasta para backup<br>
- TO_PATH: caminho da pasta de destino</p>

<p>Exemplo (backup_path.txt):</p>

<p>bash<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder1")<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder2")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup1")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup2")</p>

<h3>Incremental Backup</h3>

<p>
- FROM_PATH: caminho da pasta para backup<br>
- TO_PATH: caminho da pasta de destino<br>
- DAY_LIMIT: número de dias para manter backups</p>

<p>Exemplo (inc_backup_path.txt):</p>

<p>bash<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder1")<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder2")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Incremental_Backup1")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Incremental_Backup2")<br>
DAY_LIMIT=7</p>

<h2>Uso</h2>

<p>bash<br>
./make_incremental_backup.sh<br>
./make_backup.sh<br>
./restore_backup.sh</p>

<h2>Log e Restauração</h2>

<p>
- Logs detalhados no diretório de destino.<br>
- Restauração automática disponível apenas para backup espelhado.</p>

<h2>Limitações</h2>

<p>
- Restauração manual necessária para backup incremental.<br>
- Nomes de arquivos inválidos podem causar falha no backup.<br>
- Não podem ser feitos backups de arquivos do sistema Linux<br> 
para uma partição NTFS, porque pode causar perda de dados,<br> 
sempre use ext4 ou btrfs.</p>

<h2>Changelog</h2>

<p>2025/01/05 - 1.0.0.9<br>
- Simplificação de parâmetros.<br>
- Adicionada função para manter apenas os backups mais recentes<br>
- Reorganização de código</p>

<p>2025/01/08 - 1.0.0.10<br>
- Melhoria na disposição, destaque e limpeza das mensagens no terminal</p>

<p>2025/01/08 - 1.0.0.11<br>
- Melhoria na formatação das mensagens</p>

<h2>Contribuição</h2>

<p>Contribuições são bem-vindas!<br>
Envie um pull request com suas melhorias</p>
