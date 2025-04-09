#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="destroy.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Function to log messages
log_message() {
    echo -e "${2}${1}${NC}"
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

# Function to handle errors
handle_error() {
    log_message "Error: $1" "$RED"
    log_message "Destruction failed. Check $LOG_FILE for details." "$RED"
    exit 1
}

# Function to destroy Terraform-managed infrastructure
destroy_infrastructure() {
    log_message "Destroying Terraform-managed infrastructure..." "$BLUE"
    terraform destroy -auto-approve >> "$LOG_FILE" 2>&1 || handle_error "Failed to destroy infrastructure"
    log_message "Infrastructure destroyed successfully." "$GREEN"
}

# Main destruction function
destroy() {
    log_message "Starting destruction process..." "$BLUE"
    
    # Create or clear log file
    echo "Destruction Log - Started at $TIMESTAMP" > "$LOG_FILE"
    
    # Execute destruction
    destroy_infrastructure
}

# Execute destruction
destroy