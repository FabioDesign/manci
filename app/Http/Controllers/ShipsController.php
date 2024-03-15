<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Ship;
use App\Models\Client;
use App\Models\Inspector;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class ShipsController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Navires';
			//Breadcrumb
			$breadcrumb = 'Gestion des clients';
			//Menu
			$currentMenu = 'clients';
			//Submenu
			$currentSubMenu = 'ships';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[8]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|shipform|" title="Ajouter un navire" submitbtn="Valider">Ajouter un navire</a>':'';
			//Requete Read
			$query = Ship::select('ships.id', 'clients.libelle AS client', 'ships.libelle AS ships', 'bill_addr.libelle AS billaddr', 'lastname', 'firstname', 'ships.status', 'ships.created_at')
			->join('inspectors', 'inspectors.id', '=', 'ships.inspector_id')
			->join('bill_addr', 'bill_addr.id', '=', 'ships.billaddr_id')
			->join('clients', 'clients.id', '=', 'bill_addr.client_id')
			->orderByDesc('ships.created_at')
			->get();
			return view('pages.ships', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Liste des Navires
	public function lists(request $request){
		if(Session::has('idUsr')){
			//Requete Read
			$query = Ship::select('ships.id', 'ships.libelle')
			->join('bill_addr', 'bill_addr.id', '=', 'ships.billaddr_id')
			->join('clients', 'clients.id', '=', 'bill_addr.client_id')
			->whereClientId($request->id)
			->orderBy('ships.libelle')
			->get();
			$return = [];
			foreach($query as $data):
				$return[$data->id] = $data->libelle;
			endforeach;
			return $return;
		}else return 'x';
	}
	//Formulaire Navires
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Ship::select('bill_addr.libelle', 'billaddr_id', 'inspector_id', 'client_id')
				->join('bill_addr', 'bill_addr.id', '=', 'ships.billaddr_id')
				->join('clients', 'clients.id', '=', 'bill_addr.client_id')
				->where('ships.id', $id)
				->first();
				$libelle = $query->libelle;
				$client_id = $query->client_id;
				$billaddr_id = $query->billaddr_id;
				$inspector_id = $query->inspector_id;
			}else{
				$libelle = '';
				$client_id = $billaddr_id = $inspector_id = 0;
			}
			//Requete Read
			$sqlclt = client::whereStatus('1')
			->orderBy('libelle')
			->get();
			//Requete Read
			$sqlinsp = Inspector::whereStatus('1')
			->orderBy('lastname')
			->orderBy('firstname')
			->get();
			//Page de la vue
			return view('modals.ships', compact('id', 'libelle', 'billaddr_id', 'client_id', 'inspector_id', 'sqlclt', 'sqlinsp'));
	    }else return 'x';
	}
	//Add/Mod Navires
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
				'billaddr_id' => 'bail|required|integer|gt:0',
				'inspector_id' => 'bail|required|integer|gt:0',
			], [
				'libelle.required' => "Nom obligatoire.",
				'billaddr_id.required' => "Adresse Facturaction obligatoire.",
				'billaddr_id.gt' => "Adresse Facturaction non valide.",
				'inspector_id.required' => "Inspecteur obligatoire.",
				'inspector_id.gt' => "Inspecteur non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Navire : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
				if($errors->has('billaddr_id')) return $Ok.'|'.$errors->first('billaddr_id');
				if($errors->has('inspector_id')) return $Ok.'|'.$errors->first('inspector_id');
			}
			$id = $request->id;
			//Test Number
			$libelle = Str::upper(Myhelper::valideString($request->libelle));
			if($id == 0) $count = Ship::whereLibelle($libelle)->count();
			else $count = Ship::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
					'billaddr_id' => $request->billaddr_id,
					'inspector_id' => $request->inspector_id,
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						Ship::create($set);
						$msg = 'Navire enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Ship::findOrFail($id)->update($set);
						$msg = 'Navire modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Navire: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Navire : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Navire : ".serialize($request->post()));
					Log::warning("Navire : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Navire : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
	//Formulaire Navires
	public function detail(request $request){
    	if(Session::has('idUsr')){
			//Requete Read
			$query = Ship::select('clients.libelle AS client', 'ships.libelle AS ships', 'bill_addr.libelle AS billaddr', 'content', 'lastname', 'firstname', 'number', 'email')
			->join('inspectors', 'inspectors.id', '=', 'ships.inspector_id')
			->join('bill_addr', 'bill_addr.id', '=', 'ships.billaddr_id')
			->join('clients', 'clients.id', '=', 'bill_addr.client_id')
			->where('ships.id', $request->id)
			->first();
			$string = $query->billaddr.nl2br("\r\n").$query->content;
			$content = str_replace( "<br />", '', $string );
			//Page de la vue
			return view('modals.shipdetail', compact('query', 'content'));
	    }else return 'x';
	}
}
