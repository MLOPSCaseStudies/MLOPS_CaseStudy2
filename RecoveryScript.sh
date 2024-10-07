#!/bin/bash

# Check if VM is accessible
if ! ping -c 1 <http://paffenroth-23.dyn.wpi.edu/>; then
    echo "VM is not accessible. Attempting to recover..."
    
    # SSH into the VM
    ssh -i ~/student-admin_key student-admin@paffenroth-23.dyn.wpi.edu << 'ENDSSH'
    
    # Navigate to project directory
    cd ~/CS553CaseStudy1

    # Step 1: Check if python3-venv is installed, if not install it
    echo "Installing python3-venv if necessary..."
    sudo apt-get update
    sudo apt-get install -qq -y python3-venv

    # Step 2: Create virtual environment if it doesn't exist
    echo "Creating virtual environment if not present..."
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    else
        echo "'venv' already exists. Skipping creation."
    fi

    # Step 3: Activate virtual environment
    echo "Activating virtual environment..."
    source venv/bin/activate

    # Step 4: Deactivate any active conda environment (if exists)
    echo "Deactivating conda environment if necessary..."
    conda deactivate

    # Step 5: Install required dependencies
    echo "Installing required packages from requirements.txt..."
    pip install -r requirements.txt

    # Step 6: Pull latest code from GitHub
    echo "Pulling latest code from GitHub..."
    git pull origin main

    # Step 7: Start or restart the application in the background
    echo "Starting the application in the background..."
    nohup venv/bin/python3 app.py > log.txt 2>&1 &

    echo "Recovery completed successfully."
    ENDSSH
else
    echo "VM is running fine. No recovery needed."
fi
