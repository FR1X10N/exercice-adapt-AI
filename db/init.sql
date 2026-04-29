-- Script d'initialisation de la base de données PostgreSQL.
-- Crée l'extension PostGIS, la table des parcelles et l'index spatial.

-- Activation PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Table des parcelles
CREATE TABLE IF NOT EXISTS parcelles (
  ogc_fid     SERIAL PRIMARY KEY,
  idu         VARCHAR(14),
  numero      VARCHAR(4),
  feuille     NUMERIC(2,0),
  section     VARCHAR(2),
  code_dep    VARCHAR(2),
  nom_com     VARCHAR(45),
  code_com    VARCHAR(3),
  com_abs     VARCHAR(3),
  code_arr    VARCHAR(3),
  contenance  NUMERIC(9,0),
  wkb_geometry geometry(MULTIPOLYGON, 4326)
);

-- Index requêtes géographiques
CREATE INDEX IF NOT EXISTS parcelles_geom_idx
  ON parcelles USING GIST (wkb_geometry);
