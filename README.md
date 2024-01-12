# Info:

`Title:` Folder Sync Backup Script.

`Operational System:` Linux

`File System:` Linux and Windows

`Author:` Junon M.

`Version:` 1.0.0.2

`Date:` 2024/01/10

`Language:` PT-BR

# Description: 

O script de Espelhamento(Mirroring) roda em qualquer sistema de arquivos, no entanto, o script de backup Incremental funciona apenas em sistemas de arquivos linux, como por exemplo o ext4. 

Após a primeira cópia somente as diferenças são adicionadas com as duas variações de script, garantindo uma alta velocidade de backup.

`Incremental MARK_FOLDER:`
No backup Incremental deve ser criada manualmente uma pasta (MARK_FOLDER) que será reconhecida pelo script, que neste caso é a pasta de nome 'bkp', mas poderá ser qualquer outro nome à sua escolha, desde que não contenha espaços, como por exemplo:
TO_PATH_ARR[0]="bkp/FOLDER_NAME"

`Mirroring MARK_FOLDER:`
No backup por espelhamento a pasta (MARK_FOLDER) está localizada em:
EXTERNAL_STORAGE[0]="/media/$USER/DISK_NAME1/Mirror"
Que neste caso tem o nome de Mirror, mas poderá ser qualquer 
outro nome desde que não contenha espaços.

`NOTE:` Apenas o backup por espelhamento possui script de restauração automática que recria todas as pastas após formatação. No backup incremental as pastas devem ser restauradas manualmente com a data e hora desejadas.
Não esqueça dos índices que devem ser adicionados aos arrays com os paths de origem(FROM_PATH_ARR), de destino(TO_PATH_ARR), e de unidades externas(EXTERNAL_STORAGE).


