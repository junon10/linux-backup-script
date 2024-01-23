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
echo "Deseja restaurar à partir de qual unidade de disco?"
echo ""
for i in ${!EXTERNAL_STORAGE[@]}
do
  echo "${i}. ${EXTERNAL_STORAGE[i]}"
done
echo ""

index=
until grep -E '^[0-9]+$' <<< $index
do
read -p "Informe o número de índice correspondente: " index
done
echo ""

if [ ! $index -ge 0 ]; then  
  echo "Erro: índice menor que zero!"
  echo "Tecle [ENTER] para sair..."
  echo ""
  read
  exit 1
fi

if [ ! $index -le $[${#EXTERNAL_STORAGE[@]}-1] ]; then  
  echo "Erro: índice maior que o máximo disponível!"
  echo "Tecle [ENTER] para sair..."
  echo ""
  read
  exit 1
fi

arr_disk[0]="${EXTERNAL_STORAGE[${index}]}"
echo ""
echo "Selecionada restauração à partir de:"
  echo "${index}. ${arr_disk[0]}"
echo ""
echo "Para:"
for i in ${!FROM_PATH_ARR[@]}
do
  echo "${FROM_PATH_ARR[i]}"
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
from_path="${FROM_PATH_ARR[j]}"

  # Se a pasta não existir, escreva
  if [ ! -d ${from_path} ]; then 

    # Loop for para as unidades externas
    for i in ${!arr_disk[@]}
    do
      # Verifica se está montado
      if [ -d ${arr_disk[i]} ]; then 
      
        to_path="${arr_disk[i]}/${TO_PATH_ARR[j]}/"
      
        # Diretório onde será salvo o arquivo de log
        log_path=~/"Documentos/log"
        mkdir -p "${log_path}"

        # Nome do arquivo de log
        log_file="${log_path}/daily-backup.log"

        # Nome do arquivo de log detalhado
        log_path_details="${log_path}/${TO_PATH_ARR[j]}"
        mkdir -p "${log_path_details}"

        log_file_details="${log_path_details}/${formated_date}-details.log"

        echo "Arquivos de log serão gravados em '${log_path}'"
        echo ""

        printf "Restauração de '${to_path}'\niniciado em [$formated_date]\n" >> $log_file
        echo ""
        echo "Restauração de '${to_path}'"
        echo "iniciado em ${formated_date}"
        echo "para '${from_path}'"

        if rsync -a --progress --delete ${to_path} ${from_path} | tee ${log_file_details}; then
          formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A) 
          printf "concluída com sucesso em [$formated_date]\n\n" >> $log_file
          echo "Concluída com sucesso!"
          echo "Concluída com sucesso!" >> ${log_file_details}
          echo ""
        else
          formated_date=$(date +%Y-%m-%d,%H-%M-%S-%A)
          printf "concluída com erros em [$formated_date]\n\n" >> $log_file
          echo "Concluída com erros!"
          echo "Concluída com erros!" >> ${log_file_details}
          echo ""
          ${sound_error} 
        fi
      else
        echo "Erro: Unidade de disco '${arr_disk[i]}' não montada!"
        echo ""
      fi
    done

  else 
    # Se a pasta já existir mostre uma msg 
    echo "Erro: A pasta '${from_path}' já existe!"
    echo "Primeiro exclua a pasta que você quiser restaurar."
    echo "Por segurança é proibido sobrescrever dados!"
    echo ""
  fi

done

echo ""
echo "Tecle [ENTER] para sair..."
echo ""
${sound_finished}
read
