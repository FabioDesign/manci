<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Diameter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class DiametersController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Dimension (Fourniture)';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'supplie';
			//Submenu
			$currentSubMenu = 'diameters';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[21]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|diameterform|mw-400px" title="Ajouter une dimension" submitbtn="Valider">Ajouter une dimension</a>':'';
			//Requete Read
			$query = Diameter::select('id', 'libelle', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.diameters', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Fournitures
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Diameter::whereId($id)->first();
				$libelle = $query->libelle;
			}else $libelle = '';
			//Page de la vue
			return view('modals.diameters', compact('id', 'libelle'));
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
				'libelle.required' => "Dimension obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Dimension (Fourniture) : ".serialize($request->post()));
				if($errors->has('libelle')) return '0|'.$errors->first('libelle');
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Diameter::whereLibelle($libelle)->count();
			else $count = Diameter::where([
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
						Diameter::create($set);
						$msg = 'Dimension (Fourniture) enregistrée avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Diameter::findOrFail($id)->update($set);
						$msg = 'Dimension (Fourniture) modifiée avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Dimension (Fourniture): '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Dimension (Fourniture) : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Dimension (Fourniture) : ".serialize($request->post()));
					Log::warning("Dimension (Fourniture) : ".$e->getMessage());
				}
			}else{
				$msg = "Dimension déjà utilisée";
				Log::warning("Dimension (Fourniture) : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
