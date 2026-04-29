#!/bin/bash
# Script de mise en place des données cadastrales.
# Télécharge les shapefiles PCI du département 02 depuis le Géoportail IGN,
# les extrait et les importe dans PostgreSQL/PostGIS via ogr2ogr.
set -e

# Charger les variables d'environnement
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Fichier .env introuvable. Copie .env.example en .env et remplis les valeurs."
  exit 1
fi

DATA_DIR="./data"
ARCHIVE="$DATA_DIR/pci_d02.7z"
DOWNLOAD_URL="https://data.geopf.fr/telechargement/download/PARCELLAIRE-EXPRESS/PARCELLAIRE-EXPRESS_1-1__SHP_LAMB93_D002_2025-12-01/PARCELLAIRE-EXPRESS_1-1__SHP_LAMB93_D002_2025-12-01.7z"

# Vérifier les dépendances
command -v shp2pgsql >/dev/null 2>&1 || { echo "shp2pgsql introuvable. Installe postgis : sudo apt install postgis"; exit 1; }
command -v psql >/dev/null 2>&1 || { echo "psql introuvable. Installe postgresql-client : sudo apt install postgresql-client"; exit 1; }
command -v 7z >/dev/null 2>&1 || { echo "7z introuvable. Installe p7zip : sudo apt install p7zip-full"; exit 1; }

mkdir -p "$DATA_DIR"

# 1. Téléchargement
if [ ! -f "$ARCHIVE" ]; then
  echo "Téléchargement des données PCI département 02..."
  curl -L -o "$ARCHIVE" "$DOWNLOAD_URL"
else
  echo "Archive déjà présente, téléchargement ignoré."
fi

# 2. Extraction
echo "Extraction de l'archive..."
7z x "$ARCHIVE" -o"$DATA_DIR" -y

# 3. Trouver le fichier SHP
SHP_FILE=$(find "$DATA_DIR" -name "PARCELLE.SHP" | head -1)
if [ -z "$SHP_FILE" ]; then
  echo "Fichier PARCELLE.SHP introuvable dans $DATA_DIR"
  exit 1
fi

# 4. Import dans PostGIS
echo "Import des parcelles dans PostGIS..."
# DB_HOST peut être surchargé en ligne de commande : DB_HOST=db ./setup.sh
PSQL_CMD="psql -h ${DB_HOST} -p ${DB_PORT:-5432} -U ${DB_USER} -d ${DB_NAME}"
export PGPASSWORD="${DB_PASSWORD}"
shp2pgsql -s 4326 -a -g wkb_geometry "$SHP_FILE" parcelles | $PSQL_CMD

echo "Import terminé avec succès."

# 5. Extraction du fichier MAJIC (données SIREN, dept 02)
MAJIC_DIR="./data/majic"
MAJIC_ZIP="$MAJIC_DIR/parcelles_pm_2021.zip"
MAJIC_TXT="$MAJIC_DIR/PM_21_NB_020.txt"

mkdir -p "$MAJIC_DIR"

if [ ! -f "$MAJIC_TXT" ]; then
  if [ ! -f "$MAJIC_ZIP" ]; then
    echo "Téléchargement des données MAJIC (personnes morales dept 02)..."
    curl -L -o "$MAJIC_ZIP" "https://www.data.gouv.fr/api/1/datasets/r/d3974fbb-749a-4193-9e33-0f5697aa6ab0"
  fi
  echo "Extraction du fichier MAJIC dept 02..."
  unzip -j "$MAJIC_ZIP" "*/PM_21_NB_020.txt" -d "$MAJIC_DIR"
else
  echo "Fichier MAJIC déjà extrait, étape ignorée."
fi

echo "Setup terminé. Lance 'docker compose up' ou importe manuellement."
