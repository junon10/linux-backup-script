#!/bin/bash

install_directory="/home/$USER/Installed/backup-app"

config_file=./backup.conf
if [ ! -f ${config_file} ]
then
  printf "ERROR: THE CONFIGURATION FILE '${config_file}' NOT FOUND!\n\n"
  echo "Press [ENTER] to exit..."
  read
  exit
fi
source ${config_file}

version_file="${install_directory}/version.info"
if [ ! -f ${version_file} ]
then
  printf "ERROR: THE FILE '${version_file}' NOT FOUND!\n\n"
  echo "Press [ENTER] to exit..."
  read
  exit
fi
source ${version_file}

# beep="echo -e \"\a\""
sound_finished="${install_directory}/media/finished.ogg"
sound_error="${install_directory}/media/error.ogg"

if [ ! -v BACKUP_TYPE ]; then
  echo "ERROR: BACKUP_TYPE not found in '${config_file}'"
  echo "Press [ENTER] to exit..."
  read
  exit 1
fi

is_remote_host() {
  local path=$1
  if [[ $path =~ ^[a-zA-Z0-9_]+@[a-zA-Z0-9_.-]+: ]]; then
    return 0
  else
    return 1
  fi
}

print_separator() {
  local len=${1:-80}
  printf "%*s\n" $len "" | tr ' ' '-'
}

print_app_title() {
 local title=$1
  print_separator
  echo " ${title} ${app_version} - ${app_date} - by ${app_author}"
  print_separator
}

play_sound() {
  local path=$1
  if [ -f "${path}" ]; then
    paplay "${path}"
  else
    echo "WARNING: Sound file ${path} not found!"
  fi
}

copy() {
  local from=$1
  local to=$2 
  if is_remote_host "${from}" || is_remote_host "${to}"; then
    args=(-avz -e ssh)
  else
    args=(-avz)
  fi 
  rsync "${args[@]}" "${from}" "${to}"
}






if [ $BACKUP_TYPE == 1 ]; then

APP_TITLE="RSYNC MIRROR BACKUP"

# Ex: Para tocar o som use:
# play_sound "${sound_finished}"

clear
print_app_title "${APP_TITLE}"
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
print_separator
printf "\nStarting in 5 second(s), or press [CTRL+C] to exit..."
sleep 5
printf "\n\n"
print_separator

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
    # Copia o caminho de destino, removendo a barra do final
    to_path="${TO_PATH[i]%/}"
     
    local_log_path1=./"Backup-log"
    local_log_path2="${local_log_path1}/${last_subfolder}"
    mkdir -p "${local_log_path2}" 
    local_log_file1="${local_log_path1}/daily-backup.log"
    local_log_file2="${local_log_path2}/${formated_date}-details.log"  
     
    remote_log_path="${to_path}/Backup-log" 

    printf "\n" | tee -a "${local_log_file2}"
    printf "BACKUP STARTED '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n" | tee -a "${local_log_file1}" "${local_log_file2}"
    printf "\n" | tee -a "${local_log_file2}"
    
    if is_remote_host "${from_path}" || is_remote_host "${to_path}"; then
      echo "remote host transfer"
      args=(-a --progress --delete --mkpath -e ssh)
    else
      echo "local host transfer"
      args=(-a --progress --delete --mkpath)
    fi 
    echo "rsync args: ${args[@]}"

    if ! is_remote_host "${to_path}"; then
      if [ ! -d "${to_path}" ]; then
        mkdir -p "${to_path}"
      fi
    fi
     
    set -o pipefail
    if rsync "${args[@]}" "${from_path}" "${to_path}" | tee -a "${local_log_file2}"; then
      # rsync success
      formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
      printf "\n" | tee -a "${local_log_file2}"
      printf "BACKUP SUCCESS '${formated_date}'\n\n" >> "${local_log_file1}"
      printf "BACKUP SUCCESS '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${local_log_file2}"
    else
      # rsync fail
      formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
      printf "\n" | tee -a "${local_log_file2}"
      printf "BACKUP COPY ERROR '${formated_date}'\n\n" >> "${local_log_file1}"
      printf "BACKUP COPY ERROR '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${local_log_file2}"
      play_sound "${sound_error}"
    fi    
   
    print_separator | tee -a "${local_log_file2}"     
    copy "${local_log_path1}/" "${remote_log_path}"
  done
done

printf "\nDONE\n\n"
play_sound "${sound_finished}"
printf "\n\n"







elif [ $BACKUP_TYPE == 2 ]; then

