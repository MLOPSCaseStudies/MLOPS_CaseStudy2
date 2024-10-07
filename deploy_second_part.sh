#!/bin/bash

PORT=22011
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=~/student-admin_key

# SSH command variable for reuse
COMMAND="ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}"

# Step 1: List the contents of the remote directory
echo "Listing contents of remote directory..."
${COMMAND} "ls /home/student-admin/jtest/CS553CaseStudy1"

# Step 2: Install python3-venv if not installed
echo "Installing python3-venv if necessary..."
${COMMAND} "sudo apt-get update && sudo apt-get install -qq -y python3-venv"

# Step 3: Create a virtual environment if it doesn't exist
echo "Creating virtual environment..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && if [ ! -d venv ]; then python3 -m venv venv; fi"

# Step 4: Install required packages
echo "Installing required packages..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && source venv/bin/activate && pip install -r requirements.txt"

# Debug: Check if packages are installed
echo "Checking installed packages..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && source venv/bin/activate && which python && pip list"

# Step 5: Run the app in the background and redirect logs to log.txt
echo "Running the app in the background..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && nohup venv/bin/python app.py > log.txt 2>&1 &"

# Display background process ID
echo "Displaying background process ID..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && echo \$!"

# Step 6: Check if the app is running and display process status
echo "Checking if the app is running..."
${COMMAND} "ps aux | grep '[p]ython'"

# Step 7: Display app URL information
echo "Displaying the app's URL..."
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && source venv/bin/activate && python app.py"
