#!/bin/bash

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

echo "=========================================="
echo "🔁 Activation au démarrage..."
echo "=========================================="

sudo systemctl enable nginx


echo "=========================================="
echo "✅ Vérification du statut NGINX..."
echo "=========================================="

sudo systemctl status nginx