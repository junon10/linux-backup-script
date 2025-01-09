#!/bin/bash

CONFIG_FILE=./backup_path.txt

if [ ! -f ${CONFIG_FILE} ]
then
  echo "[ERROR] THE CONFIGURATION FILE:" 
  echo "'${CONFIG_FILE}'"
  echo "WAS NOT FOUND!"
  echo ""
  echo "Press [ENTER] to exit..."
  read
  exit
fi

source ${CONFIG_FILE}

app_version="v1.0.0.11"
app_date="2025/01/08"
app_author="Junon M."

separator() {
echo "--------------------------------------------------------------------------------"
}

app_title() {
echo "$(separator)"
echo "         LINUX SYNC BACKUP ${app_version} - ${app_date} - by ${app_author}"
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
echo "[START BACKUP FROM]"
for i in ${!FROM_PATH[@]}
do
  # Exibe o caminho sem a barra final
  echo "${FROM_PATH[i]%/}"
done

echo ""
echo "[TO]"
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
formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)

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
    # Verifica se está montado
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

      printf "BACKUP FROM '${from_path}'\nSTARTED ON [$formated_date]\n" >> $log_file
      echo ""
      echo "[BACKUP FROM] '${from_path}'" 
      echo "[STARTED ON] ${formated_date}"
      echo "[TO] '${to_path}'"
      echo ""

      if rsync -a --progress --delete "${from_path}" "${to_path}" | tee ${log_file_details}; then
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A) 
        printf "DONE ON [$formated_date]\n\n" >> $log_file
        echo "DONE" >> ${log_file_details}
        echo ""        
        echo "[BACKUP SUCCESS FROM] '${from_path}'" 
        echo "[TO] '${to_path}'"
        echo ""
      else
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)
        printf "BACKUP COPY ERROR ON [$formated_date]\n\n" >> $log_file
        echo "BACKUP COPY ERROR" >> ${log_file_details}
        echo ""
        echo "[BACKUP COPY ERROR FROM] '${from_path}'" 
        echo "[TO] '${to_path}'"
        echo ""
        ${sound_error} 
      fi
    else
      echo "[ERROR] THE PATH:"
      echo "'${TO_PATH[i]}'"
      echo "DOES NOT EXIST!"
      echo ""
    fi
    echo "$(separator)"
  done
done

echo ""
echo "[DONE]"
echo ""
echo "Press [ENTER] to exit..."
echo ""
${sound_finished}
read
