<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Schedule;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class SchedulesController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Horaires';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'settings';
			//Submenu
			$currentSubMenu = 'schedules';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[13]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|scheduleform|mw-500px" title="Ajouter un horaire" submitbtn="Valider">Ajouter un horaire</a>':'';
			//Requete Read
			$query = Schedule::select('id', 'libelle', 'amount', 'status', 'created_at')
			->where('id', '!=', 1)
			->orderByDesc('created_at')
			->get();
			return view('pages.schedules', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Horaires
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Schedule::whereId($id)->first();
				$amount = $query->amount;
				$libelle = $query->libelle;
			}else $libelle = $amount = '';
			//Page de la vue
			return view('modals.schedules', compact('id', 'libelle', 'amount'));
	    }else return 'x';
	}
	//Add/Mod Horaires
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
				Log::warning("Horaire : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
				if($errors->has('amount')) return $Ok.'|'.$errors->first('amount').'|.number';
			}
			$id = $request->id;
			//Test Email
			$libelle = $request->libelle;
			if($id == 0) $count = Schedule::whereLibelle($libelle)->count();
			else $count = Schedule::where([
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
						Schedule::create($set);
						$msg = 'Horaire enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Schedule::findOrFail($id)->update($set);
						$msg = 'Horaire modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Horaire: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Horaire : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Horaire : ".serialize($request->post()));
					Log::warning("Horaire : ".$e->getMessage());
				}
			}else{
				$msg = "Nom déjà utilisé";
				Log::warning("Horaire : ".$libelle." : ".$msg);
			}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
