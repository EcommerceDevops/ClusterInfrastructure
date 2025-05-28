#!/bin/bash

set -e  # Detener ejecución si ocurre un error

# Ir al directorio del script
cd "$(dirname "$0")"

VAR_FILE="terraform.tfvars"

# Verificar si Terraform ya está inicializado
if [ ! -d ".terraform" ]; then
    echo "🔹 Inicializando Terraform..."
    terraform init
else
    echo "✅ Terraform ya está inicializado. Saltando init..."
fi

# Formatear código
echo "🔹 Ejecutando terraform fmt..."
terraform fmt

# Validar configuración
echo "🔹 Validando configuración..."
terraform validate

# Verificar si las máquinas ya están creadas
EXISTING_MACHINES=$(terraform state list | grep "google_container_node_pool.primary_nodes" || true)

if [ -n "$EXISTING_MACHINES" ]; then
    echo "✅ Node pools ya creados. Saltando terraform apply..."
else
    # Mostrar el plan
    echo "🔹 Generando plan..."
    terraform plan -var-file="$VAR_FILE"

    # Aplicar cambios
    echo "🔹 Aplicando cambios..."
    terraform apply -auto-approve -var-file="$VAR_FILE"
fi

# Obtener y mostrar IPs y nombres de las máquinas
echo "🔹 Obteniendo salida"
terraform output

echo "✅ ¡Infraestructura lista!"
