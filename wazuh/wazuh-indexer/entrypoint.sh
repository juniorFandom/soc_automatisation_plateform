#!/bin/bash

set -e

echo "🚀 Starting Wazuh Indexer..."

# =========================
# START OPENSEARCH
# =========================

/usr/share/wazuh-indexer/bin/opensearch &
OPENSEARCH_PID=$!

echo "⏳ Waiting OpenSearch..."

READY=0

for i in $(seq 1 60)
do

    # Vérifie que le processus existe toujours
    if ! kill -0 "$OPENSEARCH_PID" 2>/dev/null; then
        echo "❌ OpenSearch crashed during startup"

        wait "$OPENSEARCH_PID"
        exit 1
    fi

    # Vérifie si le port HTTPS répond
    if curl -k -s https://localhost:9200 >/dev/null 2>&1; then
        READY=1
        break
    fi

    sleep 5
done

if [ "$READY" -ne 1 ]; then
    echo "❌ Timeout waiting for OpenSearch"
    kill "$OPENSEARCH_PID" || true
    exit 1
fi

echo "🟢 OpenSearch is up"

# =========================
# SECURITY CONFIG
# =========================

SEC_DIR="/usr/share/wazuh-indexer/opensearch-security"

if [ -d "$SEC_DIR" ] && [ -f "$SEC_DIR/config.yml" ]; then

    echo "📦 Security configuration detected"

    /usr/share/wazuh-indexer/plugins/opensearch-security/tools/securityadmin.sh \
        -cd "$SEC_DIR" \
        -icl \
        -nhnv \
        -cacert /etc/wazuh-indexer/certs/root-ca.pem \
        -cert /etc/wazuh-indexer/certs/admin.pem \
        -key /etc/wazuh-indexer/certs/admin-key.pem \
        -h localhost \
        -p 9200 || true

    echo "🟢 Security initialized"

else

    echo "⚠️ No security configuration found"

fi

# =========================
# SIGNAL HANDLING
# =========================

trap "echo '🛑 Stopping OpenSearch'; kill $OPENSEARCH_PID; exit 0" SIGTERM SIGINT

wait "$OPENSEARCH_PID"