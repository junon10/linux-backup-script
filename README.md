<h2>Linux Backup Script</h2>

<h2>Descrição</h2>

<p>Script de backup para Linux, com opções de backup espelhado (mirror) e incremental.<br>
Desenvolvido por Junon M.</p>

<h2>Requisitos</h2>

<p>
- Sistema operacional: Linux<br>
- Sistema de Arquivos: ext4, btrfs<br>
- Nota: o Backup espelhado (sync) também funciona no sistema NTFS para cópia de arquivos comuns, isto é, sem arquivos do sistema Linux.</p>
 
<h2>Instalação</h2>

<p>
<br>
- Clone o repositório.<br>

- É recomendado criptografar o SSD ou Flash-Drive de destino com LUKS, e definir uma senha forte que só você conheça.<br>

- Para (Sync Backup) copie os scripts (make_backup.sh), (restore_backup.sh) e o arquivo de configuração (backup_path.txt) para o diretório raiz da unidade de armazenamento de destino, em seguida crie uma pasta de backup escolhida dentro da unidade.<br> 

- Para (Incremental Backup) copie o script (make_incremental_backup.sh) e o arquivo de configuração (inc_backup_path.txt) para o diretório raiz da unidade de armazenamento de destino, em seguida crie uma pasta de backup escolhida dentro da unidade.<br> 

- Configure as variáveis no arquivo de configuração (backup_path.txt) ou (inc_backup_path.txt).<br>

- Escolha qual dos scripts você vai usar, o Sync Backup(make_backup.sh) ou incremental (make_incremental_backup.sh), pois cada um deles criará suas próprias cópias das suas pastas, duplicando o espaço utilizado no disco de destino.<br>

- A primeira cópia de backup será completa (demorada), mas as seguintes serão bem mais rápidas por copiar somente os arquivos modificados desde o último backup.</p>

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
<br>
- Ainda não existe script de restauração para o backup incremental.<br>

- Nomes de arquivos inválidos podem causar falha no backup.<br>

- Não podem ser feitos backups de arquivos do sistema Linux para uma partição Windows (NTFS, EXFAT, FAT32, ou FAT) porque causa erros, sempre use sistemas de arquivos Linux por exemplo ext4 ou btrfs. No entanto você ainda pode usar um sistema de arquivos NTFS para copiar os seus documentos com sync backup(espelhado).</p>

- Evite mudar o username da sua conta linux, pois as referências dos backups utilizam links simbólicos com os caminhos completos, que podem criar um novo backup, duplicando o espaço usado. Esta limitação será removida futuramente com novas atualizações. 

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
