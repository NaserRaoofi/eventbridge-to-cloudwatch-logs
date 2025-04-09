#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="deployment.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Function to log messages
log_message() {
    echo -e "${2}${1}${NC}"
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

# Function to handle errors
handle_error() {
    log_message "Error: $1" "$RED"
    log_message "Deployment failed. Check $LOG_FILE for details." "$RED"
    exit 1
}

# Function to check prerequisites
check_prerequisites() {
    log_message "Checking prerequisites..." "$BLUE"
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        handle_error "AWS CLI is not installed. Please install it first."
    fi
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        handle_error "Terraform is not installed. Please install it first."
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        handle_error "AWS credentials not configured. Please run 'aws configure' first."
    fi
    
    # Check AWS region - more lenient check
    if ! aws ec2 describe-regions --region eu-west-2 &> /dev/null; then
        log_message "Warning: Cannot access eu-west-2 region. Will try to use default region." "$YELLOW"
        # Try to get the default region
        DEFAULT_REGION=$(aws configure get region)
        if [ -z "$DEFAULT_REGION" ]; then
            handle_error "No AWS region configured. Please set a default region with 'aws configure'."
        fi
        log_message "Using default region: $DEFAULT_REGION" "$YELLOW"
    else
        log_message "Region eu-west-2 is accessible." "$GREEN"
    fi
    
    log_message "All prerequisites met." "$GREEN"
}

# Function to initialize Terraform
init_terraform() {
    log_message "Initializing Terraform..." "$BLUE"
    terraform init -upgrade || handle_error "Failed to initialize Terraform"
    log_message "Terraform initialized successfully." "$GREEN"
}

# Function to validate Terraform configuration
validate_terraform() {
    log_message "Validating Terraform configuration..." "$BLUE"
    terraform validate || handle_error "Terraform configuration validation failed"
    log_message "Terraform configuration is valid." "$GREEN"
}

# Function to create execution plan
create_plan() {
    log_message "Creating execution plan..." "$BLUE"
    terraform plan -out=tfplan -detailed-exitcode \
        -var="name=aws-service-monitoring" \
        -var="environment=production" \
        -var="log_retention_days=30" \
        -var="tags={Environment=\"production\",Project=\"aws-service-monitoring\"}"
    PLAN_EXIT_CODE=$?
    
    case $PLAN_EXIT_CODE in
        0)
            log_message "No changes needed. Infrastructure is up-to-date." "$GREEN"
            return 0
            ;;
        1)
            handle_error "Error creating execution plan"
            ;;
        2)
            log_message "Changes detected. Proceeding with deployment..." "$YELLOW"
            return 1
            ;;
        *)
            handle_error "Unexpected error during plan creation"
            ;;
    esac
}

# Function to apply changes
apply_changes() {
    log_message "Applying changes..." "$BLUE"
    terraform apply -auto-approve "tfplan" >> "$LOG_FILE" 2>&1 || handle_error "Failed to apply changes"
    log_message "Changes applied successfully." "$GREEN"
}

# Function to get outputs
get_outputs() {
    log_message "Retrieving deployment outputs..." "$BLUE"
    
    # Get dashboard URL
    DASHBOARD_URL=$(terraform output -raw dashboard_url 2>/dev/null)
    if [ -n "$DASHBOARD_URL" ]; then
        log_message "CloudWatch Dashboard URL: $DASHBOARD_URL" "$GREEN"
    fi
    
    # Get other outputs
    log_message "Deployment completed successfully!" "$GREEN"
    log_message "Check $LOG_FILE for detailed logs." "$BLUE"
}

# Main deployment function
deploy() {
    log_message "Starting deployment process..." "$YELLOW"
    
    # Create or clear log file
    echo "Deployment Log - Started at $TIMESTAMP" > "$LOG_FILE"
    
    # Execute deployment steps
    check_prerequisites
    init_terraform
    validate_terraform
    
    if create_plan; then
        log_message "No changes needed. Deployment complete." "$GREEN"
        return
    fi
    
    apply_changes
    get_outputs
}

# Execute deployment
deploy 