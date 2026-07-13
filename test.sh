
# executable test script to verify the Wazuh Active Response configuration and functionality qui explique les étapes de test pour vérifier la configuration et le fonctionnement de l'Active Response de Wazuh. Il effectue les actions suivantes :
# 1. Vérifie la configuration Active Response dans le fichier ossec.conf du manager Wazuh.
# 2. Vérifie que l'agent Wazuh est connecté au manager en recherchant le mot "Connected" dans le fichier ossec.log de l'agent.
# 3. Liste les agents enregistrés sur le manager Wazuh en utilisant la commande manage_agents.
# 4. Déclenche une alerte en modifiant un fichier surveillé (/etc/security/opasswd) sur l'agent Wazuh.
# 5. Attend 5 secondes pour permettre au manager de traiter l'alerte.   
# 6. Vérifie que l'alerte a été générée en recherchant les niveaux d'alerte 7 à 9 dans le fichier alerts.json du manager Wazuh.
# 7. Vérifie que l'Active Response a été exécutée en consultant le fichier test.log du manager Wazuh.   

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