#!/bin/bash

param=$1

app_name="Backup App"
install_directory="/home/$USER/Installed/backup-app"
media_directory="${install_directory}/media"

version_file=./"version.info"
if [ ! -f ${version_file} ]
then
  printf "ERROR: THE FILE '${version_file}' NOT FOUND!\n\n"
  echo "Press [ENTER] to exit..."
  read
  exit
fi
source ${version_file}

apps+=("backup")
apps+=("restore")


print_separator() {
  local len=${1:-80}
  printf "%*s\n" $len "" | tr ' ' '-'
}

print_app_title() {
  print_separator
  echo "                     '${app_name}' ${app_version} - Install"
  echo "                    Date: ${app_date} - Author: ${app_author}"
  print_separator
}

find_line() {

  local file=$1
  local line_to_find=$2

  # Check if the file exists
  if [ ! -f "$file" ]; then
    return 1
  fi

  # Use grep to find the line
  grep -q "$line_to_find" "$file"
}

remove_from_path() { 

  local file=$1 
  local line=$2 

  if find_line "$file" "$line"; then 
    echo "Line '${line}' found in '${file}' file, removing..."
    sed -i "/${line}/d" "${file}"
  else 
    echo "Line '${line}' not found in '${file}' file, no changes"
  fi 
  echo
}

add_to_path() {

  local file=$1
  local line=$2

  if find_line "$file" "$line"; then
    echo "line '${line}' is found in '${file}' file, no changes"
  else
    echo "Inserting the line '${line}' to '${file}' file"
    echo "${line}" >> "${file}" 
  fi
  
  echo
}

print_app_title
echo
if [ "$param" != "1" ]; then
  echo "Press [ENTER] to install '${app_name}', or [CTRL+C] to exit..."
  read
else  
  echo "Instant update activated!"  
fi

if [ ! -d "${install_directory}" ]; then
  echo "Making app installation directory '${install_directory}'"
  mkdir -p "${install_directory}"
  echo
fi

if [ "$param" != "1" ]; then
  echo "Installing dependencies, please wait..."
  sudo apt install rsync tar -y
fi

echo "Installing audio notification files in '${media_directory}', please wait..."
rsync -avz ./"media/" "${media_directory}"

echo "Installing ${app_name}, please wait..."

for i in ${!apps[@]}
do
  from=./"src/${apps[i]}.sh"  
  to="${install_directory}/${apps[i]}.sh"
  echo "Copying '${from}' to '${to}'"
  cp "${from}" "${to}" 

  if [ -L "${install_directory}/${apps[i]}" ]; then
    rm "${install_directory}/${apps[i]}"
  fi

  ln -s "${install_directory}/${apps[i]}.sh" "${install_directory}/${apps[i]}"
done

if [ -f "${version_file}" ]; then
  cp "${version_file}" "${install_directory}/${version_file}"
fi

add_to_path ~/.bashrc "source ~/.paths"
add_to_path ~/.paths "export PATH=\$PATH:${install_directory}"

# echo "Open with gedit"
# gedit ~/.paths

echo "Reload '~/.bashrc' file"
source ~/.bashrc

echo
echo "'${app_name}' successfull installed."
echo

if [ "$param" != "1" ]; then
  echo "Press [ENTER] to exit..."
  read
else
  echo "Up to date!"
  sleep 1  
fi


