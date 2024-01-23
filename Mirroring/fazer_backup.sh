#!/bin/bash

CONFIG_FILE=./backup_path.inc

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
echo "App:......Espelhamento com rsync (sem criptografia)"
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

      printf "Backup de '${from_path}'\niniciado em [$formated_date]\n" >> $log_file
      echo ""
      echo "Backup de '${from_path}'" 
      echo "iniciado em ${formated_date}"
      echo "para '${to_path}'"

      if rsync -a --progress --delete ${from_path} ${to_path} | tee ${log_file_details}; then
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A) 
        printf "concluído com sucesso em [$formated_date]\n\n" >> $log_file
        echo "Concluído com sucesso!"
        echo "Concluído com sucesso!" >> ${log_file_details}
        echo ""
      else
        formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)
        printf "concluído com erros em [$formated_date]\n\n" >> $log_file
        echo "Concluído com erros!"
        echo "Concluído com erros!" >> ${log_file_details}
        echo ""
        ${sound_error} 
      fi
    else
      echo "Erro: Unidade de disco '${EXTERNAL_STORAGE[i]}' não montada!"
      echo ""
    fi
  done
done

echo ""
echo "Tecle [ENTER] para sair..."
echo ""
${sound_finished}
read
