#!/bin/bash
set -e

echo "=========================================="
echo "🔧 Conteneur Ansible personnalisé - Démarré"
echo "=========================================="
echo "📌 Ansible version: $(ansible --version | head -1)"
echo "📌 Collections installées:"
ansible-galaxy collection list | head -5
echo "=========================================="

# ============================================
# Configuration de l'agent Wazuh
# ============================================

WAZUH_MANAGER_IP="${WAZUH_MANAGER_IP}"
WAZUH_AUTH_PORT="${WAZUH_AUTH_PORT}"
WAZUH_AGENT_PASSWORD="${WAZUH_AGENT_PASSWORD}"

# Enrôler l'agent s'il n'est pas déjà enregistré (vérifie que le fichier n'est pas vide)
if [ ! -s /var/ossec/etc/client.keys ]; then
    echo "🔐 Enrôlement de l'agent Wazuh auprès du Manager ($WAZUH_MANAGER_IP:$WAZUH_AUTH_PORT)..."
    # Enrôlement avec mot de passe 
    /var/ossec/bin/agent-auth -m "$WAZUH_MANAGER_IP" -p "$WAZUH_AUTH_PORT" -P "$WAZUH_AGENT_PASSWORD"
    echo "✅ Agent enrôlé avec succès"
else
    echo "✅ Agent déjà enrôlé"
fi

# Démarrer l'agent s'il n'est pas déjà en cours
if ! pgrep -f "wazuh-agentd" > /dev/null; then
    echo "🚀 Démarrage de l'agent Wazuh (mode foreground)..."
    /var/ossec/bin/wazuh-agentd -f &
    echo "✅ Agent Wazuh démarré"
else
    echo "✅ Agent Wazuh déjà en cours d'exécution"
fi

# ============================================
# Vérifications Ansible
# ============================================

if [ -f "/ansible/inventory/hosts.ini" ]; then
    echo "✅ Inventaire chargé: /ansible/inventory/hosts.ini"
else
    echo "⚠️ Aucun inventaire trouvé, création d'un inventaire par défaut"
    echo "[localhost]" > /ansible/inventory/hosts.ini
    echo "localhost ansible_connection=local" >> /ansible/inventory/hosts.ini
fi

PLAYBOOK_COUNT=$(ls -1 /ansible/playbooks/*.yml 2>/dev/null | wc -l)
echo "✅ $PLAYBOOK_COUNT playbook(s) disponible(s)"

if [ $# -gt 0 ]; then
    echo "🚀 Exécution: $@"
    exec "$@"
else
    echo "✅ Conteneur prêt à recevoir des commandes Ansible"
    tail -f /dev/null
fi