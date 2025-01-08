<h2>Linux Backup Script</h2>

<h2>Descrição</h2>

<p>Script de backup para Linux, com opções de backup espelhado (mirror) e incremental.<br>
Desenvolvido por Junon M.</p>

<h2>Requisitos</h2>

<p>- Sistema operacional: Linux<br>
- File system: ext4 (para backup incremental)</p>

<h2>Instalação</h2>

<p>1. Clone o repositório.<br>
2. Configure as variáveis no arquivo de configuração.</p>

<h2>Configuração</h2>

<h3>Mirror Backup</h3>

<p>- FROM_PATH: caminho da pasta para backup<br>
- TO_PATH: caminho da pasta de destino</p>

<p>Exemplo (backup_path.txt):</p>

<p>bash<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder1")<br>
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder2")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup1")<br>
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup2")</p>

<h3>Incremental Backup</h3>

<p>- FROM_PATH: caminho da pasta para backup<br>
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
./make_incremental_backup.sh<br><br>
./make_backup.sh<br>
./restore_backup.sh</p>

<h2>Log e Restauração</h2>

<p>- Logs detalhados no diretório de destino.<br>
- Restauração automática disponível apenas para backup espelhado.</p>

<h2>Limitações</h2>

<p>- Restauração manual necessária para backup incremental.<br>
- Nomes de arquivos inválidos podem causar falha no backup.</p>

<h2>Changelog</h2>

<p>2025/01/05 - 1.0.0.9<br>
- Simplificação de parâmetros.
- Adicionada função para manter apenas os backups mais recentes<br>
- Reorganização de código</p>

<p>2025/01/08 - 1.0.0.10<br>
- Melhoria na disposição, destaque e limpeza das mensagens no terminal</p>

<h2>Contribuição</h2>

<p>Contribuições são bem-vindas!<br>
Envie um pull request com suas melhorias</p>
