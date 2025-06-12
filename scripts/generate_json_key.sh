#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

# Change to script's directory (ensure relative paths work correctly)
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

# Load the environment variables from the corresponding .env file
ENV_FILE="environments/$ENV/.env.$ENV"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: Environment file '$ENV_FILE' not found."
    exit 1
fi

# Export variables from the .env file
source "$ENV_FILE"

# --- Generar la clave JSON para la Service Account existente ---

echo "Generating JSON key for service account: ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com in project ${PROJECT_ID}..."

# Check if the service account exists before trying to generate a key for it
if ! gcloud iam service-accounts describe "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --project="${PROJECT_ID}" &> /dev/null; then
    echo "ERROR: Service account '${SA_NAME}' does not exist in project '${PROJECT_ID}'. Please create it first."
    exit 1
fi

# Generate the key file
KEY_FILE_PATH="environments/$ENV/terraform-cluster.key.$ENV.json"
gcloud iam service-accounts keys create "${KEY_FILE_PATH}" \
  --iam-account="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}"

echo "JSON key file generated successfully at: ${KEY_FILE_PATH}"
echo "Remember to keep this key file secure and do not share it publicly."