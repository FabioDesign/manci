<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Material;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class MaterialsController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Matière (Fourniture)';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'supplie';
			//Submenu
			$currentSubMenu = 'materials';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[20]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|materialform|mw-400px" title="Ajouter une Matière" submitbtn="Valider">Ajouter une Matière</a>':'';
			//Requete Read
			$query = Material::select('id', 'libelle', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.materials', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Liste des Fournitures
	public function lists(request $request){
		if(Session::has('idUsr')){
			//Requete Read
			$query = Material::select('id', 'libelle')
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
				$query = Material::whereId($id)->first();
				$libelle = $query->libelle;
			}else $libelle = '';
			//Page de la vue
			return view('modals.materials', compact('id', 'libelle'));
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
			], [
				'libelle.required' => "Matière obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Matière (Fourniture) : ".serialize($request->post()));
				if($errors->has('libelle')) return '0|'.$errors->first('libelle');
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Material::whereLibelle($libelle)->count();
			else $count = Material::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
				];
				try{
					if($id == 0){
						$set['status'] = '1';
						$set['user_id'] = Session::get('idUsr');
						Material::create($set);
						$msg = 'Matière (Fourniture) enregistrée avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Material::findOrFail($id)->update($set);
						$msg = 'Matière (Fourniture) modifiée avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Matière (Fourniture): '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Matière (Fourniture) : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Matière (Fourniture) : ".serialize($request->post()));
					Log::warning("Matière (Fourniture) : ".$e->getMessage());
				}
			}else{
				$msg = "Matière déjà utilisée";
				Log::warning("Matière (Fourniture) : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
