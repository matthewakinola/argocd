#!/bin/bash

# Variable for Python script path
PYTHON_SCRIPT_PATH="./fake_gcr.py"
# "go install github.com/google/go-containerregistry/cmd/crane@latest
# "
# Step 1: Install gcrane
echo "Installing gcrane..."
go install github.com/google/go-containerregistry/cmd/gcrane@latest

# Step 2: Install Python 3 if not installed
echo "Checking if Python 3 is installed..."
if ! command -v python3 &> /dev/null
then
   echo "Python 3 could not be found. Installing now..."
   sudo apt update
   sudo apt install python3
else
   echo "Python 3 is already installed."
fi

# Step 3: Execute Python script
echo "Running the Python script..."
python3 $PYTHON_SCRIPT_PATH
