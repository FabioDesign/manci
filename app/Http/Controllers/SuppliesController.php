<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Supplie;
use App\Models\Suppllib;
use App\Models\Suppltyp;
use App\Models\Material;
use App\Models\Diameter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class SuppliesController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Désignation (Fourniture)';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'supplie';
			//Submenu
			$currentSubMenu = 'supplies';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[22]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|supplieform|" title="Ajouter une Désignation" submitbtn="Valider">Ajouter une Désignation</a>':'';
			//Requete Read
			$query = Supplie::select('supplies.id', 'suppl_typ.libelle AS type', 'suppl_lib.libelle AS suppllib', 'materials.libelle AS material', 'diameters.libelle AS diameter', 'amount', 'unit', 'supplies.created_at')
			->join('suppl_lib', 'suppl_lib.id', '=', 'supplies.suppllib_id')
			->join('suppl_typ', 'suppl_typ.id', '=', 'suppl_lib.suppltyp_id')
			->leftJoin('materials', 'materials.id', '=', 'supplies.material_id')
			->leftJoin('diameters', 'diameters.id', '=', 'supplies.diameter_id')
			->orderByDesc('supplies.created_at')
			->get();
			return view('pages.supplies', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Fournitures
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Supplie::join('suppl_lib', 'suppl_lib.id', '=', 'supplies.suppllib_id')
				->where('supplies.id', $id)
				->first();
				$unit = $query->unit;
				$amount = $query->amount;
				$suppltyp_id = $query->suppltyp_id;
				$suppllib_id = $query->suppllib_id;
				$material_id = $query->material_id;
				$diameter_id = $query->diameter_id;
			}else{
				$amount = $unit = '';
				$suppltyp_id = $suppllib_id = $material_id = $diameter_id = 0;
			}
			//Requete Read
			$suppltyp = Suppltyp::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Requete Read
			$material = Material::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Requete Read
			$diameter = Diameter::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Page de la vue
			return view('modals.supplies', compact('id', 'amount', 'unit', 'suppltyp_id', 'suppllib_id', 'material_id', 'diameter_id', 'suppltyp', 'material', 'diameter'));
	    }else return 'x';
	}
	//Add/Mod Fournitures
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'suppllib_id' => 'bail|required|integer|gt:0',
				'amount' => 'bail|required|regex:/^[0-9\s]+$/',
			], [
				'suppllib_id.*' => "Nom (fourniture) non valide.",
				'amount.required' => "Montant obligatoire.",
				'amount.regex' => "Montant non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Nom (Fourniture) : ".serialize($request->post()));
				if($errors->has('suppllib_id')) return '0|'.$errors->first('suppllib_id');
				if($errors->has('amount')) return '0|'.$errors->first('amount');
			}
			$id = $request->id;
			//Test Email
			if($id == 0) $count = Supplie::where([
				['suppllib_id', $request->suppllib_id],
				['material_id', $request->material_id],
				['diameter_id', $request->diameter_id],
			])->count();
			else $count = Supplie::where([
				['id', '!=', $id],
				['suppllib_id', $request->suppllib_id],
				['material_id', $request->material_id],
				['diameter_id', $request->diameter_id],
			])->count();
			if($count == 0){
				$set = [
					'unit' => $request->unit,
					'amount' => $request->amount,
					'suppllib_id' => $request->suppllib_id,
					'material_id' => $request->material_id,
					'diameter_id' => $request->diameter_id,
				];
				try{
					if($id == 0){
						$set['user_id'] = Session::get('idUsr');
						Supplie::create($set);
						$msg = 'Désignation (Fourniture) enregistrée avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Supplie::findOrFail($id)->update($set);
						$msg = 'Désignation (Fourniture) modifiée avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Désignation (Fourniture)', $type, $color, Session::get('avatar'));
					Log::info($type.' Désignation (Fourniture) : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Désignation (Fourniture) : ".serialize($request->post()));
					Log::warning("Désignation (Fourniture) : ".$e->getMessage());
				}
			}else{
				$msg = "Désignation déjà utilisé";
				Log::warning("Désignation (Fourniture) : ".serialize($request->post())." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
