# Info:

## Folder Sync Backup Script

## Operational System: Linux

## File System: Linux and Windows

## Author: Junon M

## Version: 1.0.0.3

## Date: 2024/02/24

# Description: 
The Mirroring script runs on any file system, however, the Incremental backup script only works on Linux file systems, such as ext4. After the first copy only the differences are added with the two script variations, ensuring a high backup speed. Both script variations generate very detailed logs on the target drive.
## NOTE: 
Only mirror backup has an automatic restore script that recreates all folders after formatting. In incremental backup, folders must be restored manually with the desired date and time.
<br/>
These Scripts have been tested for a long time, sometimes restoration was necessary and there was no loss of files.
<br/>
Be careful with invalid file names, they make the backup fail!
<br/>
---------------------------------------------------
<br/>
## Backup_path.inc example file:
<br/>
## FROM_PATH_ARR[n] Backup source directory (without slash at the end)
<br/>
## TO_PATH_ARR[n] Backup destination directories (without slash at the beginning and end)
<br/>
## EXTERNAL_STORAGE[n] Target external drives (without slash at the end)
<br/>
FROM_PATH_ARR[0]="/home/$USER/Documentos/Contas"
<br/>
TO_PATH_ARR[0]="Contas"
<br/><br/>
FROM_PATH_ARR[1]="/media/$USER/KINGSTON_1TB/Docs"
<br/>
TO_PATH_ARR[1]="Docs"
<br/><br/>
FROM_PATH_ARR[2]="/media/$USER/KINGSTON_1TB/Games/Salvos"
<br/>
TO_PATH_ARR[2]="Games"
<br/><br/>
EXTERNAL_STORAGE[0]="/media/$USER/HD_WD_4TB/Mirror"
<br/>
EXTERNAL_STORAGE[1]="/media/$USER/SAM_1TB_2/Mirror"
<br/>
---------------------------------------------------
<br/>
# inc_backup_path.inc example file:
<br/>
## Incremental Backup
<br/>
## FROM_PATH_ARR[n] Backup source directory (without slash at the end)
<br/>
## TO_PATH_ARR[n] Backup destination directories (without slash at the end, and without white spaces)
<br/>
## EXTERNAL_STORAGE[n] Target external drives (without slash at the end)
<br/>
FROM_PATH_ARR[0]="/media/$USER/KINGSTON_1TB/Docs/Develop"
<br/>
TO_PATH_ARR[0]="bkp/Develop"
<br/><br/>
FROM_PATH_ARR[1]="/media/$USER/KINGSTON_1TB/Docs/AndroidStudioProjects"
<br/>
TO_PATH_ARR[1]="bkp/AndroidStudioProjects"
<br/><br/>
FROM_PATH_ARR[2]="/media/$USER/KINGSTON_1TB/Instalados/ESP-IDF/Projects"
<br/>
TO_PATH_ARR[2]="bkp/ESP-IDF"
<br/><br/>
FROM_PATH_ARR[3]="/media/$USER/KINGSTON_1TB/Instalados/STM32CubeIDE"
<br/>
TO_PATH_ARR[3]="bkp/STM32CubeIDE"
<br/><br/>
EXTERNAL_STORAGE[0]="/media/$USER/Sam128GB"
<br/>
---------------------------------------------------


