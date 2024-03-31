#!/bin/bash
# evitar criar serviço no cluster errado
contexto_atual=$(kubectl config current-context)
echo "[WARN] Cluster: $contexto_atual"
read -p "Confirma o cluster? (y/n) " yynn

case $yynn in
    [Yy]* )
        if kubectl get namespace monitoring > /dev/null 2>&1; then
            echo "Namespace 'monitoring' já existe."
        else
            echo "Namespace 'monitoring' não encontrado. Criando..."
            kubectl create namespace monitoring
            echo "Namespace 'monitoring' criado com sucesso."
        fi
        # Aqui o helm poderia ele mesmo criar o namespace, porém não acho boa ideia.
        helm install --namespace monitoring stack-monitoramento kube-prometheus-stack
        if [ $? -ne 0]; # workaround devido ao tempo
          helm upgrade --namespace monitoring stack-monitoramento kube-prometheus-stack
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