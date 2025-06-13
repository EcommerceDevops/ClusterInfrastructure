#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Go to the script's directory
cd "$(dirname "${BASH_SOURCE[0]}")"/..

# Get the environment from the first argument
ENV=$1

# Validate the provided environment
if [ -z "$ENV" ]; then
    echo "ERROR: No environment specified. Please provide 'devops', 'staging', or 'prod'."
    exit 1
elif [ "$ENV" != "staging" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "devops" ]; then
    echo "ERROR: Invalid environment '$ENV'. Valid options are 'devops', 'staging', or 'prod'."
    exit 1
fi

echo "--- Environment Selection ---"
echo "🔹 Selecting environment: $ENV..."

# Check if Terraform is already initialized
if [ ! -d ".terraform" ]; then
    echo "🔹 Initializing Terraform..."
    terraform init
else
    echo "✅ Terraform is already initialized. Skipping init..."
fi

echo "--- Terraform Workspace Selection ---"
echo "🔹 Selecting Terraform workspace: $ENV..."
terraform workspace select "$ENV"

KEY_FILE="environments/$ENV/terraform-cluster.key.$ENV.json"

# Usando -f para verificar si existe el key.json
if [ -f "$KEY_FILE" ]; then
    echo "KEY file '$KEY_FILE' exist."
    echo "file exist and will be use ----->."
    
else
    echo "KEY file '$KEY_FILE' does not exist."
    echo "Creating Service Account key..."

    ./scripts/create_sa.sh "$ENV"
fi

# --- Terraform Configuration ---
echo "--- Terraform Configuration ---"

VAR_FILE="environments/$ENV/terraform.$ENV.tfvars"

# Format code
echo "🔹 Running terraform fmt..."
terraform fmt

# Validate configuration
echo "🔹 Validating configuration..."
terraform validate

# --- Infrastructure Deployment ---
echo "--- Infrastructure Deployment ---"

# Check if machines are already created
EXISTING_MACHINES=$(terraform state list | grep "google_container_node_pool.primary_nodes" || true)

if [ -n "$EXISTING_MACHINES" ]; then
    echo "✅ Node pools already created. Skipping terraform apply..."
else
    # Show the plan
    echo "🔹 Generating plan..."
    terraform plan -var-file="$VAR_FILE"

fi