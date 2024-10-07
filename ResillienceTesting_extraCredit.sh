#!/bin/bash

# Log everything
exec > >(tee -i recovery.log)
exec 2>&1

# Check if VM is accessible
if ! ping -c 1 paffenroth-23.dyn.wpi.edu; then
    echo "VM is not accessible. Attempting to recover..."
    
    # SSH into the VM
    ssh -i ~/student-admin_key -p 22011 student-admin@paffenroth-23.dyn.wpi.edu << 'ENDSSH'
    
    # Navigate to project directory
    cd ~/CS553CaseStudy1
    
    # Check and recreate virtual environment if necessary
    if [ ! -d "venv" ]; then
        echo "Virtual environment not found. Recreating..."
        python3 -m venv venv
    fi
    
    # Activate the virtual environment
    source venv/bin/activate

    # Pull latest code from GitHub
    git pull origin main

    # Install or update dependencies
    pip install -r requirements.txt

    # Optionally reinstall dependencies if needed
    read -p "Do you want to reinstall dependencies? (y/n) " choice
    if [[ "$choice" == "y" ]]; then
        echo "Reinstalling dependencies..."
        pip install --force-reinstall -r requirements.txt
    fi

    # Backup existing logs before recovery attempt
    if [ -f "log.txt" ]; then
        echo "Backing up logs..."
        cp log.txt log_backup_$(date +%F_%T).txt
    fi

    # Restart the application
    nohup venv/bin/python3 app.py > log.txt 2>&1 &
    echo "Application restarted."

    # Monitor if the application is running correctly
    if ! curl -s http://paffenroth-23.dyn.wpi.edu:8011 > /dev/null; then
        echo "Application failed to start. Attempting another restart..."
        nohup venv/bin/python3 app.py > log.txt 2>&1 &
        echo "Application restarted again."
    else
        echo "Application is running properly."
    fi

    # Check for high CPU usage as a potential issue
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\([0-9.]*\\)%* id.*/\\1/" | awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
        echo "High CPU usage detected: $CPU_USAGE%"
        # Optional: Take additional action, such as restarting services or notifying admin
    fi

    # If the recovery steps have not worked, prompt for reboot
    read -p "Recovery failed. Do you want to reboot the VM? (y/n) " reboot_choice
    if [[ "$reboot_choice" == "y" ]]; then
        echo "Rebooting the VM..."
        sudo reboot
    fi
    
    echo "Recovery completed."
    ENDSSH

else
    echo "VM is running fine. No recovery needed."
fi
