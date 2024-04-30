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
        # Verificação do sucesso do helm install
        helm install --namespace monitoring stack-monitoramento kube-prometheus-stack
        if [ $? -ne 0 ]; then # corrigido o erro de sintaxe aqui
            echo "Erro ao instalar ou atualizar o chart."
            exit 1
        else
            echo "Chart instalado com sucesso."
        fi
        ;;
    [Nn]* )
        echo "Muito cuidado."
        exit 1
        ;;
    * )
        echo "Confirme o cluster que você está com Y/N"
        exit 10
        ;;
esac

