<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Suppllib;
use App\Models\Suppltyp;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class SuppllibController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Nom (Fourniture)';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'supplie';
			//Submenu
			$currentSubMenu = 'suppllib';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[14]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|suppllibform|" title="Ajouter un Nom" submitbtn="Valider">Ajouter un Nom</a>':'';
			//Requete Read
			$query = Suppllib::select('suppl_lib.id', 'suppl_lib.libelle', 'suppl_typ.libelle AS type', 'suppl_lib.status', 'suppl_lib.created_at')
			->join('suppl_typ', 'suppl_typ.id', '=', 'suppl_lib.suppltyp_id')
			->orderByDesc('suppl_lib.created_at')
			->get();
			return view('pages.suppllib', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Liste des Fournitures
	public function lists(request $request){
		if(Session::has('idUsr')){
			//Requete Read
			$query = Suppllib::select('id', 'libelle')
			->where([
				['status', '1'],
				['suppltyp_id', $request->id],
			])
			->orderBy('libelle')
			->get();
			$return = [];
			foreach($query as $data):
				$return[$data->id] = $data->libelle;
			endforeach;
			return $return;
		}else return 'x';
	}
	//Formulaire Fournitures
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Suppllib::whereId($id)->first();
				$libelle = $query->libelle;
				$suppltyp_id = $query->suppltyp_id;
			}else $libelle = $suppltyp_id = '';
			//Requete Read
			$query = Suppltyp::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Page de la vue
			return view('modals.suppllib', compact('id', 'libelle', 'suppltyp_id', 'query'));
	    }else return 'x';
	}
	//Add/Mod Fournitures
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
				'suppltyp_id' => 'bail|required|integer|gt:0',
			], [
				'libelle.required' => "Nom obligatoire.",
				'suppltyp_id.*' => "Type (fourniture) non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Nom (Fourniture) : ".serialize($request->post()));
				if($errors->has('suppltyp_id')) return '0|'.$errors->first('suppltyp_id');
				if($errors->has('libelle')) return '0|'.$errors->first('libelle');
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Suppllib::whereLibelle($libelle)->count();
			else $count = Suppllib::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
					'suppltyp_id' => $request->suppltyp_id,
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						Suppllib::create($set);
						$msg = 'Nom (Fourniture) enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Suppllib::findOrFail($id)->update($set);
						$msg = 'Nom (Fourniture) modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Nom (Fourniture): '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Nom (Fourniture) : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Nom (Fourniture) : ".serialize($request->post()));
					Log::warning("Nom (Fourniture) : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Nom (Fourniture) : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
