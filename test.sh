#!/bin/bash

# Automatically retrieve the VM IP
VM_IP="paffenroth-23.dyn.wpi.edu"  # Fetches the first IP address listed

# Define the SSH port (if it changes dynamically, add a command to retrieve it)
PORT=22011  # Replace with the correct port if it's different

# Clean up from previous runs
ssh-keygen -f "C:/Users/keonr/.ssh/known_hosts" -R "[paffenroth-23.dyn.wpi.edu]:21011"
rm -rf tmp

# Create a temporary directory
mkdir tmp

# copy the key to the temporary directory
cp student-admin_key* tmp

# Change to the temporary directory
cd tmp

# Set the permissions of the key
chmod 600 student-admin_key*

# Create a unique key
rm -f mykey*
ssh-keygen -f mykey -t ed25519 -N "careful"

# Insert the key into the authorized_keys file on the server
# One > creates
cat mykey.pub > authorized_keys
cat student-admin_key.pub >> authorized_keys
# two >> appends
# Remove to lock down machine
#cat student-admin_key.pub >> authorized_keys

chmod 600 authorized_keys

echo "checking that the authorized_keys file is correct"
ls -l authorized_keys
cat authorized_keys

ssh -i student-admin_key -p ${PORT} -o StrictHostKeyChecking=no student-admin@${VM_IP} "cat ~/.ssh/authorized_keys"

# Copy the authorized_keys file to the server
scp -i student-admin_key -P ${PORT} -o StrictHostKeyChecking=no authorized_keys student-admin@${VM_IP}:~/.ssh/
echo "Done"

# Add the key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add mykey

# Check the key file on the server
echo "checking that the authorized_keys file is correct"
ssh -p ${PORT} -o StrictHostKeyChecking=no student-admin@${VM_IP} "cat ~/.ssh/authorized_keys"

# clone the repo
git clone https://github.com/MLOPSCaseStudies/MLOPS_CaseStudy2.git

ssh -i student-admin_key -p ${PORT} -o StrictHostKeyChecking=no student-admin@${VM_IP} "rm -r ~/keon_test/MLOPS_CaseStudy2"

# Copy the files to the server
scp -P ${PORT} -o StrictHostKeyChecking=no -r MLOPS_CaseStudy2 student-admin@${VM_IP}:~/keon_test

# check that the code in installed and start up the product
COMMAND="ssh -i mykey -p ${PORT} -o StrictHostKeyChecking=no student-admin@${VM_IP}"

# ONLY NECESSARY IF NOT MAIN BRANCH 
ssh -i student-admin_key -p ${PORT} -o StrictHostKeyChecking=no student-admin@${VM_IP} "cd keon_test/MLOPS_CaseStudy2 && git checkout keon"

${COMMAND} "conda deactivate" 

${COMMAND} "ls keon_test/MLOPS_CaseStudy2"
# Ensure venv is created and requirements are installed
${COMMAND} "sudo apt install -qq -y -v python3-venv"
${COMMAND} "cd keon_test/MLOPS_CaseStudy2 && python3 -m venv venv"
${COMMAND} "cd keon_test/MLOPS_CaseStudy2 && source venv/bin/activate && pip install -r requirements.txt"

${COMMAND} "echo 'Finished Installation'" 

# Run the Python app with proper venv activation
${COMMAND} "nohup keon_test/MLOPS_CaseStudy2/venv/bin/python3 keon_test/MLOPS_CaseStudy2/app.py > log.txt 2>&1 &"

# Step 6: Install Prometheus
${COMMAND} "[ ! -f prometheus-2.54.1.linux-amd64.tar.gz ] && wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz"
${COMMAND} "tar xvf prometheus-2.54.1.linux-amd64.tar.gz"
${COMMAND} "cd prometheus-2.54.1.linux-amd64 && nohup ./prometheus &"


# Step 7: Install Node Exporter
${COMMAND} "cd .."
${COMMAND} "[ ! -f node_exporter-1.8.2.linux-amd64.tar.gz ] && wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz"
${COMMAND} "tar xvf node_exporter-1.8.2.linux-amd64.tar.gz"
${COMMAND} "cd node_exporter-1.8.2.linux-amd64 && nohup ./node_exporter &"

# Step 8: Install Grafana
${COMMAND} "sudo apt-get update"
${COMMAND} "sudo apt-get install -y adduser libfontconfig1"
${COMMAND} "wget https://dl.grafana.com/oss/release/grafana_10.0.3_amd64.deb"
${COMMAND} "sudo dpkg -i grafana_10.0.3_amd64.deb"
${COMMAND} "sudo systemctl start grafana-server"
${COMMAND} "sudo systemctl enable grafana-server"

# Step 9: Expose Grafana via ngrok
${COMMAND} "wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip"
${COMMAND} "unzip ngrok-stable-linux-amd64.zip"
# REPLACE THIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIS
${COMMAND} "./ngrok authtoken 2n4JeUzxt0dMifS0Fu780ERppKL_88cAvdGPCdtH2DG8SLKku"
${COMMAND} "./ngrok http 3000 &"

# Optional: Check if services are running
${COMMAND} "ps aux | grep prometheus"
${COMMAND} "ps aux | grep grafana"
${COMMAND} "ps aux | grep ngrok"