APP_TITLE="RSYNC INCREMENTAL BACKUP"

clear
print_app_title "${APP_TITLE}"
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
print_separator
printf "\nStarting in 5 second(s), or press [CTRL+C] to exit..."
sleep 5
printf "\n\n"
print_separator

formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

  if is_remote_host "${FROM_PATH[j]}"; then
    echo "ERROR: Remote backup not supported! Jumping directory..."
    continue
  fi 

  # Copia o caminho de origem, removendo a barra do final
  from_path="${FROM_PATH[j]%/}"

  # Obtém o nome da última subpasta
  last_subfolder="${from_path##*/}"

  # Loop for para as unidades externas
  for i in ${!TO_PATH[@]}
  do

    if is_remote_host "${TO_PATH[i]}"; then
      echo "ERROR: Remote backup not supported! Jumping directory..."
      continue
    fi 

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

      set -o pipefail
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
        play_sound "${sound_error}"
        exit 1
      fi # end rsync

      print_separator | tee -a "${log_file_details}"

    else # else - Impossível criar caminho
      printf "\nERROR: THE PATH '${TO_PATH[i]}' DOES NOT EXISTS!\n\nIMPOSSIBLE TO CREATE!\n\n"
    fi # end - Verifica se foi possível criar

  done
done

printf "\nDONE\n\n"
play_sound "${sound_finished}"
printf "\n\n"







elif [ $BACKUP_TYPE == 3 ]; then

APP_TITLE="TAR INCREMENTAL BACKUP"

clear
print_app_title "${APP_TITLE}"
echo ""

<<comment
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
comment

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
print_separator
printf "\nStarting in 5 second(s), or press [CTRL+C] to exit..."
sleep 5
printf "\n\n"
print_separator

# formato do arquivo
formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

  if is_remote_host "${FROM_PATH[j]}"; then
    echo "ERROR: Remote backup not supported! Jumping directory..."
    continue
  fi 

  # Copia o caminho de origem, removendo a barra do final
  from_path="${FROM_PATH[j]%/}"

  # Obtém o nome da última subpasta
  last_subfolder="${from_path##*/}"

  # Loop for para as unidades externas
  for i in ${!TO_PATH[@]}
  do

    if is_remote_host "${TO_PATH[i]}"; then
      echo "ERROR: Remote backup not supported! Jumping directory..."
      continue
    fi 
 
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

      snar_file="${to_path}/daily.snar"
      
      # Crie o arquivo snar se não existir
      [ ! -f "$snar_file" ] && touch "$snar_file"

      backup_file="${to_full_path}.tar.gz"
      
      set -o pipefail  
      if tar -czf "${backup_file}" --listed-incremental="${snar_file}" -C "${from_path}" . --verbose | tee -a "${log_file_details}"; then
        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)      
        printf "BACKUP SUCCESS '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP SUCCESS '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"

        # -mmin=minutos (DEBUG)
        #echo "LIMITING HISTORY TO ${DAY_LIMIT} minute(s)..."
        #find "${to_path}" -maxdepth 1 -type d -mmin +"${DAY_LIMIT}" -exec rm -rf {} \;

        # -mtime=dias
        #echo "LIMITING HISTORY TO ${DAY_LIMIT} day(s)..."
        #find "${to_path}" -maxdepth 1 -type d -mtime +"${DAY_LIMIT}" -exec rm -rf {} \;
      else
        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
        printf "BACKUP COPY ERROR '${formated_date}'\n\n" >> "${log_file}"
        printf "\nBACKUP COPY ERROR '${formated_date}'\nFROM '${from_path}'\nTO '${to_path}'\n\n" | tee -a "${log_file_details}"
        play_sound "${sound_error}" 
        printf "\nPress [ENTER] to exit...\n"
        read
        exit 1
      fi # end - tar

      print_separator | tee -a "${log_file_details}"

    else # Impossível criar o caminho
      printf "\nERROR: THE PATH '${TO_PATH[i]}' DOES NOT EXISTS!\n\nIMPOSSIBLE TO CREATE!\n\n"
    fi # end - Verifica se foi possível criar

  done
done

printf "\nDONE\n\n"
play_sound "${sound_finished}"
printf "\n\n"




else
  echo "ERROR: BACKUP_TYPE = ${BACKUP_TYPE}"
  echo "Invalid BACKUP_TYPE option in '${config_file}'"
  echo
  echo "Press [ENTER] to exit..."
  read
  exit 1
fi
