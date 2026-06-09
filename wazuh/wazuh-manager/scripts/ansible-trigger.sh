#!/bin/bash

# Fichier de log pour tracer l'exécution
LOG_FILE="/var/ossec/logs/test.log"

RULE_ID="${1:-unknown}"
ALERT_LEVEL="${2:-0}"
SOURCE_IP="${3:-0.0.0.0}"
EXTRA_INFO="${4:-none}"

# Nom du conteneur Ansible (doit correspondre à votre docker-compose)
ANSIBLE_CONTAINER="ansible"

# Log de début
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Déclenchement Ansible - Règle: $RULE_ID - IP: $SOURCE_IP" >> "$LOG_FILE"

# Déterminer l'action en fonction de la règle
case $RULE_ID in
    100001|110001|5710)
        # Blocage d'IP (brute force SSH)
        PLAYBOOK="block-ip.yml"
        EXTRA_VARS="ip=$SOURCE_IP rule_id=$RULE_ID"
        ;;
    100101)
        # Modification de fichier critique (ex: sshd_config)
        PLAYBOOK="restore-ssh-config.yml"
        EXTRA_VARS="file=$EXTRA_INFO rule_id=$RULE_ID"
        ;;
    100102)
        # Redémarrage de service
        PLAYBOOK="restart-service.yml"
        EXTRA_VARS="service=$EXTRA_INFO rule_id=$RULE_ID"
        ;;
    *)
        echo "[$(date)] Aucune action définie pour la règle $RULE_ID" >> "$LOG_FILE"
        exit 0
        ;;
esac

# Vérifier que le conteneur Ansible est en cours d'exécution
if ! docker ps --format '{{.Names}}' | grep -q "^${ANSIBLE_CONTAINER}$"; then
    echo "[$(date)] ERREUR: Le conteneur $ANSIBLE_CONTAINER n'est pas en cours d'exécution" >> "$LOG_FILE"
    exit 1
fi

# Exécuter le playbook Ansible
echo "[$(date)] Exécution de $PLAYBOOK avec vars: $EXTRA_VARS" >> "$LOG_FILE"
docker exec "$ANSIBLE_CONTAINER" ansible-playbook "/ansible/playbooks/$PLAYBOOK" -e "$EXTRA_VARS" >> "$LOG_FILE" 2>&1

# Vérifier le résultat
if [ $? -eq 0 ]; then
    echo "[$(date)] Succès: $PLAYBOOK exécuté avec succès" >> "$LOG_FILE"
else
    echo "[$(date)] ERREUR: Échec de l'exécution de $PLAYBOOK" >> "$LOG_FILE"
fi

exit 0