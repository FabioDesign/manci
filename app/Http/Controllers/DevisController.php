<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Devis;
use App\Models\Title;
use App\Models\Client;
use App\Models\Header;
use App\Models\Supplie;
use App\Models\Commande;
use App\Models\DevisTyp;
use App\Models\DevisTtr;
use App\Models\DevisTxt;
use App\Models\Proforma;
use App\Models\Quantity;
use App\Models\Schedule;
use App\Models\Suppltyp;
use App\Models\Transport;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class DevisController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Devis';
			//Breadcrumb
			$breadcrumb = 'Devis';
			//Menu
			$currentMenu = 'devis';
			//Submenu
			$currentSubMenu = '';
			//Requete Read
			$query = Devis::select('devis.id', 'reference', 'date_at', 'mt_ttc', 'devis.status', 'libelle', 'filename', 'lastname', 'firstname')
			->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id')
			->join('users', 'users.id', '=', 'devis.user_id')
			->orderByDesc('devis.created_at')
			->get();
			$page = in_array(8, Session::get('rights')[18]) ? 'pages.devis2':'pages.devis1';
			$page = 'pages.devis2';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[18]) ? '<a href="/devisform/0" class="btn btn-sm fw-bold btn-primary">Ajouter un devis</a>':'';
			return view($page, compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	public function bills(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Factures';
			//Breadcrumb
			$breadcrumb = 'Factures';
			//Menu
			$currentMenu = 'billings';
			//Submenu
			$currentSubMenu = '';
			//Requete Read
			$query = Devis::select('reference', 'validated_at', 'mt_ttc', 'libelle', 'filename', 'lastname', 'firstname')
			->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id')
			->join('users', 'users.id', '=', 'devis.user_id')
			->where('devis.status', '4')
			->orderByDesc('validated_at')
			->get();
			//Modal
			$addmodal = '';
			return view('pages.billings', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire devis
	public function forms(request $request){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Devis';
			//Breadcrumb
			$breadcrumb = 'Devis';
			//Menu
			$currentMenu = 'devis';
			//Submenu
			$currentSubMenu = '';
			//Modal
			$addmodal = $see_tva = $see_rem = $see_euro = '';
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Devis::select('date_at', 'client_id', 'billaddr_id', 'header_id', 'mt_ht', 'mt_ttc', 'mt_euro', 'sum_rem', 'sum_tva', 'see_tva', 'see_rem', 'see_euro', 'reference')
				->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id')
				->join('headers', 'headers.id', '=', 'devis.header_id')
				->where('devis.id', $id)
				->first();
				$date_at = Myhelper::formatDateFr($query->date_at);
				$billaddr_id = $query->billaddr_id;
				$header_id = $query->header_id;
				$client_id = $query->client_id;
				$reference = $query->reference;
				$mt_euro = $query->mt_euro;
				$sum_rem = $query->sum_rem;
				$sum_tva = $query->sum_tva;
				$mt_ttc = $query->mt_ttc;
				$mt_ht = $query->mt_ht;
				if($query->see_tva == 1) $see_tva = 'checked';
				if($query->see_rem == 1) $see_rem = 'checked';
				if($query->see_euro == 1) $see_euro = 'checked';
				$page = in_array(8, Session::get('rights')[18]) ? 'forms.devupdate2':'forms.devupdate1';
				$page = 'forms.devupdate2';
			}else{
				$date_at = date('d-m-Y');
				$query = Devis::all()->last();
				if($query == '') $count = 1;
				else{
					$array = Str::of($query->reference)->explode('/');
					$count = $array[0] + 1;
				}
				$reference = sprintf('%04d', $count).'/'.date('y');
				$client_id = $billaddr_id = $header_id = $mt_euro = $sum_rem = $mt_ttc = $sum_tva = $mt_ht = 0;
				$page = in_array(8, Session::get('rights')[18]) ? 'forms.devcreate2':'forms.devcreate1';
				$page = 'forms.devcreate2';
			}
			//Requete Read
			$client = Client::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Requete Read
			$header = Header::whereStatus('1')->get();
			//Requete Read
			$devistyp = DevisTyp::whereStatus('1')->get();
			//Page de la vue
			return view($page, compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'id', 'date_at', 'mt_ht', 'sum_rem', 'mt_ttc', 'mt_euro', 'sum_tva', 'see_tva', 'see_rem', 'see_euro', 'client_id', 'billaddr_id', 'header_id', 'client', 'header', 'devistyp', 'reference'));
	    }else return redirect('/');
	}
	//Liste des devis
	public function listmod(request $request){
		$return = $class = '';
		$id = $request->id;
		//Requete Read
		$i = 1;
		$query1 = DevisTtr::whereDevisId($id)->get();
		foreach($query1 as $data1):
			if($i > 1) $class = 'border-top border-2 border-gray-600';
			$return .= '<tr class="'.$class.'"><td colspan="5" class="fw-bolder text-dark fs-6 p-0 pt-2">'.$i++.'. '.$data1->libelle.'</td></tr>';
			$devttr_id = $data1->id;
			$query2 = DevisTyp::all();
			foreach($query2 as $data2):
				$devtyp_id = $data2->id;
				$where = [
					['devttr_id', $devttr_id],
					['devtyp_id', $devtyp_id],
				];
				$proforma = Proforma::where($where)->first();
				if($proforma != '')
					$del = '<a href="#" class="status" data-h="'.$devttr_id.'|'.$devtyp_id.'|18" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" data-bs-original-title="Suppression de type de devis"><i class="fas fa-trash-alt fa-size text-danger"></i></a>';
				else
					$del = '<i class="fas fa-trash-alt fa-size text-dark"></i>';
				$return .= '<tr><td class="text-center text-decoration-underline fs-5 p-0">'.$data2->libelle.'</td><td></td><td></td><td class="text-end"><a href="#" class="devlinemod" devttr="'.$devttr_id.'" devtyp="'.$devtyp_id.'"><i class="fas fa-edit fa-size text-primary me-2"></i></a> '.$del.'</a></td></tr>';
				$devisTxt = DevisTxt::where($where)->first();
				if($devisTxt != '') $return .= '<tr><td class="text-justify">'.nl2br($devisTxt->content).'<br></td><td></td><td></td><td></td></tr>';
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
					$return .= '<tr><td class="p-0">'.$data3->libelle.'</td><td class="text-center p-0">'.$data3->valeur.$data3->unit.'</td>';
					if($proforma->see_price == 1){
						$return .= '<td class="text-center p-0">'.number_format($data3->amount, 0, ',', '.').'</td>
						<td class="text-end p-0">'.number_format($total, 0, ',', '.').'</td>';
					}else
						$return .= '<td class="p-0"></td><td class="p-0"></td>';
					$return .= '</tr>';
				endforeach;
				//Remise
				if($proforma != ''){
					$libelle .= $proforma->sum_rem == 0 ? '':' (REMISE '.$proforma->sum_rem.'%)';
				}
				//Total
				$total = $proforma == '' ? 0:number_format($proforma->total, 0, ',', '.');
				$return .= '<tr><td class="fw-bolder text-dark fs-6">'.$libelle.'</td><td class="p-0"></td><td class="p-0"></td><td class="fw-bolder text-dark fs-6 text-end">'.$total.'</td></tr>';
			endforeach;
		endforeach;
		return $return;
	}
	//Liste des devis
	public function linemod(request $request){
		$return = '';
		$devttr_id = $request->devttr_id;
		$devtyp_id = $request->devtyp_id;
		//Requete Read
		$query = DevisTtr::whereId($devttr_id)->first();
		$return .= $query->libelle.'|';
		$query = DevisTyp::whereId($devtyp_id)->first();
		$return .= $query->libelle.'|';
		$where = [
			['devttr_id', $devttr_id],
			['devtyp_id', $devtyp_id],
		];
		$query = DevisTxt::where($where)->first();
		$return .= $query == '' ? '':$query->content;
		$return .= '|';
		$query = Proforma::where($where)->first();
		$return .= $query == '' ? 0:$query->total;
		$return .= '|';
		$return .= $query == '' ? 0:$query->sum_rem;
		$return .= '|';
		$return .= $query == '' ? '':$query->see_rem;
		$return .= '|';
		$return .= $query == '' ? 1:$query->see_price;
		$return .= '|';
		//Requete Read
		$i = 0;
		$type_id = '';
		$type = 'Sélectionner';
		if($devtyp_id == 2){
			$return .= '<datalist id="qte"></datalist><div class="row mb-5">
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Type</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Nom</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6">Matière</label></div>
			<div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6">Qualif.</label></div>
			<div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6 required">PU</label></div>
			<div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6 required">Qté</label></div>
			<div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6">Unité</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Total</label></div>
			</div>';
		}else{
			$return .= '<datalist id="qte"></datalist><div class="row mb-5">
			<div class="col-sm-12 col-xl-4"><label class="form-label fw-bolder text-dark fs-6 required">Designation</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Prix unitaire</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Qté</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6">Unité</label></div>
			<div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Total</label></div>
			</div>';
		}
		$query = Commande::select('item_id', 'amount', 'quantity', 'valeur', 'unit')
		->where($where)
		->get();
		foreach($query as $data):
			switch($devtyp_id){
				case 1 : $req = Schedule::whereId($data->item_id)->first(); break;
				case 2 :
					$req = Supplie::select('suppltyp_id', 'suppl_typ.libelle AS type', 'suppllib_id', 'suppl_lib.libelle AS suppllib', 'material_id', 'materials.libelle AS material', 'diameter_id', 'diameters.libelle AS diameter')
					->join('suppl_lib', 'suppl_lib.id', '=', 'supplies.suppllib_id')
					->join('suppl_typ', 'suppl_typ.id', '=', 'suppl_lib.suppltyp_id')
					->leftJoin('materials', 'materials.id', '=', 'supplies.material_id')
					->leftJoin('diameters', 'diameters.id', '=', 'supplies.diameter_id')
					->where('supplies.id', $data->item_id)
					->first();
				break;
				default : $req = Transport::whereId($data->item_id)->first();
			}
			$total = $data->amount * $data->quantity;
			if($devtyp_id == 2){
				$return .= '<div class="row mb-5">
				<div class="col-sm-12 col-xl-2">
				<select class="form-control form-select form-control-solid type_id" aria-label="Select example">
				<option value="'.$req->suppltyp_id.'">'.$req->type.'</option>
				</select>
				</div>
				<div class="col-sm-12 col-xl-2">
				<select name="item_id[]" class="form-control form-select form-control-solid requiredField item_id" aria-label="Select example">
				<option value="'.$req->suppllib_id.'">'.$req->suppllib.'</option>
				</select>
				</div>
				<div class="col-sm-12 col-xl-2">
				<select name="material_id[]" class="form-control form-select form-control-solid material_id" aria-label="Select example">
				<option value="'.$req->material_id.'">'.$req->material.'</option>
				</select>
				</div>
				<div class="col-sm-12 col-xl-1">
				<select name="diameter_id[]" class="form-control form-select form-control-solid diameter_id space" aria-label="Select example">
				<option value="'.$req->diameter_id.'">'.$req->diameter.'</option>
				</select>
				</div>
				<div class="col-sm-12 col-xl-1">
				<input type="text" name="price[]" value="'.$data->amount.'" class="form-control form-control-solid requiredField text-center amount price space" onKeyUp="verif_num(this)" />
				</div>
				<div class="col-sm-12 col-xl-1">
				<input type="text" name="qte[]" list="qte" value="'.$data->valeur.'" class="form-control form-control-solid requiredField text-center qte space" />
				</div>
				<div class="col-sm-12 col-xl-1">
				<input type="text" name="unit[]" value="'.$data->unit.'" class="form-control form-control-solid text-center unit space" />
				</div>
				<div class="col-sm-12 col-xl-2 position-relative">
				<input type="text" value="'.$total.'" class="form-control form-control-solid text-center w-85 total" readonly />
				<a href="#" class="btn btn-icon btn-flex btn-active-light-danger position-absolute bottom-0 end-0 delDev" data-bs-toggle="tooltip" aria-label="Supprimer" data-bs-original-title="Supprimer" data-kt-initialized="1"><i class="ki-duotone ki-trash text-danger fs-1">
				<span class="path1"></span>
				<span class="path2"></span>
				<span class="path3"></span>
				<span class="path4"></span>
				<span class="path5"></span>
				</i>
				</a>
				</div>
				</div>';
			}else{
				$return .= '<div class="row mb-5">
				<div class="col-sm-12 col-xl-4">
				<select name="item_id[]" class="form-control form-select form-control-solid requiredField item_id" aria-label="Select example">
				<option value="'.$data->item_id.'">'.$req->libelle.'</option>
				</select>
				</div>
				<div class="col-sm-12 col-xl-2">
				<input type="text" name="price[]" value="'.$data->amount.'" class="form-control form-control-solid requiredField text-center amount price" onKeyUp="verif_num(this)" />
				</div>
				<div class="col-sm-12 col-xl-2">
				<input type="text" name="qte[]" list="qte" value="'.$data->valeur.'" class="form-control form-control-solid requiredField text-center qte space" />
				</div>
				<div class="col-sm-12 col-xl-2">
				<input type="text" name="unit[]" value="'.$data->unit.'" class="form-control form-control-solid text-center unit space" />
				</div>
				<div class="col-sm-12 col-xl-2 position-relative">
				<input type="text" value="'.$total.'" class="form-control form-control-solid text-center w-85 total" readonly />
				<a href="#" class="btn btn-icon btn-flex btn-active-light-danger position-absolute bottom-0 end-0 delDev" data-bs-toggle="tooltip" aria-label="Supprimer" data-bs-original-title="Supprimer" data-kt-initialized="1"><i class="ki-duotone ki-trash text-danger fs-1">
				<span class="path1"></span>
				<span class="path2"></span>
				<span class="path3"></span>
				<span class="path4"></span>
				<span class="path5"></span>
				</i>
				</a>
				</div>
				</div>';
			}
			$i++;
		endforeach;
		return $return;
	}
	//Add/Mod devis
	public function create(request $request){
		// dd($request);
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'date_at' => 'bail|required|date_format:d-m-Y',
				'billaddr_id' => 'bail|required|integer|gt:0',
				'header_id' => 'bail|required|integer|gt:0',
				'solde' => 'required|regex:/^[0-9\s]+$/',
			], [
				'date_at.*' => "Date non valide.",
				'billaddr_id.required' => "Adresse de facturation obligatoire.",
				'billaddr_id.gt' => "Adresse de facturation non valide.",
				'header_id.required' => "Entête devis obligatoire.",
				'header_id.gt' => "Entête devis non valide.",
				'solde.*' => "Date non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Utilisateur : ".serialize($request->post()));
				if($errors->has('date_at')) return '0|'.$errors->first('date_at');
				if($errors->has('billaddr_id')) return '0|'.$errors->first('billaddr_id');
				if($errors->has('header_id')) return '0|'.$errors->first('header_id');
				if($errors->has('solde')) return '0|'.$errors->first('solde');
			}
			$id = $request->id;
			$reference = $request->reference;
			$devttr_id = $request->devttr_id;
			$devtyp_id = $request->devtyp_id;
			$title = Str::upper(Myhelper::valideString($request->title));
			if($id == 0) $count = Devis::whereReference($reference)->count();
			else $count = Devis::where([
				['id', '!=', $id],
				['reference', $reference],
			])->count();
			if($count == 0){
				try{
					$see_tva = isset($request->see_tva) ? '1':'0';
					$see_rem = isset($request->see_rem) ? '1':'0';
					$see_euro = isset($request->see_euro) ? '1':'0';
					$sum_tva = $request->sum_tva == '' ? 0:$request->sum_tva;
					$sum_rem = $request->sum_rem == '' ? 0:$request->sum_rem;
					$set = [
						'sum_rem' => $sum_rem,
						'sum_tva' => $sum_tva,
						'see_rem' => $see_rem,
						'see_tva' => $see_tva,
						'see_euro' => $see_euro,
						'reference' => $reference,
						'header_id' => $request->header_id,
						'billaddr_id' => $request->billaddr_id,
						'date_at' => Myhelper::formatDateEn($request->date_at),
					];
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						$set['filename'] = date('YmdHis').substr(microtime(), 2, 6).'.pdf';
						$query = Devis::create($set);
						$id = $query->id;
						$msgDev = 'Devis ajoutée avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Devis::findOrFail($id)->update($set);
						$msgDev = 'Devis modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
						$Ok = 1;
					}
				}catch(\Exception $e){
					Log::warning("Devis : ".serialize($request->post()));
					Log::warning("Devis : ".$e->getMessage());
					return '0|'.$msg;
				}
				//Ligne de devis
				if(($devtyp_id != '')&&($title != '')){
					try{
						//Requete Read
						$set = ['libelle' => $title];
						if($request->devttr == 1){
							$set['devis_id'] = $id;
							$query = DevisTtr::create($set);
							$devttr_id = $query->id;
						}else DevisTtr::findOrFail($devttr_id)->update($set);
					}catch(\Exception $e){
						Log::warning("DevisTtr : ".serialize($request->post()));
						Log::warning("DevisTtr : ".$e->getMessage());
						return '0|'.$msg;
					}
					$where = [
						['devttr_id', $devttr_id],
						['devtyp_id', $devtyp_id],
					];
					//Requete Read
					$content = $request->content;
					if($content != ''){
						try{
							$query = DevisTxt::where($where)->first();
							$set = ['content' => $content];
							if($query == ''){
								$set['devttr_id'] = $devttr_id;
								$set['devtyp_id'] = $devtyp_id;
								$query = DevisTxt::create($set);
							}else DevisTxt::where($where)->update($set);
						}catch(\Exception $e){
							Log::warning("DevisTxt : ".serialize($request->post()));
							Log::warning("DevisTxt : ".$e->getMessage());
							return '0|'.$msg;
						}
					}
					try{
						//Requete Read
						if($request->has('item_id')){
							Commande::where($where)->delete();
							foreach($request->item_id as $key => $item_id):
								$qte = $request->qte[$key];
								$price = $request->price[$key];
								if(($item_id != 0)&&($price != '')&&($qte != '')){
									$unit = $request->unit[$key];
									if($devtyp_id == 2){
										$material_id = $request->material_id[$key];
										$diameter_id = $request->diameter_id[$key];
										$query = Supplie::where([
											['suppllib_id', $item_id],
											['material_id', $material_id],
											['diameter_id', $diameter_id],
										])->first();
										if($query == ''){
											$set = [
												'unit' => $unit,
												'amount' => $price,
												'suppllib_id' => $item_id,
												'material_id' => $material_id,
												'diameter_id' => $diameter_id,
												'user_id' => Session::get('idUsr'),
											];
											$query = Supplie::create($set);
											$item_id = $query->id;
										}else $item_id = $query->id;
									}
									$req = Quantity::whereLibelle($qte)->first();
									$quantity = $req == '' ? $qte:$req->valeur;
									$set = [
										'unit' => $unit,
										'valeur' => $qte,
										'amount' => $price,
										'item_id' => $item_id,
										'quantity' => $quantity,
										'devttr_id' => $devttr_id,
										'devtyp_id' => $devtyp_id,
									];
									Commande::create($set);
								}
							endforeach;
						}
					}catch(\Exception $e){
						Log::warning("Commande : ".serialize($request->post()));
						Log::warning("Commande : ".$e->getMessage());
						return '0|'.$msg;
					}
					try{
						$see_price = $request->see_price == 1 ? '1':'0';
						$seerem = isset($request->seeremtyp) ? '1':'0';
						$mtrem = $request->mtremtyp == '' ? 0:$request->mtremtyp;
						$set = [
							'mt_rem' => $mtrem,
							'see_rem' => $seerem,
							'see_price' => $see_price,
							'total' => $request->solde,
						];
						$query = Proforma::where($where)->first();
						if($query == ''){
							$set['devttr_id'] = $devttr_id;
							$set['devtyp_id'] = $devtyp_id;
							$query = Proforma::create($set);
						}else
							Proforma::where($where)->update($set);
						$Ok = 1;
					}catch(\Exception $e){
						Log::warning("Proforma : ".serialize($request->post()));
						Log::warning("Proforma : ".$e->getMessage());
						return '0|'.$msg;
					}
				}else{
					if($sum_rem != $request->old_rem){
						$query = Devis::whereId($id)->first();
						$mt_rem = ($query->mt_ht * $sum_rem) / 100;
						$mt_ttc = $query->mt_ht - $mt_rem;
						$set = ['mt_rem' => $mt_rem];
						if($query->sum_tva != 0){
							$mt_tva = ($mt_ttc * $sum_tva) / 100;
							$mt_ttc += $mt_tva;
							$set['mt_tva'] = $mt_tva;
						}
						$set['mt_ttc'] = $mt_ttc;
						$set['mt_euro'] = $mt_ttc / Session::get('euro');
						Devis::findOrFail($id)->update($set);
					}
					if($sum_tva != $request->old_tva){
						$query = Devis::whereId($id)->first();
						$mt_ht = $query->mt_ht;
						if($query->mt_rem != 0) $mt_ht = $query->mt_ttc;
						$mt_tva = ($mt_ht * $sum_tva) / 100;
						$mt_ttc = $mt_ht + $mt_tva;
						$set = [
							'mt_tva' => $mt_tva,
							'mt_ttc' => $mt_ttc,
							'mt_euro' => $mt_ttc / Session::get('euro'),
						];
						Devis::findOrFail($id)->update($set);
					}
				}
				if($Ok == 1){
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Devis: '.$reference, $type, $color, Session::get('avatar'));
					Log::info($type.' Devis : '.serialize($request->post()));
					$query = Devis::whereId($id)->first();
					return '1|'.$msgDev.'|'.$id.'|'.number_format($query->mt_ht, 0, ',', '.').'|'.number_format($query->mt_ttc, 0, ',', '.').'|'.Myhelper::formatEuro($query->mt_euro).'|'.$devttr_id.'|'.$sum_rem.'|'.$sum_tva;
				}
			}else{
				Log::warning("Devis : ".serialize($request->post()));
				return '0|La référence a déjà été utilisée.';
			}
	    }else return 'x';
	}
	//Status Devis
	public function status(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			//Requete Read
			$query = Devis::whereId($id)->first();
			//Type de status
			$typ = 18;
			switch($query->status){
			  case 1 : $ouiLib = 'Approuver'; $nonLib = 'Rejeter'; $ouiVal = 2; $nonVal = 3; break;
			  default : $ouiLib = 'Valider'; $nonLib = 'Refuser'; $ouiVal = 4; $nonVal = 5;
			}
			//Page de la vue
			return view('modals.devstatus', compact('id', 'typ', 'ouiLib', 'nonLib', 'ouiVal', 'nonVal'));
	    }else return 'x';
	}
}
