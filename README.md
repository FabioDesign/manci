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


## Exécuter cette requête après le déploiement du 25/07/2024
```
php artisan migrate --path=/database/migrations/2024_07_09_000000_truncate_ships_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_delete_colum_ships_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_add_colum_ships_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_add_colum_devis_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_add_colum_supplies_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_drop_headers_table.php
php artisan migrate --path=/database/migrations/2024_07_09_000000_create_headers_table.php

php artisan db:seed
```