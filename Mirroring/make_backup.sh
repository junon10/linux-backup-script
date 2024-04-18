#!/bin/bash

CONFIG_FILE=./backup_path.inc

if [ ! -f ${CONFIG_FILE} ]
then
  echo "Error: The configuration file:" 
  echo "'${CONFIG_FILE}'"
  echo "was not found!"
  echo ""
  echo "Press [ENTER] to exit..."
  read
  exit
fi

source ${CONFIG_FILE}

# Beep com alto-falante da placa mãe
# beep="echo -e \"\a\""

# Beep com placa de som
sound_finished="paplay ./Sounds/finished.ogg"
sound_error="paplay ./Sounds/error.ogg"

# Ex: Para tocar o som use:
# ${sound_finished}

echo ""
echo "App:......Mirroring with rsync (without encryption)"
echo "Date:.....2024/04/18" 
echo "Version:..1.0.0.6"
echo "Author:...Junon M."
echo ""
echo "Starting backup from:"
for i in ${!FROM_PATH_ARR[@]}
do
  echo "${FROM_PATH_ARR[i]}"
done
echo ""
echo "To:"
for i in ${!EXTERNAL_STORAGE[@]}
do
  echo "${EXTERNAL_STORAGE[i]}"
done
echo ""
echo "Press [ENTER] to continue, or [CTRL+C] to exit..."
echo ""
read

#-----------------------------------------------------------------------------------------------------

# Data e Hora atual
formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH_ARR[@]}
do
from_path="${FROM_PATH_ARR[j]}/"

  # Loop for para as unidades externas
  for i in ${!EXTERNAL_STORAGE[@]}
  do
    # Verifica se está montado
    if [ -d ${EXTERNAL_STORAGE[i]} ]; then 
      
      to_path="${EXTERNAL_STORAGE[i]}/${TO_PATH_ARR[j]}"
      mkdir -p ${to_path}      
    
      # Diretório onde será salvo o arquivo de log
      log_path="${EXTERNAL_STORAGE[i]}/log"
      mkdir -p "${log_path}"

      # Nome do arquivo de log
      log_file="${log_path}/daily-backup.log"

      # Nome do arquivo de log detalhado
      log_path_details="${log_path}/${TO_PATH_ARR[j]}"
      mkdir -p "${log_path_details}"

      log_file_details="${log_path_details}/${formated_date}-details.log"   

      printf "Backup from '${from_path}'\nstarted on [$formated_date]\n" >> $log_file
      echo ""
      echo "Backup from '${from_path}'" 
      echo "started on ${formated_date}"
      echo "to '${to_path}'"

      if rsync -a --progress --delete ${from_path} ${to_path} | tee ${log_file_details}; then
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A) 
        printf "successfully completed on [$formated_date]\n\n" >> $log_file
        echo "successfully completed!"
        echo "successfully completed!" >> ${log_file_details}
        echo ""
      else
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)
        printf "BACKUP COPY ERROR ON [$formated_date]\n\n" >> $log_file
        echo "BACKUP COPY ERROR!"
        echo "BACKUP COPY ERROR!" >> ${log_file_details}
        echo ""
        ${sound_error} 
      fi
    else
      echo "ERROR: DISK UNIT '${EXTERNAL_STORAGE[i]}' NOT MOUNTED!"
      echo ""
    fi
  done
done

echo ""
echo "Press [ENTER] to exit..."
echo ""
${sound_finished}
read
