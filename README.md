## Linux Backup Script

## Descrição

- Script de backup para Linux, com opções de backup espelhado (mirror) e incremental.<br>
Desenvolvido por Junon M.<br>

## Requisitos

- Sistema operacional: Linux.<br>
- Sistema de Arquivos: ext4, btrfs.<br>
- Nota: o Backup espelhado (sync) também funciona no sistema NTFS para cópia de arquivos comuns, isto é, sem arquivos do sistema Linux.<br>
 
## Instalação

- Clone o repositório.<br>

- É recomendado criptografar o SSD ou Flash-Drive de destino com LUKS, e definir uma senha forte que só você conheça.<br>

- Para (Sync Backup) copie os scripts (make_backup.sh), (restore_backup.sh) e o arquivo de configuração (backup_path.txt) para o diretório raiz da unidade de armazenamento de destino, em seguida crie uma pasta de backup escolhida dentro da unidade.<br> 

- Para (Incremental Backup) copie o script (make_incremental_backup.sh) e o arquivo de configuração (inc_backup_path.txt) para o diretório raiz da unidade de armazenamento de destino, em seguida crie uma pasta de backup escolhida dentro da unidade.<br> 

- Configure as variáveis no arquivo de configuração (backup_path.txt) ou (inc_backup_path.txt).<br>

- Escolha qual dos scripts você vai usar, o Sync Backup(make_backup.sh) ou incremental (make_incremental_backup.sh), pois cada um deles criará suas próprias cópias das suas pastas, duplicando o espaço utilizado no disco de destino.<br>

- A primeira cópia de backup será completa (demorada), mas as seguintes serão bem mais rápidas por copiar somente os arquivos modificados desde o último backup.<br>

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
- DAY_LIMIT: número de dias para manter backups<br>

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
- Assistente de restauração por script disponível apenas para backup espelhado, para a restauração de backups incrementais é necessário escolher a pasta com a data específica e copiar para seu sistema<br>

- Nomes de arquivos inválidos podem causar erros no backup.<br>

- Não podem ser feitos backups de arquivos do sistema Linux para uma partição Windows (NTFS, EXFAT, FAT32, ou FAT) porque causa erros, sempre use sistemas de arquivos Linux por exemplo ext4 ou btrfs. No entanto você ainda pode usar um sistema de arquivos NTFS para copiar os seus documentos com sync backup(espelhado).<br>

- Evite mudar o username da sua conta linux, pois as referências dos backups utilizam links simbólicos com os caminhos completos. Esta limitação será removida futuramente com novas atualizações.<br> 

## Log de Alterações

### 2025/01/05 - 1.0.0.9
- Simplificação de parâmetros.<br>
- Adicionada função para manter apenas os backups mais recentes<br>
- Reorganização de código<br>

### 2025/01/08 - 1.0.0.10
- Melhoria na disposição, destaque e limpeza das mensagens no terminal<br>

### 2025/01/08 - 1.0.0.11
- Melhoria na formatação das mensagens<br>

### 2025/01/13 - 1.0.0.12
- Melhoria nos logs e mensagens<br>
- Novos scripts de Backup incremental e restauração com o comando TAR<br>

### 2025/01/13 - 1.0.0.13
- Correção do script (make_rsync_inc_backup.sh) de links completos para links relativos<br>

## Repositório
[https://github.com/junon10/linux-backup-script](https://github.com/junon10/linux-backup-script)

## Contribuição

- Contribuições são bem-vindas! Envie um pull request com suas melhorias.<br>
