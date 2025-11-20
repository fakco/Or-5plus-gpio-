#!/bin/bash

set -e 

REPO_URL="https://github.com/orangepi-xunlong/wiringOP.git"
BRANCH="next"

if ! gpio readall >/dev/null 2>&1; then
    echo "wiringOP not found, installing..."

    if [ -e /etc/orangepi-release ]; then
        if ! grep -q "BOARD=orangepi5" /etc/orangepi-release; then
            echo "BOARD=orangepi5" | sudo tee -a /etc/orangepi-release > /dev/null
        fi
    else
        echo "BOARD=orangepi5" | sudo tee /etc/orangepi-release > /dev/null
    fi

    if ! command -v git &> /dev/null; then
        echo "git is not installed. Installing"
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y git
        else
            echo "Please install git manually and run this script again."
            exit 1
        fi
    fi

    if [ ! -d ~/test_gpio ]; then
        git clone -b "$BRANCH" "$REPO_URL" ~/test_gpio
    else
        echo "Directory ~/test_gpio already exists. Skipping clone."
    fi

    cd ~/test_gpio
    if [ -f "build" ]; then
        echo "Building wiringOP (this may take a while)..."
        ./build >/dev/null 2>&1
        echo "Build completed successfully!"
    else
        echo "Build script not found in ~/test_gpio! Cloning may have failed."
        exit 1
    fi
    rm -rf ~/test_gpio

else
    echo "wiringOP already installed"
fi
