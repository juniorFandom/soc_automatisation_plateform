#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo "=========================================="
echo "🔄 Mise à jour du système..."
echo "=========================================="
sudo apt update -y && sudo apt upgrade -y

echo "=========================================="
echo "📦 Installation de NGINX..."
echo "=========================================="
sudo apt install nginx -y

echo "=========================================="
echo "🚀 Configuration du service NGINX..."
echo "=========================================="
sudo cp config/nginx.conf /etc/nginx/nginx.conf

echo "=========================================="
echo "🚀 Démarrage du service NGINX..."
echo "=========================================="
sudo systemctl start nginx
sudo systemctl enable nginx

echo "=========================================="
echo "✅ Vérification du statut NGINX..."
echo "=========================================="
sudo systemctl status nginx --no-pager

echo "=========================================="
echo "📦 Installation de Git et Docker (si nécessaire)..."
echo "=========================================="
sudo apt install git docker-compose -y

echo "=========================================="
echo "📥 Clonage du repo GitHub..."
echo "=========================================="
# Supprime le dossier s'il existe déjà
rm -rf soc_automatisation_plateform
git clone https://github.com/juniorFandom/soc_automatisation_plateform.git

echo "=========================================="
echo "🐳 Lancement de Docker Compose..."
echo "=========================================="
cd soc_automatisation_plateform
sudo docker compose up -d

echo "=========================================="
echo "✅ Déploiement terminé !"
echo "=========================================="