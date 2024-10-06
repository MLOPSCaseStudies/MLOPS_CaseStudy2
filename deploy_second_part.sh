#! /bin/bash

PORT=22011
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=~/student-admin_key

# SSH command variable for reuse
COMMAND="ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}"

# Step 1: List the contents of the remote directory
${COMMAND} "ls /home/student-admin/jtest/CS553CaseStudy1"


# Step 2: Install python3-venv if not installed
${COMMAND} "sudo apt install -qq -y python3-venv"

# Step 3: Create a virtual environment if it doesn't exist
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && python3 -m venv venv"

# Step 4: Install required packages
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && source venv/bin/activate && pip install -r requirements.txt"

# Debug: Check if packages are installed
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && source venv/bin/activate && which python && pip list"


# Step 5: Run the app in the background and redirect logs to log.txt
${COMMAND} "cd /home/student-admin/jtest/CS553CaseStudy1 && nohup venv/bin/python3 app.py > log.txt 2>&1 &"

# Step 6: Check if the app is running and display process status
${COMMAND} "ps aux | grep python"

# Step 7: Check for log.txt or nohup.out within the directory
${COMMAND} "find /home/student-admin/jtest/CS553CaseStudy1 -type f -name 'log.txt' -o -name 'nohup.out'"

# Step 8: Display the contents of log.txt if it exists
${COMMAND} "if [ -f /home/student-admin/jtest/CS553CaseStudy1/log.txt ]; then cat /home/student-admin/jtest/CS553CaseStudy1/log.txt; else echo 'log.txt not found'; fi"
