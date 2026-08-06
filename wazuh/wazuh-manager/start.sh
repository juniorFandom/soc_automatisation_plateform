#!/bin/bash
set -e

echo "[+] Starting Wazuh Manager container..."

# =========================
# VARIABLES
# =========================
INDEXER_HOST=${INDEXER_HOST:-wazuh-indexer}

echo "[+] Using indexer: ${INDEXER_HOST}"

# =========================
# CHECK FILEBEAT CONFIG
# =========================
if [ ! -f /etc/filebeat/filebeat.yml ]; then
    echo "[ERROR] /etc/filebeat/filebeat.yml not found."
    exit 1
fi

echo "[+] Filebeat configuration:"
ls -l /etc/filebeat/filebeat.yml

# =========================
# START WAZUH MANAGER
# =========================
echo "[+] Starting Wazuh Manager..."
/var/ossec/bin/wazuh-control start

# =========================
# WAIT FOR MANAGER
# =========================
sleep 5

# =========================
# START FILEBEAT
# =========================
echo "[+] Starting Filebeat..."

filebeat -e \
    -c /etc/filebeat/filebeat.yml \
    >/var/log/filebeat.log 2>&1 &

sleep 5

# =========================
# TEST FILEBEAT
# =========================
echo "[+] Testing Filebeat configuration..."
filebeat test config -c /etc/filebeat/filebeat.yml || true

echo "[+] Testing Filebeat output..."
filebeat test output -c /etc/filebeat/filebeat.yml || true

# =========================
# STATUS
# =========================
echo
echo "[+] Running processes:"
ps -ef | grep -E "wazuh|filebeat" | grep -v grep || true

echo
echo "[+] Wazuh Manager is running."

# =========================
# KEEP CONTAINER ALIVE
# =========================
tail -F \
    /var/ossec/logs/ossec.log \
    /var/log/filebeat.log