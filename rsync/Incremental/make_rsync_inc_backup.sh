#!/bin/bash

CONFIG_FILE=./inc_backup_path.txt

if [ ! -f ${CONFIG_FILE} ]
then
  printf "ERROR: THE CONFIGURATION FILE '${CONFIG_FILE}' WAS NOT FOUND!\n\n"
  echo "Press [ENTER] to exit..."
  read
  exit
fi

source ${CONFIG_FILE}

app_version="v1.0.0.18"
app_date="2025/03/19"
app_author="Junon M."

separator() {
echo "--------------------------------------------------------------------------------"
}

app_title() {
echo "$(separator)"
echo " LINUX RSYNC INCREMENTAL BACKUP COPY ${app_version} - ${app_date} - by ${app_author}"
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
    echo "BACKUP HISTORY: ${DAY_LIMIT} day(s)"
  else
    echo "ERROR: INVALID DAY_LIMIT VARIABLE, ASSUMPTION AS 7 DAYS!"
    DAY_LIMIT=7
  fi
else
    echo "ERROR: INDEFINED DAY_LIMIT VARIABLE, ASSUMPTION AS 7 DAYS!"
    DAY_LIMIT=7
fi

echo ""
echo "START BACKUP FROM"
for i in ${!FROM_PATH[@]}
do
  # Mostra sem a barra final %/
  echo "${FROM_PATH[i]%/}"
done
echo ""
echo "TO"
for i in ${!TO_PATH[@]}
do
  # Mostra sem a barra final %/
  echo "${TO_PATH[i]%/}"
done
echo ""
echo "$(separator)"
printf "\nStarting in 7 second(s), or press [CTRL+C] to exit..."
sleep 7
printf "\n\n"
echo "$(separator)"

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
      
      # Copia o caminho de destino, removendo a barra do final,
      # e adicionando o nome do último subdiretório.
      to_path="${TO_PATH[i]%/}/${last_subfolder}"
      mkdir -p "${to_path}" # Faz a árvore de subdiretórios.
      
      # Caminho completo com a data e hora do backup.
      to_full_path="${to_path}/${formated_date}"
  
      # Diretório onde será salvo o arquivo de log.
      log_path="${to_path}/Backup-log"
      mkdir -p "${log_path}" # Faz a árvore de subdiretórios.

      # Caminho completo e nome do arquivo de log
      log_file="${log_path}/daily-backup.log"

      # Caminho completo e nome do segundo arquivo de log (detalhado)
      log_file_details="${log_path}/${formated_date}-details.log"

      # Caminho (Link) para a pasta de backup mais atual
      latest_link="${to_path}/latest"

      printf "BACKUP STARTED '${formated_date}'\n" >> "${log_file}"
      printf "\nBACKUP STARTED '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"

      if rsync -a --progress --out-format='%n' --delete "${from_path}" --link-dest "${latest_link}" --exclude=".cache" "${to_full_path}" | tee -a ${log_file_details}; then
        
        rm -rf "${latest_link}"

        # Com caminho completo
        # ln -s "${to_full_path}" "${latest_link}"

        # Obtém o caminho relativo, pegando a última subpasta.
        link="${latest_link##*/}" 
        relative_path="${to_full_path##*/}"

        # Obtém o path incial.
        initial_path=$(pwd)        

        # Entra no caminho de destino.
        cd "${to_path}"

        # Cria um link com caminho relativo.
        ln -s ./"${relative_path}" ./"${link}"

        # Retorna ao path inicial.
        cd "${initial_path}"

        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
        printf "BACKUP SUCCESS '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP SUCCESS '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"
       
        # -mmin=minutos (DEBUG)
        #echo "LIMITING HISTORY TO ${DAY_LIMIT} minute(s)..."
        #find "${to_path}" -maxdepth 1 -type d -mmin +"${DAY_LIMIT}" -exec rm -rf {} \;

        # -mtime=dias
        echo "LIMITING HISTORY TO ${DAY_LIMIT} day(s)..."
        find "${to_path}" -maxdepth 1 -type d -mtime +"${DAY_LIMIT}" -exec rm -rf {} \;
        echo ""
      else # else rsync
        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
        printf "BACKUP COPY ERROR '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP COPY ERROR '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"
        echo ""
        echo "Press [ENTER] to exit..."
        read
        ${sound_error}
        exit 1
      fi # end rsync

      echo "$(separator)" | tee -a "${log_file_details}"

    else # else - Impossível criar caminho
      printf "\nERROR: THE PATH '${TO_PATH[i]}' DOES NOT EXISTS!\n\nIMPOSSIBLE TO CREATE!\n\n"
    fi # end - Verifica se foi possível criar

  done
done

printf "\nDONE\n\n"
${sound_finished}
printf "\n\n"

