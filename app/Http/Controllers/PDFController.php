<?php

namespace App\Http\Controllers;

use PDF;
use Myhelper;
use NumberFormatter;
use App\Models\Devis;
use App\Models\Billing;
use App\Models\Commande;
use App\Models\DevisTyp;
use App\Models\DevisTtr;
use App\Models\DevisTxt;
use App\Models\Proforma;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\App;

class PDFController extends Controller
{
	// Generate PDF Devis
    public function pdfdevis(request $request){
		$id = $request->id;
		$devis = Devis::select('reference', 'date_at', 'filename', 'header', 'footer', 'bill_addr.libelle AS bill_addr', 'ships.libelle AS libship', 'content', 'mt_ht', 'mt_rem', 'mt_ttc', 'mt_euro', 'mt_tva', 'sum_rem', 'sum_tva', 'see_rem', 'see_tva', 'see_euro')
		->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id')
		->join('headers', 'headers.id', '=', 'devis.header_id')
		->leftJoin('ships', 'ships.id', '=', 'devis.ship_id')
		->where('devis.id', $id)
		->first();
		//Header
		$devis->header = public_path('assets/media/headers/'.$devis->header);
		//Chiifre en lettre
		$int2str = new NumberFormatter('fr', NumberFormatter::SPELLOUT);
		$string = $int2str->format($devis->mt_ttc);
		$array = Str::of($string)->explode('virgule');
		$int2string = Str::ucfirst($array[0]);
		//Requete Read
		$i = 1;
		$query = [];
		$query1 = DevisTtr::whereDevisId($id)->get();
		foreach($query1 as $data1):
			$query[] = '<tr><td class="fw-bold border-top">'.$i++.'. '.$data1->libelle.'</td><td class="border-top"></td><td class="border-top"></td><td class="border-top"></td><td class="border-top"></td></tr>';
			$devttr_id = $data1->id;
			$query2 = DevisTyp::all();
			foreach($query2 as $data2):
				$devtyp_id = $data2->id;
				$where = [
					['devttr_id', $devttr_id],
					['devtyp_id', $devtyp_id],
				];
				$proforma = Proforma::where($where)->first();
				if($proforma != ''){
					if($devtyp_id == 2)
					$query[] = '<tr><td class="text-center text-decoration-underline fw-bold">'.$data2->libelle.'</td><td></td><td></td><td></td><td></td></tr>';
					$devisTxt = DevisTxt::where($where)->first();
					if($devisTxt != '') $query[] = '<tr><td class="text-justify">'.nl2br($devisTxt->content).'<br></td><td></td><td></td><td></td><td></td></tr>';
					//Requete Read
					$req = Commande::select('commandes.amount', 'quantity', 'valeur', 'commandes.unit', 'libelle');
					switch($devtyp_id){
						case 1 :
							$req->join('schedules', 'schedules.id','=','commandes.item_id');
							$libelle = "TOTAL MAIN D'OEUVRE";
						break;
						case 2 :
							$req = Commande::select('commandes.amount', 'quantity', 'valeur', 'commandes.unit', 'suppl_lib.libelle AS suppllib', 'materials.libelle AS material', 'diameters.libelle AS diameter')
							->join('supplies', 'supplies.id','=','commandes.item_id')
							->join('suppl_lib', 'suppl_lib.id', '=', 'supplies.suppllib_id')
							->leftJoin('materials', 'materials.id', '=', 'supplies.material_id')
							->leftJoin('diameters', 'diameters.id', '=', 'supplies.diameter_id');
							$libelle = "TOTAL ".$data2->libelle;
						break;
						default :
							$req->join('transport', 'transport.id','=','commandes.item_id');
							$libelle = "TOTAL ".$data2->libelle;
					}
					$query3 = $req->where($where)->get();
					foreach($query3 as $data3):
						$total = $data3->amount * $data3->quantity;
						if($devtyp_id == 2) $data3->libelle = $data3->suppllib.' '.$data3->material.' '.$data3->diameter;
						$return = '<tr><td>'.$data3->libelle.'</td><td class="text-center">'.$data3->valeur.'</td>';
						if($proforma->see_price == 1){
							$return .= '<td class="text-center">'.$data3->unit.'</td>
							<td class="text-end">'.number_format($data3->amount, 0, ',', '.').'&nbsp;</td>
							<td class="text-end">'.number_format($total, 0, ',', '.').'&nbsp;</td>';
						}else
							$return .= '<td></td><td></td><td></td>';
						$return .= '</tr>';
						$query[] = $return;
					endforeach;
					//Remise
					$libelle .= $proforma->mt_rem == 0 ? '':' (REMISE '.$proforma->mt_rem.'%)';
					//Total
					$query[] = '<tr><td class="fw-bold">'.$libelle.'</td><td></td><td></td><td></td><td class="text-end fw-bold">'.number_format($proforma->total, 0, ',', '.').'&nbsp;</td></tr>';
				}
			endforeach;
		endforeach;
		//Vue PDF
		$pdf = PDF::loadView('pages.pdfdevis', compact('devis', 'query', 'int2string'));
		//Path to file
		$path = public_path('assets/media/billings/dev-'.$devis->filename);
		//Enregistrer le fichier
		$pdf->save($path);
    }
	// Generate PDF Facture
    public function pdfbills(request $request){
		$id = $request->id;
		$bills = Devis::select('filename', 'bill_addr.libelle AS bill_addr', 'ships.libelle AS libship', 'content', 'mt_ht', 'mt_rem', 'mt_ttc', 'mt_euro', 'mt_tva', 'sum_rem', 'sum_tva', 'see_tva', 'see_rem', 'see_euro')
		->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id')
		->leftJoin('ships', 'ships.id', '=', 'devis.ship_id')
		->where([
			['devis.id', $id],
			['devis.status', '4'],
		])
		->first();
		//Header
		$bills->logo = public_path('assets/media/headers/bg-bill.jpg');
		//Chiifre en lettre
		$int2str = new NumberFormatter('fr', NumberFormatter::SPELLOUT);
		$string = $int2str->format($bills->mt_ttc);
		$array = Str::of($string)->explode('virgule');
		$int2string = Str::ucfirst($array[0]);
		//Requete Read
		$i = 1;
		$query = [];
		$query1 = DevisTtr::whereDevisId($id)->get();
		foreach($query1 as $data1):
			$query[] = '<tr><td class="fw-bold border-top">'.$i++.'. '.$data1->libelle.'</td><td class="border-top"></td><td class="border-top"></td><td class="border-top"></td><td class="border-top"></td></tr>';
			$devttr_id = $data1->id;
			$query2 = DevisTyp::all();
			foreach($query2 as $data2):
				$devtyp_id = $data2->id;
				$where = [
					['devttr_id', $devttr_id],
					['devtyp_id', $devtyp_id],
				];
				$proforma = Proforma::where($where)->first();
				if($proforma != ''){
					if($devtyp_id == 2)
					$query[] = '<tr><td class="text-center text-decoration-underline fw-bold">'.$data2->libelle.'</td><td></td><td></td><td></td><td></td></tr>';
					$devisTxt = DevisTxt::where($where)->first();
					if($devisTxt != '') $query[] = '<tr><td class="text-justify">'.nl2br($devisTxt->content).'<br></td><td></td><td></td><td></td><td></td></tr>';
					//Requete Read
					$req = Commande::select('commandes.amount', 'quantity', 'valeur', 'commandes.unit', 'libelle');
					switch($devtyp_id){
						case 1 :
							$req->join('schedules', 'schedules.id','=','commandes.item_id');
							$libelle = "TOTAL MAIN D'OEUVRE";
						break;
						case 2 :
							$req = Commande::select('commandes.amount', 'quantity', 'valeur', 'commandes.unit', 'suppl_lib.libelle AS suppllib', 'materials.libelle AS material', 'diameters.libelle AS diameter')
							->join('supplies', 'supplies.id','=','commandes.item_id')
							->join('suppl_lib', 'suppl_lib.id', '=', 'supplies.suppllib_id')
							->leftJoin('materials', 'materials.id', '=', 'supplies.material_id')
							->leftJoin('diameters', 'diameters.id', '=', 'supplies.diameter_id');
							$libelle = "TOTAL ".$data2->libelle;
						break;
						default :
							$req->join('transport', 'transport.id','=','commandes.item_id');
							$libelle = "TOTAL ".$data2->libelle;
					}
					$query3 = $req->where($where)->get();
					foreach($query3 as $data3):
						$total = $data3->amount * $data3->quantity;
						if($devtyp_id == 2) $data3->libelle = $data3->suppllib.' '.$data3->material.' '.$data3->diameter;
						$return = '<tr><td>'.$data3->libelle.'</td><td class="text-center">'.$data3->valeur.'</td>';
						if($proforma->see_price == 1){
							$return .= '<td class="text-center">'.$data3->unit.'</td>
							<td class="text-end">'.number_format($data3->amount, 0, ',', '.').'&nbsp;</td>
							<td class="text-end">'.number_format($total, 0, ',', '.').'&nbsp;</td>';
						}else
							$return .= '<td></td><td></td><td></td>';
						$return .= '</tr>';
						$query[] = $return;
					endforeach;
					//Remise
					$libelle .= $proforma->mt_rem == 0 ? '':' (REMISE '.$proforma->mt_rem.'%)';
					//Total
					$query[] = '<tr><td class="fw-bold">'.$libelle.'</td><td></td><td></td><td></td><td class="text-end fw-bold">'.number_format($proforma->total, 0, ',', '.').'&nbsp;</td></tr>';
				}
			endforeach;
		endforeach;
		//Vue PDF
		$pdf = PDF::loadView('pages.pdfbills', compact('bills', 'query', 'int2string'));
		//Path to file
		$path = public_path('assets/media/billings/bill-'.$bills->filename);
		//Enregistrer le fichier
		$pdf->save($path);
    }
}
