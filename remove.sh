#!/bin/bash

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
  echo "                     '${app_name}' ${app_version} - Remove"
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
echo "Press [ENTER] to remove App, or [CTRL+C] to exit..."
read

if [ -d "${install_directory}" ]; then 
  echo "Removing app: '${install_directory}'" 
  rm -rf "${install_directory}"
fi

echo
echo "Removed!"
echo
echo "Press [ENTER] to exit..."
read



