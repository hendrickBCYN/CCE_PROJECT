#!/bin/bash
# Script de déploiement CCE v2
# Usage : ./deploy.sh

set -e

echo "Déploiement CCE v2"

# Vérification du fichier .env
if [ ! -f .env ]; then
  echo "ERREUR : fichier .env manquant"
  exit 1
fi

# Mise à jour du code source
echo "[1/4] Mise à jour du code source..."
git pull
git submodule update --init --recursive

# Construction des images Docker
echo "[2/4] Construction des images Docker..."
docker compose build

# Lancement des conteneurs
echo "[3/4] Lancement des conteneurs..."
docker compose up -d

# Vérification
echo "[4/4] Vérification des services..."
sleep 5
docker compose ps

echo "Déploiement terminé"
echo "Application accessible sur http://localhost:8080"