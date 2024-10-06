#! /bin/bash

PORT=22011
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=~/student-admin_key

# Connect to the VM via SSH
#ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} student-admin@${MACHINE}

# # Clean up from previous runs
# ssh-keygen -f "/home/rcpaffenroth/.ssh/known_hosts" -R "[paffenroth-23.dyn.wpi.edu]:22011"
# rm -rf tmp

# # Create a temporary directory
# mkdir tmp

# # copy the key to the temporary directory
# cp ${STUDENT_ADMIN_KEY_PATH}/student-admin_key* tmp

# # Change to the temporary directory
# cd tmp

# # Set the permissions of the key
# chmod 600 student-admin_key*

# # Create a unique key
# rm -f mykey*
# ssh-keygen -f mykey -t ed25519 -N "careful"

# # Insert the key into the authorized_keys file on the server
# # One > creates
# cat mykey.pub > authorized_keys
# # two >> appends
# # Remove to lock down machine
# #cat student-admin_key.pub >> authorized_keys

# chmod 600 authorized_keys

# echo "checking that the authorized_keys file is correct"
# ls -l authorized_keys
# cat authorized_keys

# # Copy the authorized_keys file to the server
# scp -i student-admin_key -P ${PORT} -o StrictHostKeyChecking=no authorized_keys student-admin@${MACHINE}:~/.ssh/

# # Add the key to the ssh-agent
# eval "$(ssh-agent -s)"
# ssh-add mykey

# # Check the key file on the server
# echo "checking that the authorized_keys file is correct"
# ssh -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE} "cat ~/.ssh/authorized_keys"


# Clone the repo if not already cloned locally
if [ ! -d "CS553CaseStudy1" ]; then
    echo "Cloning the repository..."
    git clone https://github.com/jvroo/CS553CaseStudy1.git
else
    echo "Repository already exists, pulling latest changes..."
    cd CS553CaseStudy1 && git pull
    cd ..
fi

# Check if the directory exists on the remote server
ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} student-admin@${MACHINE} << EOF
if [ -d "~/CS553CaseStudy1" ]; then
    echo "Directory CS553CaseStudy1 already exists on the server, removing it..."
    rm -rf ~/CS553CaseStudy1
fi
EOF

# Copy the files to the server
echo "Copying CS553CaseStudy1 directory to the VM..."
scp -P ${PORT} -i ${STUDENT_ADMIN_KEY_PATH} -o StrictHostKeyChecking=no -r CS553CaseStudy1 student-admin@${MACHINE}:~/jvenv/

# After copying, SSH into the VM and perform operations
ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} student-admin@${MACHINE} << EOF
chmod u+w ~


echo "Setting up the project environment on the VM..."
cd CS553CaseStudy1

EOF


