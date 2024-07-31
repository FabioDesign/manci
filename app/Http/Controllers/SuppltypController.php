<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Suppltyp;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class SuppltypController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Catégorie (Fourniture)';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'supplie';
			//Submenu
			$currentSubMenu = 'suppltyp';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[12]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|suppltypform|mw-400px" title="Ajouter Catégorie (Fourniture)" submitbtn="Valider">Ajouter Catégorie (Fourniture)</a>':'';
			//Requete Read
			$query = Suppltyp::select('id', 'libelle', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.suppltyp', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Catégorie (Fourniture)
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Suppltyp::whereId($id)->first();
				$libelle = $query->libelle;
			}else $libelle = '';
			//Page de la vue
			return view('modals.suppltyp', compact('id', 'libelle'));
	    }else return 'x';
	}
	//Add/Mod Catégorie (Fourniture)
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
			], [
				'libelle.required' => "Nom obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Catégorie (Fourniture) : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
			}
			$id = $request->id;
			//Test Number
			$libelle = $request->libelle;
			if($id == 0) $count = Suppltyp::whereLibelle($libelle)->count();
			else $count = Suppltyp::where([
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
						Suppltyp::create($set);
						$msg = 'Catégorie (Fourniture) enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Suppltyp::findOrFail($id)->update($set);
						$msg = 'Catégorie (Fourniture) modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Catégorie (Fourniture): '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Catégorie (Fourniture) : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Catégorie (Fourniture) : ".serialize($request->post()));
					Log::warning("Catégorie (Fourniture) : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Catégorie (Fourniture) : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
		}else return 'x';
	}
}
