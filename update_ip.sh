#!/bin/bash

# Variables
REPO_DIR="//home/shai/workspace/ttt"
FILE_NAME="legion.txt"
GITHUB_REPO="https://github.com/shaibachar/ttt.git"
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
echo "$IP_ADDRESS" > $FILE_NAME

# Add, commit, and push the changes
git add $FILE_NAME
git commit -m "Updated server IP address to $IP_ADDRESS"
git push origin $BRANCH