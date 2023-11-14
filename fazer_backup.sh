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
echo "Espelhamento não criptografado com rsync"
echo ""
echo "Iniciando backup de:"
for i in ${!arr_origem[@]}
do
  echo "${arr_origem[i]}"
done
echo ""
echo "Para:"
for i in ${!external_storage[@]}
do
  echo "${external_storage[i]}"
done
echo ""
echo "Tecle [ENTER] para continuar, ou [CTRL+C] para sair..."
echo ""
read

#-----------------------------------------------------------------------------------------------------

# Data e Hora atual
date_format=$(date +%Y-%m-%d,%H-%M-%S-%A)

# Loop for para os diretórios de origem
for j in ${!arr_origem[@]}
do
origem="${arr_origem[j]}/"

  # Loop for para as unidades externas
  for i in ${!external_storage[@]}
  do
    # Verifica se está montado
    if [ -d ${external_storage[i]} ]; then 
      
      destino="${external_storage[i]}/${arr_destino[j]}"
      mkdir -p ${destino}      
    
      # Diretório onde será salvo o arquivo de log
      log_dir="${external_storage[i]}/log"
      mkdir -p "${log_dir}"

      # Nome do arquivo de log
      log_file="${log_dir}/daily-backup.log"

      printf "Backup de ${origem}\niniciado em [$date_format]\n" >> $log_file
      echo ""
      echo "Backup de ${origem}" 
      echo "iniciado em ${date_format}"
      echo "para ${destino}"

      if rsync -a --progress --delete ${origem} ${destino}; then
        date_format=$(date +%Y-%m-%d,%H-%M-%S-%A) 
        printf "concluído com sucesso em [$date_format]\n\n" >> $log_file
        echo "Concluído com sucesso!"
        echo ""
      else
        date_format=$(date +%Y-%m-%d,%H-%M-%S-%A)
        printf "concluído com erros em [$date_format]\n\n" >> $log_file
        echo "Concluído com erros!"
        echo ""
        ${sound_error} 
      fi
    else
      echo "Erro: Unidade de disco ${external_storage[i]} não montada!"
      echo ""
    fi
  done
done

echo ""
echo "Tecle [ENTER] para sair..."
echo ""
${sound_finished}
read
