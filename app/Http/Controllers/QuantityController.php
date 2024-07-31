<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Quantity;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class QuantityController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Quantités';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'settings';
			//Submenu
			$currentSubMenu = 'quantity';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[16]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|quantityform|mw-400px" title="Ajouter une quantité" submitbtn="Valider">Ajouter une quantité</a>':'';
			//Requete Read
			$query = Quantity::select('id', 'libelle', 'valeur', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.quantity', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Liste des Quantités
	public function lists(){
		//Requete Read
		$query = Quantity::whereStatus('1')->get();
		foreach($query as $data):
			$return[$data->libelle] = 1;
		endforeach;
		return $return;
	}
	//Liste des Quantités
	public function qtevalue(request $request){
		//Requete Read
		$query = Quantity::whereLibelle($request->qte)->first();
		$return = $query == '' ? $request->qte:$query->valeur;
		return $return;
	}
	//Formulaire Quantités
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Quantity::whereId($id)->first();
				$valeur = $query->valeur;
				$libelle = $query->libelle;
			}else $libelle = $valeur = '';
			//Page de la vue
			return view('modals.quantity', compact('id', 'libelle', 'valeur'));
	    }else return 'x';
	}
	//Add/Mod Quantités
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
				'valeur' => 'required',
			], [
				'libelle.required' => "Nom obligatoire.",
				'valeur.required' => "Valeur obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Quantité : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
				if($errors->has('valeur')) return $Ok.'|'.$errors->first('valeur').'|.number';
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Quantity::whereLibelle($libelle)->count();
			else $count = Quantity::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
					'valeur' => $request->valeur,
				];
				try{
					if($id == 0){
						$set['status'] = '1';
						$set['user_id'] = Session::get('idUsr');
						Quantity::create($set);
						$msg = 'Quantité enregistrée avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Quantity::findOrFail($id)->update($set);
						$msg = 'Quantité modifiée avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Quantité: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Quantité : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Quantité : ".serialize($request->post()));
					Log::warning("Quantité : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Quantité : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
		}else return 'x';
	}
}
