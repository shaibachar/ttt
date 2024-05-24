Here is a bash script that will add/update a text file with the local server IP address and push it to a public GitHub repository. This script can be scheduled to run as a service.

### Bash Script (`update_ip.sh`)

```bash
#!/bin/bash

# Variables
REPO_DIR="/path/to/your/repo"
FILE_NAME="server_ip.txt"
GITHUB_REPO="https://github.com/yourusername/yourrepo.git"
BRANCH="main"

# Get local server IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Navigate to the repository directory
cd $REPO_DIR

# Check if repository directory exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Repository directory does not exist. Cloning the repository."
    git clone $GITHUB_REPO $REPO_DIR
    cd $REPO_DIR
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Git repository not initialized. Initializing..."
    git init
    git remote add origin $GITHUB_REPO
fi

# Pull the latest changes
git checkout $BRANCH
git pull origin $BRANCH

# Update the file with the IP address
echo "Local server IP address: $IP_ADDRESS" > $FILE_NAME

# Add, commit, and push the changes
git add $FILE_NAME
git commit -m "Updated server IP address to $IP_ADDRESS"
git push origin $BRANCH
```

### Setting Up as a Scheduled Service

1. **Make the Script Executable**

   ```bash
   chmod +x /path/to/your/script/update_ip.sh
   ```

2. **Create a Systemd Service File**

   Create a new service file for systemd, for example: `/etc/systemd/system/update_ip.service`

   ```ini
   [Unit]
   Description=Update Server IP and Push to GitHub

   [Service]
   ExecStart=/path/to/your/script/update_ip.sh
   WorkingDirectory=/path/to/your/repo
   User=yourusername
   Group=yourgroup

   [Install]
   WantedBy=multi-user.target
   ```

3. **Create a Systemd Timer File**

   Create a new timer file for systemd, for example: `/etc/systemd/system/update_ip.timer`

   ```ini
   [Unit]
   Description=Run Update Server IP Script every hour

   [Timer]
   OnBootSec=10min
   OnUnitActiveSec=1h
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```

4. **Enable and Start the Timer**

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable update_ip.timer
   sudo systemctl start update_ip.timer
   ```

This setup ensures that your script runs every hour and updates the server IP address in the specified GitHub repository.
