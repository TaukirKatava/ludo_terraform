#!/bin/bash

# Log all output and errors
exec > /var/log/user_data.log 2>&1
set -x

# Add the ubuntu user to the root group and grant sudo without a password
usermod -aG root ubuntu
echo "ubuntu ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the ubuntu user and execute the rest of the script
sudo -u ubuntu -i << 'EOF'

########## VARIABLE ASSIGNMENTS ##########
NODE_VERSION="20"
REPO_URL="https://github.com/yudiz-solutions/Ludo-Naresh-Quick-BE/"  # Replace with your GitHub repository URL
GITHUB_USERNAME="YudizTaukirKatava"  # Replace with your GitHub username
GITHUB_TOKEN="YOUR_GITHUBTOKEN"
PROJECT_PATH="/home/ubuntu"
PROJECT_NAME=""  # Leave empty to clone into /home/ubuntu, or specify a project name
PM2_NAME="quick-mode-stag"
LOG_MAX_SIZE="70M"
LOG_RETAIN_DAYS="7"
BRANCH="timer-mode"  # Variable to specify the branch to clone
S3_BUCKET="s3://ludo-env-bucket/stag-quick"  # Replace with your S3 bucket and folder path
ENV_FILE_NAME="stag-quick-env"  # Name of the env file in the S3 bucket


###################### Necessary Installation #############################################
sudo apt update -y
sudo apt install ruby wget unzip net-tools -y


########## SWAP MEMORY CREATION ##########
SWAP_SIZE="1G"

# Create and configure swap memory
if ! sudo swapon --show | grep -q "/swapfile"; then
  sudo fallocate -l $SWAP_SIZE /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
  echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
fi

free -h
df -h


############################ AWS CLI Installation ###################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

########## NODE INSTALLATION ###########
cd ~
curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install -y nodejs

# Install pm2 globally using sudo to prevent EACCES errors
sudo npm install -g pm2

######################################################################################################################################
####################################              Project Specific updates             ###############################################
######################################################################################################################################

# Common setup and environment variables
export PM2_HOME=/home/ubuntu/.pm2

################# CLONING REPOSITORY ##############################
clone_repo() {
  echo "Cloning repository..."

  if [ -z "$PROJECT_NAME" ];then
    if [ "$(ls -A $PROJECT_PATH)" ]; then
      PROJECT_DIR="${PROJECT_PATH}/$(basename ${REPO_URL} .git)"
    else
      PROJECT_DIR=${PROJECT_PATH}
    fi
  else
    PROJECT_DIR=${PROJECT_PATH}/${PROJECT_NAME}
  fi

  mkdir -p ${PROJECT_DIR}

  # Clone the specified branch if provided, otherwise clone the default branch
  if [ -n "$BRANCH" ];then
    git clone --branch $BRANCH https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${REPO_URL#https://} ${PROJECT_DIR}
  else
    git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${REPO_URL#https://} ${PROJECT_DIR}
  fi

  cd ${PROJECT_DIR}
  # Change ownership to ubuntu:ubuntu
  sudo chown -R ubuntu:ubuntu ${PROJECT_DIR}
}

################### Function to install dependencies and build project ################
install_and_build() {
  echo "Installing dependencies..."

  if npm install; then
    echo "npm install succeeded."
  else
    echo "npm install failed, trying npm install --force."
    npm install --force
  fi

  if grep -q "\"build\"" package.json; then
    echo "Running npm build..."
    npm run build
  fi
}

###################### Function to get the .env file from S3 ######################
get_env_file() {
  echo "Fetching .env file from S3..."

  if [ -z "$PROJECT_DIR" ]; then
    echo "Environment path is not set."
    exit 1
  fi

  # Fetching the environment file from the S3 bucket
  if aws s3 cp ${S3_BUCKET}/${ENV_FILE_NAME} ${PROJECT_DIR}/; then
    echo "Environment file successfully downloaded."
    mv ${PROJECT_DIR}/${ENV_FILE_NAME} ${PROJECT_DIR}/.env
  else
    echo "Failed to download the .env file from S3."
    exit 1
  fi

  # Print environment variables for verification
  echo "S3 Bucket: $S3_BUCKET"
  echo "Environment Path: $PROJECT_DIR"
  echo "Environment File: .env" 
}

################# Function to start project with pm2 ####################
start_pm2() {
  echo "Starting project with pm2 as ${PM2_NAME}..."

  # Check if index.js exists
  if [ -f "${PROJECT_DIR}/index.js" ]; then
    pm2 start ${PROJECT_DIR}/index.js --name ${PM2_NAME}
  else
    echo "Error: ${PROJECT_DIR}/index.js not found. PM2 process not started."
    exit 1
  fi
}

############## Function to setup pm2 log rotation if not already configured ###########
setup_pm2_logrotate() {
  if pm2 describe pm2-logrotate &>/dev/null; then
    echo "pm2-logrotate is already configured. Skipping setup."
  else
    echo "Installing pm2-logrotate..."
    pm2 install pm2-logrotate
    echo "Configuring pm2-logrotate..."
    pm2 set pm2-logrotate:max_size ${LOG_MAX_SIZE}
    pm2 set pm2-logrotate:retain ${LOG_RETAIN_DAYS}
  fi
}

################ PM2 Startup ##############################
setup_pm2_startup() {
  echo "Setting up PM2 startup script..."
  sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
  sudo chown ubuntu:ubuntu /home/ubuntu/.pm2/rpc.sock /home/ubuntu/.pm2/pub.sock
  sudo chown -R ubuntu:ubuntu /home/ubuntu/.pm2
}

########### Function to save pm2 processes ##########
save_pm2_processes() {
  echo "Saving PM2 processes..."
  pm2 save
}

######################################################################################################################################################################
# Main Script Execution

clone_repo
get_env_file
install_and_build
start_pm2
setup_pm2_logrotate
setup_pm2_startup
save_pm2_processes

# Echo all environment variables at the end of the script for verification
echo "===== Environment Variables ====="
echo "Node Version: $NODE_VERSION"
echo "Repository URL: $REPO_URL"
echo "Branch: $BRANCH"
echo "GitHub Username: $GITHUB_USERNAME"
echo "Project Path: $PROJECT_PATH"
echo "Project Name: $PROJECT_NAME"
echo "PM2 Name: $PM2_NAME"
echo "Log Max Size: $LOG_MAX_SIZE"
echo "Log Retain Days: $LOG_RETAIN_DAYS"
echo "Environment Path: $ENV_PATH"
echo "PM2 Home: $PM2_HOME"
echo "Swap Size: $SWAP_SIZE"
echo "S3 Bucket: $S3_BUCKET"
echo "Environment File: $ENV_FILE_NAME"

echo "Project setup and started with pm2."

EOF