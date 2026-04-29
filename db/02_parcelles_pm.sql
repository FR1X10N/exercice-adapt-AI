-- Crée la table parcelles_pm, importe le fichier CSV du département 02

-- Table des parcelles (source MAJIC 2021)
CREATE TABLE IF NOT EXISTS parcelles_pm (
  departement        VARCHAR(2),
  code_direction     VARCHAR(1),
  code_commune       VARCHAR(3),
  nom_commune        VARCHAR(100),
  prefixe            VARCHAR(3),
  section            VARCHAR(2),
  num_plan           VARCHAR(4),
  num_voirie         VARCHAR(20),
  indice_rep         VARCHAR(10),
  code_voie_majic    VARCHAR(10),
  code_voie_rivoli   VARCHAR(10),
  nature_voie        VARCHAR(50),
  nom_voie           VARCHAR(200),
  contenance         VARCHAR(20),
  suf                VARCHAR(10),
  nature_culture     VARCHAR(10),
  contenance_suf     VARCHAR(20),
  code_droit         VARCHAR(10),
  num_majic          VARCHAR(20),
  num_siren          VARCHAR(9),
  groupe_personne    VARCHAR(10),
  forme_juridique    VARCHAR(10),
  forme_juridique_abr VARCHAR(10),
  denomination       VARCHAR(200)
);

-- Import du fichier MAJIC
COPY parcelles_pm FROM '/majic_data/PM_21_NB_020.txt'
  WITH (FORMAT CSV, DELIMITER ';', HEADER TRUE, QUOTE '"', ENCODING 'LATIN1');

-- Index IDU
CREATE INDEX IF NOT EXISTS idx_pm_idu ON parcelles_pm (
  (departement || code_commune || REPLACE(prefixe, ' ', '0') || section || lpad(num_plan, 4, '0'))
);
