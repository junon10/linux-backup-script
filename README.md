## Linux Backup Script

## Descrição

- Script de backup para Linux, com opções de backup espelhado (mirror) e incremental.<br>
Desenvolvido por Junon M.<br>

## Requisitos

- Sistema operacional: Linux.<br>
- Sistema de Arquivos: ext4, btrfs.<br>
- Nota: o Backup espelhado (sync) também funciona no sistema NTFS para cópia de arquivos comuns, isto é, sem arquivos do sistema Linux.<br>
 
## Instalação

1. Clone o repositório.<br>

2. É recomendado criptografar o Flash-Drive de destino com LUKS, e definir uma senha forte que só você conheça.<br>

3. Escolha quais conjuntos de scripts você vai usar, pois existem 3 tipos diferentes (4, 5, e 6), que não devem ser usados ao mesmo tempo, devido a problemas de aumento de espaço no disco de destino.<br>

4. Rsync Mirror Backup - copie os scripts (make_rsync_backup.sh), (restore_rsync_backup.sh) e o arquivo de configuração (backup_path.txt) para a unidade de destino.<br> 

5. Rsync Incremental Backup - copie o script (make_rsync_inc_backup.sh) e o arquivo de configuração (inc_backup_path.txt) para a unidade de destino.<br> 

6. Tar Incremental Backup - copie os scripts (make_tar_backup.sh), (restore_tar_backup.sh) e o arquivo de configuração (inc_backup_path.txt) para a unidade de destino.<br> 

7. Configure as variáveis no arquivo de configuração (backup_path.txt) ou (inc_backup_path.txt) referenciando o destino dos backups. É necessário criar apenas a última subpasta, o restante do caminho será criado automaticamente.<br>

8. A primeira cópia de backup será completa (demorada), mas as seguintes serão bem mais rápidas por copiar somente os arquivos modificados desde o último backup.<br>

## Configuração

<h3>Mirror Backup</h3>

- FROM_PATH: caminho da pasta para backup<br>
- TO_PATH: caminho da pasta de destino<br>

<p>Exemplo (backup_path.txt):</p>

```bash
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder")
TO_PATH+=("/home/$USER/Backup_Test/To/Mirror_Backup")
```

<h3>Incremental Backup</h3>

- FROM_PATH: caminho da pasta para backup<br>
- TO_PATH: caminho da pasta de destino<br>
- DAY_LIMIT: número de dias para manter backups (válido para backups com rsync)<br>

<p>Exemplo (inc_backup_path.txt):</p>

```bash
FROM_PATH+=("/home/$USER/Backup_Test/From/Folder")
TO_PATH+=("/home/$USER/Backup_Test/To/Incremental_Backup")
DAY_LIMIT=7
```

## Uso

```bash
# Faz Backup incremental com RSYNC
./make_rsync_inc_backup.sh

# Faz Backup espelho com RSYNC
./make_rsync_backup.sh

# Restaura Backup espelho com RSYNC
./restore_rsync_backup.sh

# Faz Backup incremental com TAR
./make_tar_inc_backup.sh

# Restaura Backup incremental com TAR
./restore_tar_inc_backup.sh

```

## Vantagens
- Logs detalhados no diretório de destino.<br>

## Limitações
- Assistente de restauração por script não disponível para backup incremental com rsync.<br>

- Nomes de arquivos inválidos podem causar erros no backup.<br>

- Não podem ser feitos backups de arquivos do sistema Linux para uma partição Windows (NTFS, EXFAT, FAT32, ou FAT) porque causa erros, use sempre sistemas de arquivos Linux por exemplo ext4 ou btrfs. No entanto você ainda pode usar um sistema de arquivos NTFS para copiar os seus documentos com Sync Backup(espelhado). O formato TAR não possui essas limitações.<br>

- O backup TAR não remove arquivos com nomes diferentes que por ventura sejam deletados na origem.<br>

## Log de Alterações

### v1.0.0.9 2025/01/05
- Simplificação de parâmetros.<br>
- Adicionada função para manter apenas os backups mais recentes<br>
- Reorganização de código<br>

### v1.0.0.10 2025/01/08
- Melhoria na disposição, destaque e limpeza das mensagens no terminal<br>

### v1.0.0.11 2025/01/08
- Melhoria na formatação das mensagens<br>

### v1.0.0.12 2025/01/13
- Melhoria nos logs e mensagens<br>
- Novos scripts de Backup incremental e restauração com o comando TAR<br>

### v1.0.0.13 2025/01/13
- Correção do script (make_rsync_inc_backup.sh) de links completos para links relativos<br>

## Repositório
[https://github.com/junon10/linux-backup-script](https://github.com/junon10/linux-backup-script)

## Contribuição

- Contribuições são bem-vindas! Envie um pull request com suas melhorias.<br>
