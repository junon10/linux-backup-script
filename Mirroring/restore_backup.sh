#!/bin/bash

CONFIG_FILE=./backup_path.txt

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

app_version="v1.0.0.9"
app_date="2025/01/05"
app_author="Junon M."

app_title() {
echo "--------------------------------------------------------------------------------"
echo "                         Linux Restore ${app_version}"
echo "--------------------------------------------------------------------------------"
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
echo "Date: ${app_date} ${app_version}"
echo "Author: ${app_author}"
echo "--------------------------------------------------------------------------------"
echo ""
echo "Where do you want to restore from?"
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
read -p "Enter the corresponding index number: " index
done
echo ""

if [ ! $index -ge 0 ]; then  
  echo "Error: index less than zero!"
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

if [ ! $index -le $[${#TO_PATH[@]}-1] ]; then  
  echo "Error: index greater than the maximum available!"
  echo "Press [ENTER] to exit..."
  echo ""
  read
  exit 1
fi

clear
echo "$(app_title)"

# Copia removendo qualquer barra do final
arr_disk[0]="${TO_PATH[${index}]%/}"

echo ""
echo "Selected restoration from:"
  echo "${index}. ${arr_disk[0]}"
echo ""
echo "To:"
for i in ${!FROM_PATH[@]}
do
  # Exibe removendo qualquer barra do final
  echo "${FROM_PATH[i]%/}"
done
echo ""
echo "Press [ENTER] to restore now, or [CTRL+C] to exit..."
echo ""
read


#-----------------------------------------------------------------------------------------------------

# Data e Hora atual
formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)

# Loop for para os diretórios de origem
for j in ${!FROM_PATH[@]}
do

# Se tiver barra remova
from_path="${FROM_PATH[j]%/}"

# Obtém o nome da última subpasta
last_subfolder="${from_path##*/}"

  # Se a pasta não existir, escreva
  if [ -d ${from_path} ]; then 
    # Se a pasta já existir mostre uma msg 
    echo "ERROR: Folder '${from_path}' already exists!"    
    read -p "Press [W] to overwrite, or [ENTER] to Skip: " opt
  else
    opt="w"
  fi

    if [ "$opt" = "w" ] || [ "$opt" = "W" ]; then

    # Loop for para as unidades externas
    for i in ${!arr_disk[@]}
    do
      # Verifica se está montado
      if [ -d ${arr_disk[i]} ]; then 
      
        to_path="${arr_disk[i]}/${last_subfolder}/"
      
        # Diretório onde será salvo o arquivo de log
        log_path=~/"Backup-logs"
        mkdir -p "${log_path}"

        # Nome do arquivo de log
        log_file="${log_path}/daily-backup.log"

        # Nome do arquivo de log detalhado
        log_path_details="${log_path}/${last_subfolder}"
        mkdir -p "${log_path_details}"

        log_file_details="${log_path_details}/${formated_date}-details.log"

        echo "Log files will be written to '${log_path}'"
        echo ""

        printf "Restore from '${to_path}'\nstarted on [$formated_date]\n" >> $log_file
        echo ""
        echo "Restore from '${to_path}'"
        echo "started on ${formated_date}"
        echo "to '${from_path}'"

        if rsync -a --progress ${to_path} ${from_path} | tee ${log_file_details}; then
          formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A) 
          printf "successfully completed on [$formated_date]\n\n" >> $log_file
          echo "successfully completed!"
          echo "successfully completed!" >> ${log_file_details}
          echo ""
        else
          formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)
          printf "RESTALL ERROR ON [$formated_date]\n\n" >> $log_file
          echo "RESTALL ERROR!"
          echo "RESTALL ERROR!" >> ${log_file_details}
          echo ""
          ${sound_error} 
        fi
      else
        echo "ERROR: DISK UNIT '${arr_disk[i]}' NOT MOUNTED!"
        echo ""
      fi
    done
  fi

done

echo ""
echo "Press [ENTER] to exit..."
echo ""
${sound_finished}
read
