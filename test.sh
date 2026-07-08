#!/bin/bash
# 1. Vérifier la configuration Active Response
echo "=== ÉTAPE 1 : Vérification configuration ==="
docker exec wazuh-manager grep -A5 "<active-response>" /var/ossec/etc/ossec.conf

# 2. Vérifier que l'agent est connecté
echo -e "\n=== ÉTAPE 2 : Vérification agent connecté ==="
docker exec ansible grep "Connected" /var/ossec/logs/ossec.log

# 3. Lister les agents depuis le manager
echo -e "\n=== ÉTAPE 3 : Liste des agents ==="
docker exec wazuh-manager /var/ossec/bin/manage_agents -l

# 4. Déclencher une alerte (modification fichier surveillé)
echo -e "\n=== ÉTAPE 4 : Déclenchement alerte ==="
docker exec ansible touch /etc/security/opasswd
echo " Alerte déclenchée (touch /etc/security/opasswd)"

# 5. Attendre 5 secondes
echo -e "\n=== ÉTAPE 5 : Attente 5 secondes ==="
sleep 5

# 6. Vérifier l'alerte générée
echo -e "\n=== ÉTAPE 6 : Vérification alerte ==="
docker exec wazuh-manager tail -5 /var/ossec/logs/alerts/alerts.json | grep -E '"level":[7-9]'

# 7. Vérifier l'Active Response
echo -e "\n=== ÉTAPE 7 : Vérification Active Response ==="
docker exec wazuh-manager tail -5 /var/ossec/logs/test.log

# 8. Test rapide final
echo -e "\n=== ÉTAPE 8 : Test rapide final ==="
docker exec ansible touch /etc/security/opasswd 2>/dev/null
sleep 3
docker exec wazuh-manager tail -3 /var/ossec/logs/test.log

echo -e "\n=== TEST TERMINÉ ==="