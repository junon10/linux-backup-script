#-------------------------------------------------------------------------------------------------------
# Incremental Backup
#-------------------------------------------------------------------------------------------------------

# FROM_PATH_ARR[n] Diretório de origem do backup (sem barra no final)
# TO_PATH_ARR[n] Diretórios de destino do backup (sem barra no final, e sem espaços em branco)
# EXTERNAL_STORAGE[n] Unidades externas de destino do backup (sem barra no final)

#-------------------------------------------------------------------------------------------------------

FROM_PATH_ARR[0]="/media/$USER/DISK_NAME/FOLDER_NAME"
TO_PATH_ARR[0]="bkp/FOLDER_NAME"

FROM_PATH_ARR[1]="/home/$USER/Documents"
TO_PATH_ARR[1]="bkp/Documents"

#-------------------------------------------------------------------------------------------------------

# Unidades externas de destino do backup (sem barra no final)
EXTERNAL_STORAGE[0]="/media/$USER/Samsung128GB"

#-------------------------------------------------------------------------------------------------------

