#!/bin/bash
# evitar criar serviço no cluster errado
contexto_atual=$(kubectl config current-context)
echo "[WARN] Cluster: $contexto_atual"
read -p "Confirma o cluster? (y/n) " yynn

case $yynn in
    [Yy]* )
        if kubectl get namespace backend > /dev/null 2>&1; then
            echo "Namespace confirmado"
            helm upgrade --namespace backend comentarios-service comentarios-service-api-chart -f comentarios-service-api-chart/env/prod.yaml
        else
            echo "Namespace 'backend' não encontrado. Algo de errado.."
        fi
        # Aqui o helm poderia ele mesmo criar o namespace, porém não acho boa ideia.

        ;;
    [Nn]* )
        echo "Muito cuidado."
        exit 1
        ;;
    * )
        echo "Confirme o cluster que vc está com Y/N"
        exit 10
        ;;
esac