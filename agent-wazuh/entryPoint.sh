#!/bin/bash

set -e


MANAGER=$(echo "$WAZUH_MANAGER_IP" | xargs)
AUTH_PORT=$(echo "$WAZUH_AUTH_PORT" | xargs)
PASSWORD=$(echo "$WAZUH_AGENT_PASSWORD" | xargs)



echo "Connexion au manager Wazuh : $MANAGER"


# Modifier ossec.conf
sed -i \
"s|<address>.*</address>|<address>${MANAGER}</address>|" \
/var/ossec/etc/ossec.conf


echo "Enregistrement automatique..."


/var/ossec/bin/agent-auth \
-m ${MANAGER} \
-p ${AUTH_PORT}\
-P ${PASSWORD}


echo "Démarrage agent"


/var/ossec/bin/wazuh-control start

tail -f /var/ossec/logs/ossec.log