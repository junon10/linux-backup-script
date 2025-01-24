#!/bin/bash

CONFIG_FILE=./backup_path.txt

if [ ! -f ${CONFIG_FILE} ]
then
  printf "ERROR: THE CONFIGURATION FILE '${CONFIG_FILE}' WAS NOT FOUND!\n\n"
  echo "Press [ENTER] to exit..."
  read
  exit
fi

source ${CONFIG_FILE}

app_version="v1.0.0.16"
app_date="2025/01/24"
app_author="Junon M."

separator() {
echo "--------------------------------------------------------------------------------"
}

app_title() {
echo "$(separator)"
echo " LINUX RSYNC BACKUP COPY ${app_version} - ${app_date} - by ${app_author}"
echo "$(separator)"
}

# Beep com alto-falante da placa mãe
# beep="echo -e \"\a\""

# Beep com placa de som
sound_finished="paplay ./Sounds/finished.ogg"
sound_error="paplay ./Sounds/error.ogg"

# Ex: Para tocar o som use:
# ${sound_finished}

clear
echo "$(app_title)"
echo ""
echo "START BACKUP FROM"
for i in ${!FROM_PATH[@]}
do
  # Exibe o caminho sem a barra final
  echo "${FROM_PATH[i]%/}"
done

echo ""
echo "TO"
for i in ${!TO_PATH[@]}
do
  # Exibe o caminho sem a barra final
  echo "${TO_PATH[i]%/}"
done
echo ""
echo "$(separator)"
echo ""
echo "Press [ENTER] to backup copy now, or [CTRL+C] to exit..."
read
echo "$(separator)"

# Data e Hora atual
formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

# Copia o caminho de origem, removendo a barra do final
from_path="${FROM_PATH[j]%/}"

# Obtém o nome da última subpasta
last_subfolder="${from_path##*/}"

  # Loop for para as unidades externas
  for i in ${!TO_PATH[@]}
  do

    # Verifica se o destino existe e tenta criar as pastas
    if [ ! -d ${TO_PATH[i]} ]; then 
      printf "\nERROR: THE PATH '${TO_PATH[i]%/}'\nDOES NOT EXIST!\nTRY TO CREATE...\n"
      mkdir -p "${TO_PATH[i]%/}" 
    fi

    # Verifica se foi possível criar
    if [ -d ${TO_PATH[i]} ]; then 

      # Copia o caminho de destino, removendo a barra do final
      to_path="${TO_PATH[i]%/}"
      mkdir -p ${to_path}      
    
      # Diretório onde será salvo o arquivo de log
      log_path="${TO_PATH[i]}/log"
      mkdir -p "${log_path}"

      # Nome do arquivo de log
      log_file="${log_path}/daily-backup.log"

      # Nome do arquivo de log detalhado
      log_path_details="${log_path}/${last_subfolder}"
      mkdir -p "${log_path_details}"

      log_file_details="${log_path_details}/${formated_date}-details.log"   

      printf "BACKUP STARTED '${formated_date}'\n" >> "${log_file}"
      printf "\nBACKUP STARTED '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"

      if rsync -a --progress --delete "${from_path}" "${to_path}" | tee -a "${log_file_details}"; then
        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)      
        printf "BACKUP SUCCESS '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP SUCCESS '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"
      else
        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
        printf "BACKUP COPY ERROR '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP COPY ERROR '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"
        ${sound_error} 
      fi
      
      echo "$(separator)" | tee -a "${log_file_details}"     

    else # Impossível criar o caminho
      printf "\nERROR: THE PATH '${TO_PATH[i]%/}' DOES NOT EXISTS!\n\nIMPOSSIBLE TO CREATE!\n\n"  
    fi # end - Verifica se foi possível criar

  done
done

printf "\nDONE\n\n"
printf "Press [ENTER] to exit...\n"
${sound_finished}
read
