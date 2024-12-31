#!/bin/bash

sudo su -

user_name="ansible-user"
user_home="/home/$user_name"
user_ssh_dir="$user_home/.ssh"

# Check if user already exists
if id "$user_name" &>/dev/null; then
  echo "User $user_name already exists."
  exit 1
fi

# create a user
sudo adduser --disabled-password --gecos "" "$user_name"

echo "User $user_name is created succesfully"

# add user to sudoer group
echo "ansible-user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible-user

# Switch to user from rot
su - ansible-user

# install awscli
sudo apt update -y
sudo apt-get install -y awscli

# Install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y

mkdir -p $user_ssh_dir
chmod 700 $user_ssh_dir

#Generate SSH key
if [ ! -f "$user_ssh_dir/id_rsa" ]; then
  ssh-keygen -t rsa -b 4096 -f $user_ssh_dir/id_rsa -N ""
fi

chown -R $user_name:$user_name $user_home

aws s3 cp $user_ssh_dir/id_rsa.pub s3://my-key/server.pub

#logi =n into user
user_name="ansible-user"
user_home="/home/$user_name"
user_ssh_dir="$user_home/.ssh"
ssh_key_path="$user_ssh_dir/authorized_keys"

mkdir -p $user_ssh_dir
chmod 700 $user_ssh_dir

aws s3 cp s3://my-key/server.pub $ssh_key_path
chmod 600 $ssh_key_path
chown -R $user_name:$user_name $user_home

cd
# Navigate to home directory and log a message
cd $user_home && echo "correct till this step" >>main-data.log 2>&1

git clone "https://github.com/Manohar-1305/ansible_playbook_k8s-installation.git"

INVENTORY_FILE="ansible_playbook_k8s-installation/ansible/inventories/inventory.ini"

LOG_FILE="ansible_script.log"

export AWS_REGION=ap-south-1

log() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" | sudo tee -a "$LOG_FILE"
}

# Function to update or add entries
update_entry() {
  local section=$1
  local host=$2
  local ip=$3

  log "Updating entry: Section: $section, Host: $host, IP: $ip"

  # Ensure the section header exists
  if ! grep -q "^\[$section\]" "$INVENTORY_FILE"; then
    log "Section $section not found. Adding section header."
    sudo bash -c "echo -e '\n[$section]' >>'$INVENTORY_FILE'"
  fi

  # Remove existing entry if it exists
  sudo sed -i "/^\[$section\]/,/^\[.*\]/{/^$host ansible_host=.*/d}" "$INVENTORY_FILE"

  # Add or update the entry
  sudo sed -i "/^\[$section\]/a $host ansible_host=$ip" "$INVENTORY_FILE"
}

# Check if the inventory file exists
if [ ! -f "$INVENTORY_FILE" ]; then
  log "Inventory file not found: $INVENTORY_FILE"
  exit 1
fi

# Fetch NFS IP and update the inventory file
NFS_IP=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=nfs" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

if [ -z "$NFS_IP" ]; then
  log "Failed to fetch NFS IP"
  exit 1
fi
log "NFS IP: $NFS_IP"

# Fetch the Bastion host public IP
log "Fetching Bastion IP"
BASTION_IP=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=bastion" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

if [ -z "$BASTION_IP" ]; then
  log "Failed to fetch Bastion IP"
  exit 1
fi
log "Bastion IP: $BASTION_IP"
sleep 30
# Define arrays for master and worker nodes
master=("master1" "master2" "master3")
worker=("worker1" "worker2" "worker3")

# Fetch and update IPs for masters
declare -A master_ips
for master_node in "${master[@]}"; do
  log "Fetching IP for $master_node"

  # First attempt to fetch IP
  ip=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=$master_node" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

  if [ -z "$ip" ]; then
    log "Failed to fetch IP for $master_node on first attempt. Retrying..."
    sleep 10 # Optional: small delay before retrying

    # Second attempt
    ip=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=$master_node" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

    if [ -z "$ip" ]; then
      log "Failed to fetch IP for $master_node after retry. Skipping..."
      continue
    fi
  fi

  log "$master_node IP: $ip"
  master_ips["$master_node"]=$ip
done
# Pause for 2 minutes before updating workers
sleep 140
# Fetch and update IPs for workers
declare -A worker_ips
for worker_node in "${worker[@]}"; do
  log "Fetching IP for $worker_node"

  # First attempt to fetch IP
  ip=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=$worker_node" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

  if [ -z "$ip" ]; then
    log "Failed to fetch IP for $worker_node on first attempt. Retrying..."
    sleep 10 # Optional: small delay before retrying

    # Second attempt
    ip=$(aws ec2 describe-instances --region "$AWS_REGION" --filters "Name=tag:Name,Values=$worker_node" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

    if [ -z "$ip" ]; then
      log "Failed to fetch IP for $worker_node after retry. Skipping..."
      continue
    fi
  fi

  log "$worker_node IP: $ip"
  worker_ips["$worker_node"]=$ip
done

# Sequentially update entries for controlplane section
log "Updating controlplane section in sequence"
update_entry "controlplane" "master3" "${master_ips[master3]}"
update_entry "controlplane" "master2" "${master_ips[master2]}"
update_entry "controlplane" "master1" "${master_ips[master1]}"

# Sequentially update entries for worker nodes
log "Updating workers section in sequence"
update_entry "node" "worker3" "${worker_ips[worker3]}"
update_entry "node" "worker2" "${worker_ips[worker2]}"
update_entry "node" "worker1" "${worker_ips[worker1]}"

# Update entries for bastion and NFS
update_entry "local" "bastion" "$BASTION_IP"
update_entry "nfs-server" "nfs" "$NFS_IP"

log "Script execution completed successfully"

LOAD_BALANCER_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=master1" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)
advertise_address=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=master1" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$LOAD_BALANCER_IP" ]; then
  echo "Failed to fetch Load Balancer and advertise_address IP address."
  exit 1
fi

FILE_PATH="/home/ansible-user/ansible_playbook_k8s-installation/ansible/roles/first-master/defaults/main.yaml"

if [ ! -f "$FILE_PATH" ]; then
  echo "File not found: $FILE_PATH"
  exit 1
fi

sudo sed -i.bak "s/^LOAD_BALANCER_IP:.*/LOAD_BALANCER_IP: ${LOAD_BALANCER_IP}/" "$FILE_PATH"
sudo sed -i.bak "s/^advertise_address:.*/advertise_address: ${advertise_address}/" "$FILE_PATH"

echo "Updated LOADBALANCER_IP to ${LOADBALANCER_IP} in $FILE_PATH" >loadbalancer.txt

# Fetch the NFS IP address
NFS_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=nfs" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

# Define the path to the YAML file
YAML_FILE="/home/ansible-user/ansible_playbook_k8s-installation/ansible/roles/nfs-setup/defaults/main.yaml"

# Update the nfs_ip in the YAML file
if [[ -n "$NFS_IP" ]]; then
  sudo sed -i "s/^nfs_ip:.*/nfs_ip: \"$NFS_IP\"/" "$YAML_FILE"
  echo "Updated nfs_ip in $YAML_FILE to $NFS_IP"
else
  echo "Failed to fetch NFS IP. Please check the AWS command or instance state."
  exit 1
fi
USER_FILE="$(pwd)/nfs_ip_update.log"

echo "NFS IP updated to $NFS_IP" >>nfs_path_updated

