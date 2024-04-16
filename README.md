## Exécuter cette requête après le déploiement du 19/03/2024

ALTER TABLE proforma ADD see_price ENUM('0','1') NOT NULL DEFAULT '1' AFTER see_rem;
UPDATE rights SET libelle='Supprimer' WHERE id=8;
ALTER TABLE commandes DROP display;

TRUNCATE devis;
TRUNCATE proforma;
TRUNCATE commandes;
TRUNCATE devis_ttr;
TRUNCATE devis_txt;
TRUNCATE statistic;