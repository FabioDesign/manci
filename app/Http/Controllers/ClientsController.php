<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Client;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class ClientsController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Clients';
			//Breadcrumb
			$breadcrumb = 'Gestion des clients';
			//Menu
			$currentMenu = 'clients';
			//Submenu
			$currentSubMenu = 'clients';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[7]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|clientform|mw-400px" title="Ajouter un client" submitbtn="Valider">Ajouter un client</a>':'';
			//Requete Read
			$query = Client::select('id', 'libelle', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.clients', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Clients
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Client::whereId($id)->first();
				$libelle = $query->libelle;
			}else $libelle = '';
			//Page de la vue
			return view('modals.clients', compact('id', 'libelle'));
	    }else return 'x';
	}
	//Add/Mod Clients
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
				Log::warning("Client : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
			}
			$id = $request->id;
			//Test Number
			$libelle = Str::upper(Myhelper::valideString($request->libelle));
			if($id == 0) $count = Client::whereLibelle($libelle)->count();
			else $count = Client::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						Client::create($set);
						$msg = 'Client enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Client::findOrFail($id)->update($set);
						$msg = 'Client modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Client: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Client : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Client : ".serialize($request->post()));
					Log::warning("Client : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Client : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
		}else return 'x';
	}
}
