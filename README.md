<h2>Linux Backup Script</h2>
<h3>Operational System:</h3> Linux
<h3>File System:</h3> Linux and Windows
<h3>Author:</h3> Junon M
<h3>Version:</h3> 1.0.0.3
<h3>Date:</h3> 2024/02/24

<h3>Description:</h3> 
<p>The Mirroring script runs on any file system, however, the Incremental backup script only works on Linux file systems, such as ext4. After the first copy only the differences are added with the two script variations, ensuring a high backup speed. Both script variations generate very detailed logs on the target drive.</p>
<h3>NOTES:</h3>
<p>Only mirror backup has an automatic restore script that recreates all folders after formatting. In incremental backup, folders must be restored manually with the desired date and time.</p>
<p>These Scripts have been tested for a long time, sometimes restoration was necessary and there was no loss of files.</p>
<p>Be careful with invalid file names, they make the backup fail!</p>

<hr>

<h3>Mirror Backup Example file:</h3> 
<h3>backup_path.inc</h3> 
<br/>
# FROM_PATH_ARR[n] Backup source directory (without slash at the end)
<br/>
# TO_PATH_ARR[n] Backup destination directories (without slash at the beginning and end)
<br/>
# EXTERNAL_STORAGE[n] Target external drives (without slash at the end)
<br/><br/>
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

<hr>

<h3> Incremental Backup Example File: </h3> 
<h3>inc_backup_path.inc</h3>
<br/>
# FROM_PATH_ARR[n] Backup source directory (without slash at the end)
<br/>
# TO_PATH_ARR[n] Backup destination directories (without slash at the end, and without white spaces)
<br/>
# EXTERNAL_STORAGE[n] Target external drives (without slash at the end)
<br/><br/>
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
<hr>
