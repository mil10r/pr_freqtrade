#!/bin/bash

check_command_success() {
    if [ $? -eq 0 ]; then
        echo "Command '$1' succeeded. Continuing with the script."
        # Continue with your script logic here
    else
        echo "Command '$1' failed. Exiting the script."
        exit 1  # You can exit with a non-zero status to indicate an error
    fi
}

docker build -t pr_freqtrade -t ghcr.io/mil10r/pr_freqtrade:latest .

check_command_success "build dokcer image pr_freqtrade"

source .env

check_command_success "source .env file"

echo $CR_PAT | docker login ghcr.io -u mil10r --password-stdin

check_command_success "docker login to ghcr.io"

docker push ghcr.io/mil10r/pr_freqtrade:latest

check_command_success "push pr_freqtrade to ghcr.io"