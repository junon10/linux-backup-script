#!/bin/bash

CONFIG_FILE=./inc_backup_path.txt

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


separator() {
echo "--------------------------------------------------------------------------------"
}


app_version="v1.0.0.11"
app_date="2025/01/08"
app_author="Junon M."

app_title() {
echo "$(separator)"
echo "         LINUX INCREMENTAL BACKUP ${app_version} - ${app_date} - by ${app_author}"
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


if [ -v DAY_LIMIT ]; then
  # Verifica se a data limite de backup é válida
  if [ $DAY_LIMIT -gt 0 ] && [ $DAY_LIMIT -lt 90 ]; then
    echo "[DAY_LIMIT] ${DAY_LIMIT} day(s)"
  else
    echo "[ERROR] INVALID DAY_LIMIT VARIABLE, ASSUMPTION AS 7 DAYS!"
    DAY_LIMIT=7
  fi
else
    echo "[ERROR] INDEFINED DAY_LIMIT VARIABLE, ASSUMPTION AS 7 DAYS!"
    DAY_LIMIT=7
fi

echo ""
echo "[START BACKUP FROM]"
for i in ${!FROM_PATH[@]}
do
  # Mostra sem a barra final %/
  echo "${FROM_PATH[i]%/}"
done
echo ""
echo "[TO]"
for i in ${!TO_PATH[@]}
do
  # Mostra sem a barra final %/
  echo "${TO_PATH[i]%/}"
done
echo ""
echo "$(separator)"
echo ""
echo "Press [ENTER] to continue, or [CTRL+C] to exit..."
echo ""
read

# formato do arquivo
formated_date=$(date +%Y-%m-%d_%H-%M-%S-%A)

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
      
      # Copia o caminho de destino, removendo a barra do final,
      # e adicionando o nome do último subdiretório.
      to_path="${TO_PATH[i]%/}/${last_subfolder}"
      mkdir -p "${to_path}" # Faz a árvore de subdiretórios.
      
      # Caminho completo com a data e hora do backup.
      to_full_path="${to_path}/${formated_date}"
  
      # Diretório onde será salvo o arquivo de log.
      log_path="${to_path}/log"
      mkdir -p "${log_path}" # Faz a árvore de subdiretórios.

      # Caminho completo e nome do arquivo de log
      log_file="${log_path}/daily-backup.log"

      # Caminho completo e nome do segundo arquivo de log (detalhado)
      log_file_details="${log_path}/${formated_date}-details.log"

      # Caminho (Link) para a pasta de backup mais atual
      latest_link="${to_path}/latest"

      echo "[BACKING UP FROM]"
      echo "'${from_path}'"
      echo ""
      echo "[TO]"
      echo "'${to_full_path}'"
      echo ""

      if rsync -a --progress --out-format='%n' --delete "${from_path}" --link-dest "${latest_link}" --exclude=".cache" "${to_full_path}" | tee ${log_file_details}; then
        
        rm -rf "${latest_link}"
        ln -s "${to_full_path}" "${latest_link}"
        
        printf "[$formated_date] BACKUP SUCCESS.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "BACKUP SUCCESS." >> ${log_file_details}
        echo ""
        echo "[BACKUP SUCCESS FROM]"
        echo "'${from_path}'"
        echo ""
        echo "[TO]"
        echo "'${to_full_path}'"
        echo ""

        # -mmin=minutos (DEBUG)
        #echo "Deleting backups older than ${DAY_LIMIT} minute(s)..."
        #find "${to_path}" -maxdepth 1 -type d -mmin +"${DAY_LIMIT}" -exec rm -rf {} \;

        # -mtime=dias
        echo "[KEEPING BACKUPS WITH LESS THAN ${DAY_LIMIT} DAY(S) OLD...]"
        find "${to_path}" -maxdepth 1 -type d -mtime +"${DAY_LIMIT}" -exec rm -rf {} \;
        echo ""
        echo "$(separator)"
        echo ""
        #echo ""
      else
        printf "[$formated_date] BACKUP COPY ERROR.\n" >> $log_file
        echo "" >> ${log_file_details}        
        echo "BACKUP COPY ERROR." >> ${log_file_details}
        echo "[BACKUP COPY ERROR FROM]"
        echo "'${from_path}'"
        echo ""
        echo "[TO]"
        echo "'${to_full_path}'"
        echo ""
        echo "$(separator)"
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

echo "[DONE]"
echo ""
echo "Press [ENTER] to exit..."
echo ""
${sound_finished}
read
