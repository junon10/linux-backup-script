#!/bin/bash

CONFIG_FILE=./inc_backup_path.inc

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
echo "App:......Fast Incremental Backup with rsync (no encryption)"
echo "Date:.....2024/01/23" 
echo "Version:..1.0.0.4"
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

# formato do arquivo
formated_date=$(date +%Y-%m-%d_%H-%M-%S-%A)

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
      
      to_full_path="${to_path}/${formated_date}"
      
      mkdir -p "${to_path}"      
    
      # Diretório onde será salvo o arquivo de log
      log_path="${to_path}/log"
      mkdir -p "${log_path}"

      # Nome do arquivo de log
      log_file="${log_path}/daily-backup.log"

      log_file_details="${log_path}/${formated_date}-details.log"

      latest_link="${EXTERNAL_STORAGE[i]}/${TO_PATH_ARR[j]}/latest"

      echo ""
      echo "Backing up to ${to_full_path}..."

      if rsync -a --progress --out-format='%n' --delete "${from_path}" --link-dest "${latest_link}" --exclude=".cache" "${to_full_path}" | tee ${log_file_details}; then
        
        rm -rf "${latest_link}"
        ln -s "${to_full_path}" "${latest_link}"
        
        printf "[$formated_date] backup success.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "backup success." >> ${log_file_details}
        echo "backup success to ${to_full_path}"
      else
        printf "[$formated_date] BACKUP COPY ERROR.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "BACKUP COPY ERROR." >> ${log_file_details}
        echo "BACKUP COPY ERROR TO ${to_full_path}"
        echo ""
        echo "Press [ENTER] to exit..."
        echo ""
        read
        ${sound_error}
        exit 1
      fi
    fi
  done
done

echo ""
echo "Press [ENTER] to exit..."
echo ""
${sound_finished}
read
