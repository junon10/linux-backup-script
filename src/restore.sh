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

set_to_remote_host() {
  echo "Set to remote host"
  SSH_OPT="-e"
  SSH_CMD="ssh"
}

set_to_local_host() {
  echo "Set to local host"
  SSH_OPT=""
  SSH_CMD=""
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

  rsync -avz "${SSH_OPT}" "${SSH_CMD}" "${from}" "${to}"

}






if [ $BACKUP_TYPE == 1 ]; then

APP_TITLE="RSYNC MIRROR RESTORE"

clear
print_app_title "${APP_TITLE}"

echo ""
echo "WHERE DO YOU WANT TO RESTORE FROM?"
echo ""
for i in ${!TO_PATH[@]}
do
  # Exibe o caminho sem a barra final
  echo "${i}. ${TO_PATH[i]%/}"
done
echo ""

index=
until grep -E '^[0-9]+$' <<< $index
do
read -p "ENTER THE CORRESPONDING INDEX NUMBER " index
done
echo ""

if [ ! $index -ge 0 ]; then  
  echo "ERROR: INDEX LESS THAN ZERO!"
  echo ""
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

if [ ! $index -le $[${#TO_PATH[@]}-1] ]; then  
  echo "ERROR: INDEX GREATER THAN THE MAXIMUM AVAILABLE!"
  echo ""
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

clear
print_app_title "${APP_TITLE}"

# Copia removendo qualquer barra do final
arr_disk[0]="${TO_PATH[${index}]%/}"

echo ""
echo "SELECTED RESTORATION FROM"
  echo "${index}. ${arr_disk[0]}"
echo ""
echo "TO"
for i in ${!FROM_PATH[@]}
do
  # Exibe removendo qualquer barra do final
  echo "${FROM_PATH[i]%/}"
done
echo ""
echo "Press [ENTER] to restore now, or [CTRL+C] to exit..."
read
print_separator
echo ""

# Data e Hora atual
formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

  if is_remote_host "${FROM_PATH[j]}"; then
    echo "ERROR: Remote backup not supported! Jumping directory..."
    continue
  fi 

  # Se tiver barra remova
  from_path="${FROM_PATH[j]%/}"

  # Obtém o nome da última subpasta
  last_subfolder="${from_path##*/}"

  # Se a pasta não existir, escreva
  if [ -d ${from_path} ]; then 
    # Se a pasta já existir mostre uma msg 
    echo "ERROR: FOLDER '${from_path}' ALREADY EXISTS!"    
    read -p "Press [W] to overwrite, or [ENTER] to Skip: " opt
  else
    opt="w"
  fi

    if [ "$opt" = "w" ] || [ "$opt" = "W" ]; then

      # Loop for para as unidades externas
      for i in ${!arr_disk[@]}
      do
      
        if is_remote_host "${arr_disk[i]}"; then
          echo "ERROR: Remote backup not supported! Jumping directory..."
          continue
        fi 
      
        # Verifica se o diretório existe
        if [ -d ${arr_disk[i]} ]; then 

          to_path="${arr_disk[i]}/${last_subfolder}/"
      
          # Diretório onde será salvo o arquivo de log
          log_path=~/"Backup-log"
          mkdir -p "${log_path}"

          # Nome do arquivo de log
          log_file="${log_path}/daily-backup.log"

          # Nome do arquivo de log detalhado
          log_path_details="${log_path}/${last_subfolder}"
          mkdir -p "${log_path_details}"

          log_file_details="${log_path_details}/${formated_date}-details.log"

          printf "\nLOG FILES WILL BE WRITTEN TO '${log_path}'\n"

          printf "\nRESTORE STARTED '${formated_date}'\nFROM '${to_path}'\nTO '${from_path}'\n\n" | tee -a "${log_file}" "${log_file_details}"

          mkdir -p "${from_path}"

          set -o pipefail
          if rsync -a --progress ${to_path} ${from_path} | tee -a ${log_file_details}; then
            formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
            printf "\nRESTORE SUCCESS '${formated_date}'\nFROM '${to_path}'\nTO '${from_path}'\n\n" | tee -a "${log_file}" "${log_file_details}"
          else
            formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
            printf "\nRESTORE ERROR '${formated_date}'\nFROM '${to_path}'\nTO '${from_path}'\n\n" | tee -a "${log_file}" "${log_file_details}"
            play_sound "${sound_error}" 
          fi # end - rsync

          print_separator | tee -a "${log_file}" "${log_file_details}"

        fi # end - Verifica se o diretório existe

      done # end - Loop for para as unidades externas

    fi # end - if opt

done # end - Loop for para os diretórios de origem

printf "\nDONE\n\n"
echo "Press [ENTER] to exit..."
play_sound "${sound_finished}"
read







elif [ $BACKUP_TYPE == 2 ]; then

APP_TITLE="RSYNC INCREMENTAL RESTORE"

clear
print_app_title "${APP_TITLE}"
echo ""

echo "Restore not supported! Press [ENTER] to exit..."
read
exit 1  







elif [ $BACKUP_TYPE == 3 ]; then

APP_TITLE="TAR INCREMENTAL RESTORE"

clear
print_app_title "${APP_TITLE}"
echo ""

clear
print_app_title "${APP_TITLE}"
echo ""
echo "WHERE DO YOU WANT TO RESTORE FROM?"
echo ""
for i in ${!TO_PATH[@]}
do
  # Exibe o caminho sem a barra final
  echo "${i}. ${TO_PATH[i]%/}"
done
echo ""

index=
until grep -E '^[0-9]+$' <<< $index
do
read -p "ENTER THE CORRESPONDING INDEX NUMBER " index
done
echo ""

if [ ! $index -ge 0 ]; then  
  echo "ERROR: INDEX LESS THAN ZERO!"
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

if [ ! $index -le $[${#TO_PATH[@]}-1] ]; then  
  echo "ERROR: INDEX GREATER THAN THE MAXIMUM AVAILABLE!"
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

clear
print_app_title "${APP_TITLE}"

# Copia removendo qualquer barra do final
arr_disk[0]="${TO_PATH[${index}]%/}"

echo ""
echo "SELECTED RESTORATION FROM"
  echo "${index}. ${arr_disk[0]}"
echo ""
echo "TO"
for i in ${!FROM_PATH[@]}
do
  # Exibe removendo qualquer barra do final
  echo "${FROM_PATH[i]%/}"
done
echo ""
echo "Press [ENTER] to restore now, or [CTRL+C] to exit..."
read
print_separator
echo ""

# Data e Hora atual
formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

  if is_remote_host "${FROM_PATH[j]}"; then
    echo "ERROR: Remote backup not supported! Jumping directory..."
    continue
  fi 

  # Se tiver barra remova
  from_path="${FROM_PATH[j]%/}"

  # Obtém o nome da última subpasta
  last_subfolder="${from_path##*/}"

  # Se a pasta não existir, escreva
  if [ -d ${from_path} ]; then 
    # Se a pasta já existir mostre uma msg 
    echo "ERROR: FOLDER '${from_path}' ALREADY EXISTS!"    
    read -p "Press [W] to overwrite, or [ENTER] to Skip: " opt
  else
    opt="w"
  fi

  if [ "$opt" = "w" ] || [ "$opt" = "W" ]; then

    # Loop for para as unidades externas
    for i in ${!arr_disk[@]}
    do

      if is_remote_host "${arr_disk[i]}"; then
        echo "ERROR: Remote backup not supported! Jumping directory..."
        continue
      fi 

      # Verifica se o caminho existe
      if [ -d ${arr_disk[i]} ]; then 
      
        to_path="${arr_disk[i]}/${last_subfolder}/"
      
        # Diretório onde será salvo o arquivo de log
        log_path=~/"Backup-log"
        mkdir -p "${log_path}"

        # Nome do arquivo de log
        log_file="${log_path}/daily-backup.log"

        # Nome do arquivo de log detalhado
        log_path_details="${log_path}/${last_subfolder}"
        mkdir -p "${log_path_details}"

        log_file_details="${log_path_details}/${formated_date}-details.log"

        printf "\nLOG FILES WILL BE WRITTEN TO '${log_path}'\n"
        
        printf "\nRESTORE STARTED '${formated_date}'\nFROM '${to_path}'\nTO '${from_path}'\n\n" | tee -a "${log_file}" "${log_file_details}"

        # Liste os arquivos tar incrementais
        files=$(ls -rt $to_path*.tar.gz)

        # Restaure os backups incrementais
        i=1
        for file in $files; do
          printf "RESTORE FILE ${i}. '${file}'\n" | tee -a "${log_file}" "${log_file_details}"
          mkdir -p "${from_path}"
          tar -xzf "${file}" -C "${from_path}" . --verbose | tee -a "${log_file_details}"
          ((i++))
        done

        formated_date=$(date +%Y-%m-%d-[%H-%M-%S]-%A)
        printf "\nRESTORE SUCCESS '${formated_date}'\nFROM '${to_path}'\nTO '${from_path}'\n\n" | tee -a "${log_file}" "${log_file_details}"

        print_separator | tee -a "${log_file}" "${log_file_details}"

      else
        printf "\nERROR: THE PATH '${arr_disk[i]}' DOES NOT EXISTS!\n\n"
      fi # end - Verifica se o caminho existe

    done # end - Loop for para as unidades externas

  fi # end - if opt

done # end - Loop for para os diretórios de origem

printf "\nDONE\n\n"
echo "Press [ENTER] to exit..."
play_sound "${sound_finished}"
read




else
  echo "ERROR: BACKUP_TYPE = ${BACKUP_TYPE}"
  echo "Invalid BACKUP_TYPE option in '${config_file}'"
  echo
  echo "Press [ENTER] to exit..."
  read
  exit 1
fi
