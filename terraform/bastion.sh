INVENTORY_FILE="ansible-playbook-k8s-installation/ansible/inventories/inventory.ini"
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
NFS_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=nfs" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

# Fetch the NFS IP and update the inventory file
if [ -z "$NFS_IP" ]; then
  log "Failed to fetch NFS IP"
  exit 1
fi
log "NFS IP: $NFS_IP"

# Fetch the Bastion host public IP
log "Fetching Bastion IP"
BASTION_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=bastion" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

# Check if the IP is fetched successfully
if [ -z "$BASTION_IP" ]; then
  log "Failed to fetch Bastion IP"
  exit 1
fi
log "Bastion IP: $BASTION_IP"

# Fetch IP addresses for master instances
log "Fetching IP for master1"
MASTER_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=master1" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$MASTER_IP" ]; then
  log "Failed to fetch IP for master1"
  exit 1
fi
log "master1 IP: $MASTER_IP"

log "Fetching IP for master2"
MASTER1_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=master2" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$MASTER1_IP" ]; then
  log "Failed to fetch IP for master2"
  exit 1
fi
log "master2 IP: $MASTER1_IP"

log "Fetching IP for master3"
MASTER2_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=master3" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$MASTER2_IP" ]; then
  log "Failed to fetch IP for master3"
  exit 1
fi
log "master3 IP: $MASTER2_IP"

sleep 120
# Fetch IP addresses for worker nodes
log "Fetching IP for worker1"
WORKER1_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=worker1" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$WORKER1_IP" ]; then
  log "Failed to fetch IP for worker1"
  exit 1
fi
log "worker1 IP: $WORKER1_IP"

log "Fetching IP for worker2"
WORKER2_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=worker2" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$WORKER2_IP" ]; then
  log "Failed to fetch IP for worker2"
  exit 1
fi
log "worker2 IP: $WORKER2_IP"

log "Fetching IP for worker3"
WORKER3_IP=$(aws ec2 describe-instances --region ap-south-1 --filters "Name=tag:Name,Values=worker3" --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

if [ -z "$WORKER3_IP" ]; then
  log "Failed to fetch IP for worker3"
  exit 1
fi
log "worker3 IP: $WORKER3_IP"

# Update entries for controlplane section in sequence
log "Updating controlplane section in sequence"
update_entry "controlplane" "master3" "$MASTER2_IP"
update_entry "controlplane" "master2" "$MASTER1_IP"
update_entry "controlplane" "master1" "$MASTER_IP"

# Update entries for worker nodes
log "Updating workers section in sequence"
update_entry "node" "worker3" "$WORKER3_IP"
update_entry "node" "worker2" "$WORKER2_IP"
update_entry "node" "worker1" "$WORKER1_IP"

# Update entries for bastion and nfs
update_entry "local" "bastion" "$BASTION_IP"
update_entry "nfs-server" "nfs" "$NFS_IP"
log "Script execution completed successfully"