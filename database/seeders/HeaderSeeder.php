<?php

namespace Database\Seeders;

use App\Models\Header;
use Illuminate\Database\Seeder;

class HeaderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run(){
        Header::create([
            "status" => "1",
            "libelle" => "MANCI",
            "header" => "manci.jpg",
            "footer" => "Maintenance Navire Cote d’Ivoire - 18 BP 3422 ABIDJAN 18\r\nTEL : 27 24 32 64 60 / CEL: 07 07 70 55 38 -Email: maintenancenavireci@yahoo.fr\r\nRC n° CI-ABJ-2011-B-1003-N° CC-1103672C\r\nC/Régime d’imposition : Réel normal CDI CME ABIDJAN SUD",
        ]);
        
        Header::create([
            "status" => "1",
            "libelle" => "IMNS",
            "header" => "imns.jpg",
            "footer" => "IVOIRIENNE DE MAINTENANCE NAVALE & SERVICE - SARL AU CAPITAL DE 2 500 000 FCFA\r\n10 BP 1377 ABIDJAN 10 Tel: 09 70 07 30 / 47 61 91 60 FAX: + 225 21 25 08 14, NO RC: CI-ABJ-2015-B-27827, CCNO: 1556006 S14\r\nCOMPTE NUMERO : Cli12 01001 013309830003 47 VERSUS BANK",
        ]);
        
        Header::create([
            "status" => "1",
            "libelle" => "SORENA",
            "header" => "sorena.jpg",
            "footer" => "SOCIETE DE REPARATION NAVALE - TREICHVILLE PORT DE PECHE 18 BP 765 ABIDJAN 18\r\nTEL/FAX : 21 24 66 37, CEL : 08 93 19 10 EMAIL : secretariat@sorena-ci.ci\r\nRCCM : CI-ABJ-2016-B-15561-CC : 1630438D / RÉGIME D\'IMPOSITION : RÉEL SIMPLIFIÉ CDI TRECHVILLE II",
        ]);
        
    }
}
