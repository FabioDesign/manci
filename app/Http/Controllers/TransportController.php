<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Transport;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class TransportController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Transports';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'settings';
			//Submenu
			$currentSubMenu = 'transport';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[15]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|transportform|mw-500px" title="Ajouter un transport" submitbtn="Valider">Ajouter un transport</a>':'';
			//Requete Read
			$query = Transport::select('id', 'libelle', 'amount', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.transport', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Transports
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Transport::whereId($id)->first();
				$amount = $query->amount;
				$libelle = $query->libelle;
			}else $libelle = $amount = '';
			//Page de la vue
			return view('modals.transport', compact('id', 'libelle', 'amount'));
	    }else return 'x';
	}
	//Add/Mod Transports
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
				'amount' => 'bail|required|regex:/^[0-9\s]+$/',
			], [
				'libelle.required' => "Nom obligatoire.",
				'amount.required' => "Montant obligatoire.",
				'amount.regex' => "Montant non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Transport : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
				if($errors->has('amount')) return $Ok.'|'.$errors->first('amount').'|.number';
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Transport::whereLibelle($libelle)->count();
			else $count = Transport::where([
				['id', '!=', $id],
				['libelle', $libelle],
			])->count();
			if($count == 0){
				$set = [
					'libelle' => $libelle,
					'amount' => $request->amount,
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						Transport::create($set);
						$msg = 'Transport enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Transport::findOrFail($id)->update($set);
						$msg = 'Transport modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Transport: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Transport : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Transport : ".serialize($request->post()));
					Log::warning("Transport : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Transport : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
