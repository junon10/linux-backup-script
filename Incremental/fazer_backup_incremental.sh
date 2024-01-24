#!/bin/bash

CONFIG_FILE=./inc_backup_path.inc

if [ ! -f ${CONFIG_FILE} ]
then
  echo "Erro: O arquivo de configuração:" 
  echo "'${CONFIG_FILE}'"
  echo "não foi encontrado!"
  echo ""
  echo "Tecle [ENTER] para sair..."
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
echo "App:......Backup Incremental rápido com rsync (sem criptografia)"
echo "Date:.....2024/01/23" 
echo "Version:..1.0.0.3"
echo "Author:...Junon M."
echo ""
echo "Iniciando backup de:"
for i in ${!FROM_PATH_ARR[@]}
do
  echo "${FROM_PATH_ARR[i]}"
done
echo ""
echo "Para:"
for i in ${!EXTERNAL_STORAGE[@]}
do
  echo "${EXTERNAL_STORAGE[i]}"
done
echo ""
echo "Tecle [ENTER] para continuar, ou [CTRL+C] para sair..."
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
      echo "Fazendo backup em ${to_full_path}..."

      if rsync -a --progress --out-format='%n' --delete "${from_path}" --link-dest "${latest_link}" --exclude=".cache" "${to_full_path}" | tee ${log_file_details}; then
        
        rm -rf "${latest_link}"
        ln -s "${to_full_path}" "${latest_link}"
        
        printf "[$formated_date] BACKUP SUCCESS.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "BACKUP SUCCESS" >> ${log_file_details}
        echo "Backup concluído com sucesso em ${to_full_path}"
      else
        printf "[$formated_date] BACKUP COPY ERROR.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "BACKUP COPY ERROR" >> ${log_file_details}
        echo "Erro ao copiar para ${to_full_path}"
        echo ""
        echo "Pressione [ENTER] para sair"
        echo ""
        read
        ${sound_error}
        exit 1
      fi
    fi
  done
done

echo ""
echo "Tecle [ENTER] para sair..."
echo ""
${sound_finished}
read
