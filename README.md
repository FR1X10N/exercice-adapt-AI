# Exercice Adapt-IA

Application web Réalisé en suivant les instructions suivant [ici](Instruction/Readme.md).

---

## Stack

- **Frontend** — Next.js + React-Leaflet
- **Backend** — Node.js + Express
- **Base de données** — PostgreSQL + PostGIS

---

## Prérequis

- [Docker](https://docs.docker.com/get-docker/) et Docker Compose
- `shp2pgsql` (postgis-client) : `sudo apt install postgis`
- `7z` (p7zip) : `sudo apt install p7zip-full`
- `unzip` : `sudo apt install unzip`

---

## Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd exercice-adapt-IA
```

### 2. Configurer les variables d'environnement

```bash
cp .env.example .env
```

### 3. Télécharger et préparer les données

```bash
chmod +x setup.sh
./setup.sh
```

Ce script :
- Télécharge les shapefiles PCI du département 02 depuis le Géoportail IGN
- Télécharge et extrait le fichier MAJIC 2021 (données SIREN)

### 4. Lancer l'application

```bash
docker compose up --build
```

### 5. Importer les parcelles dans la base Docker

Après le premier `docker compose up`, importer les données géographiques :

```bash
shp2pgsql -s 4326 -a -g wkb_geometry data/PARCELLE.SHP parcelles \
  | docker exec -i exercice-adapt-ia-db-1 psql -U ADMIN -d cadastre
```

> Cette étape est nécessaire une seule fois. Les données sont persistées dans le volume Docker `postgres_data`.

- Frontend : http://localhost:3000
- API backend : http://localhost:3001

### 6. Lancer manuellement (sans Docker)

PostgreSQL doit tourner en local avec les paramètres du `.env`.  
Dans le fichier `.env`, changer `DB_HOST=db` en `DB_HOST=localhost`.

```bash
# Backend
cd backend
node src/index.js

# Frontend
cd frontend
npm run dev
```

- Frontend : http://localhost:3000
- API backend : http://localhost:3001