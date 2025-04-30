#!/bin/bash

public_key_access_only="1"

username_hostname="user@server.local"

# example
# exec_remote_cmd "ls -la /home/jr/Desktop/"
exec_remote_cmd() {
  local cmd=$1
  ssh -t ${username_hostname} "sudo bash -c \"${cmd}\""
}

make_public_key_and_send_to_remote() {
  # Generate SSH keys if they don't exist
  if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
  fi
  # Copy the public key to the server
  ssh-copy-id "${username_hostname}"
}

# Configure SSH to allow password authentication
ssh_config_with_password() {
local path="/etc/ssh/sshd_config"
ssh -t "${username_hostname}" "sudo -s <<EOF
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' ${path}
sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/g' ${path}
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' ${path}
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication no/g' ${path}
sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication no/g' ${path}
sed -i 's/PubkeyAuthentication yes/PubkeyAuthentication no/g' ${path}
echo
echo 'Begin remote ${path} file'
echo
cat '${path}'
echo
echo 'End remote ${path} file'
echo
service ssh restart
EOF"  
}

# Configure SSH to allow public key authentication
ssh_config_with_public_key() {
local path="/etc/ssh/sshd_config"
make_public_key_and_send_to_remote
ssh -t "${username_hostname}" "sudo -s <<EOF
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' ${path}
sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/g' ${path}
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' ${path}
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' ${path}
sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' ${path}
sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' ${path}
echo
echo 'Begin remote ${path} file'
echo
cat '${path}'
echo
echo 'End remote ${path} file'
echo
service ssh restart
EOF"  
}


if [ "$public_key_access_only" == "1" ]; then
  ssh_config_with_public_key
  echo
  echo "Configured for public key access (no password, more secure)"
else
  ssh_config_with_password
  echo
  echo "Successfully configured for password access"
fi

echo
echo "Press [ENTER] to exit..."
read
