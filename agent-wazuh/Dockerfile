FROM debian:12-slim

RUN apt update && apt install -y \
    curl \
    gnupg \
    apt-transport-https \
    procps \
    && rm -rf /var/lib/apt/lists/*


# Ajouter clé Wazuh
RUN curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH \
    | gpg --no-default-keyring \
    --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg \
    --import \
    && chmod 644 /usr/share/keyrings/wazuh.gpg


# Ajouter dépôt Wazuh
RUN echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] \
    https://packages.wazuh.com/4.x/apt/ stable main" \
    > /etc/apt/sources.list.d/wazuh.list


# Installer agent
RUN apt update && apt install -y wazuh-agent \
    && rm -rf /var/lib/apt/lists/*

# Copier script de configuration
COPY entryPoint.sh /entryPoint.sh
RUN chmod +x /entryPoint.sh


ENTRYPOINT ["/entryPoint.sh"]