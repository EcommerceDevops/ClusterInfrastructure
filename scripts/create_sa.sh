#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

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

# Crear el Service Account
gcloud iam service-accounts create ${SA_NAME} \
  --display-name="Terraform Executor SA for $ENV" \
  --project=${PROJECT_ID}

# Asignar los roles
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/compute.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/container.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/compute.networkAdmin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/cloudkms.admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/iam.serviceAccountAdmin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/iam.serviceAccountUser"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/resourcemanager.projectIamAdmin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --role="roles/artifactregistry.admin"

gcloud iam service-accounts keys create environments/$ENV/terraform-cluster.key.$ENV.json --iam-account="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"