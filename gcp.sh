#!/bin/bash

# Variable for Python script path
PYTHON_SCRIPT_PATH="./gcp.py"

#Step 1: Install Go if not installed
echo "Checking if Go is installed..."
if ! command -v go &> /dev/null
then
   echo "Go could not be found. Installing now..."
   sudo apt update
   sudo apt install golang
else
   echo "Go is already installed."
fi

# Step 2: Install gcrane
echo "Installing gcrane..."
go install github.com/google/go-containerregistry/cmd/gcrane@latest

# Step 3: Export PATH
echo "Exporting GOPATH..."
export PATH="$(go env GOPATH)/bin:$PATH"

#NOTE:------------>>>>>>>>>>>>>>
#need to add the path to bashrc or zshrc
#vi ~/.bashrc --> export PATH="$(go env GOPATH)/bin:$PATH

# Step 4: Install Python 3 if not installed
echo "Checking if Python 3 is installed..."
if ! command -v python3 &> /dev/null
then
   echo "Python 3 could not be found. Installing now..."
   sudo apt update
   sudo apt install python3
else
   echo "Python 3 is already installed."
fi

# Step 5: Execute Python script
echo "Running the Python script..."
python3 $PYTHON_SCRIPT_PATH
