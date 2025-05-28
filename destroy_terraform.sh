#!/bin/bash

set -e  # Detener ejecución si ocurre un error

# Ir al directorio del script
cd "$(dirname "$0")"

terraform destroy -target=module.ingress -var-file=terraform.tfvars -auto-approve
terraform destroy -target=module.namespaces -var-file=terraform.tfvars -auto-approve
terraform destroy -target=module.node_pools -var-file=terraform.tfvars -auto-approve
terraform destroy -var-file=terraform.tfvars -auto-approve


