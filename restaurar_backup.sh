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
echo "Date: 2024/01/01 v1.0.0.1"
echo "Author: Junon M."
echo ""
echo "Deseja restaurar à partir de qual unidade de disco?"
echo ""
for i in ${!external_storage[@]}
do
  echo "${i}. ${external_storage[i]}"
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

if [ ! $index -le $[${#external_storage[@]}-1] ]; then  
  echo "Erro: índice maior que o máximo disponível!"
  echo "Tecle [ENTER] para sair..."
  echo ""
  read
  exit 1
fi

arr_disk[0]="${external_storage[${index}]}"
echo ""
echo "Selecionada restauração à partir de:"
  echo "${index}. ${arr_disk[0]}"
echo ""
echo "Para:"
for i in ${!arr_origem[@]}
do
  echo "${arr_origem[i]}"
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
origem="${arr_origem[j]}"

  # Se a pasta não existir, escreva
  if [ ! -d ${origem} ]; then 

    # Loop for para as unidades externas
    for i in ${!arr_disk[@]}
    do
      # Verifica se está montado
      if [ -d ${arr_disk[i]} ]; then 
      
        destino="${arr_disk[i]}/${arr_destino[j]}/"
      
        # Diretório onde será salvo o arquivo de log
        log_dir=~/"Documentos/log"
        mkdir -p "${log_dir}"

        # Nome do arquivo de log
        log_file="${log_dir}/daily-backup.log"

        printf "Restauração de ${destino}\niniciado em [$date_format]\n" >> $log_file
        echo ""
        echo "Restauração de ${destino}"
        echo "iniciado em ${date_format}"
        echo "para ${origem}"

        if rsync -a --progress --delete ${destino} ${origem}; then
          date_format=$(date +%Y-%m-%d,%H-%M-%S-%A) 
          printf "concluída com sucesso em [$date_format]\n\n" >> $log_file
          echo "Concluída com sucesso!"
          echo ""
        else
          date_format=$(date +%Y-%m-%d,%H-%M-%S-%A)
          printf "concluída com erros em [$date_format]\n\n" >> $log_file
          echo "Concluída com erros!"
          echo ""
          ${sound_error} 
        fi
      else
        echo "Erro: Unidade de disco ${arr_disk[i]} não montada!"
        echo ""
      fi
    done

  else 
    # Se a pasta já existir mostre uma msg 
    echo "Erro: A pasta ${origem} já existe!"
    echo "Primeiro exclua a pasta que você quiser restaurar"
    echo "Por segurança é proibido sobrescrever dados!"
    echo ""
  fi

done

echo ""
echo "Tecle [ENTER] para sair..."
echo ""
${sound_finished}
read
