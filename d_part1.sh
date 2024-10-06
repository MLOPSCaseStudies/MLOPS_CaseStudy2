#! /bin/bash

PORT=22011
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=/Users/shipz/Downloads/MLOps_Case_Study_2/Keys/

ssh-keygen -f "/Users/shipz/.ssh/known_hosts" -R "[paffenroth-23.dyn.wpi.edu]:22011"

rm -rf tmp

# Create a temporary directory
mkdir tmp

# Copy the key to the temporary directory
cp ${STUDENT_ADMIN_KEY_PATH}/student-admin_key* tmp

# Change to the temporary directory
cd tmp

# Set the permissions of the key
chmod 600 student-admin_key*

ssh-keygen -f mykey -t ed25519 -N "careful"

cat mykey.pub >> authorized_keys
# two >> appends
# Remove to lock down machine
cat student-admin_key.pub >> authorized_keys

chmod 600 authorized_keys

echo "checking that the authorized_keys file is correct"
ls -l authorized_keys
cat authorized_keys

scp -i ${STUDENT_ADMIN_KEY_PATH}/student-admin_key -P ${PORT} -o StrictHostKeyChecking=no authorized_keys student-admin@${MACHINE}:~/.ssh/

ssh -i mykey -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE} "cat ~/.ssh/authorized_keys"

git clone https://github.com/jvroo/CS553CaseStudy1.git

scp -i mykey -P ${PORT} -o StrictHostKeyChecking=no -r CS553CaseStudy1 student-admin@${MACHINE}:~/
