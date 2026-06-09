#!/bin/bash
set -e

echo "[+] Starting Wazuh Manager container..."

# =========================
# INDEXER (env only)
# =========================
INDEXER_HOST=${INDEXER_HOST:-wazuh-indexer}

echo "[+] Using indexer: $INDEXER_HOST"

# =========================
# CHECK CONFIG FILES
# =========================
if [ ! -f /etc/filebeat/filebeat.yml ]; then
  echo "[ERROR] filebeat.yml not found. Mount it as volume!"
  exit 1
fi

# =========================
# START WAZUH MANAGER
# =========================
echo "[+] Starting Wazuh Manager..."
/var/ossec/bin/wazuh-control start

# =========================
# START FILEBEAT
# =========================
echo "[+] Starting Filebeat..."
service filebeat start || systemctl start filebeat || filebeat -e &

# =========================
# WAIT & TEST
# =========================
sleep 5

echo "[+] Testing Filebeat connection..."
filebeat test output || true

echo "[+] Wazuh Manager is running"

# =========================
# KEEP CONTAINER ALIVE
# =========================
tail -f /var/ossec/logs/ossec.log