<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Inspector;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class InspectorsController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Inspecteurs';
			//Breadcrumb
			$breadcrumb = 'Gestion des clients';
			//Menu
			$currentMenu = 'clients';
			//Submenu
			$currentSubMenu = 'inspectors';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[9]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|inspectorform|" title="Ajouter un inspecteur" submitbtn="Valider">Ajouter un inspecteur</a>':'';
			//Requete Read
			$query = Inspector::select('id', 'lastname', 'firstname', 'number', 'email', 'status', 'created_at')
			->orderByDesc('created_at')
			->get();
			return view('pages.inspectors', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Inspecteurs
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Inspector::whereId($id)->first();
				$email = $query->email;
				$number = $query->number;
				$lastname = $query->lastname;
				$firstname = $query->firstname;
			}else $lastname = $firstname = $number = $email = '';
			//Page de la vue
			return view('modals.inspectors', compact('id', 'lastname', 'firstname', 'number', 'email'));
	    }else return 'x';
	}
	//Add/Mod Inspecteurs
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$class = '';
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'lastname' => 'required',
				'firstname' => 'required',
				'number' => 'required',
				'email' => 'bail|required|email',
			], [
				'lastname.required' => "Nom obligatoire.",
				'firstname.required' => "Prenoms obligatoires.",
				'number.required' => "Numéro de téléphone obligatoire.",
				'email.required' => "Adresse e-mail obligatoire.",
				'email.email' => "Adresse e-mail non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Inspecteur : ".serialize($request->post()));
				if($errors->has('lastname')) return $Ok.'|'.$errors->first('lastname');
				if($errors->has('firstname')) return $Ok.'|'.$errors->first('firstname');
				if($errors->has('number')) return $Ok.'|'.$errors->first('number');
				if($errors->has('email')) return $Ok.'|'.$errors->first('email').'|.email';
			}
			$id = $request->id;
			//Test Email
			$email = Str::lower($request->email);
			if($id == 0) $count = Inspector::whereEmail($email)->count();
			else $count = Inspector::where([
				['id', '!=', $id],
				['email', $email],
			])->count();
			if($count == 0){
				$lastname = Str::upper(Myhelper::valideString($request->lastname));
				$firstname = mb_convert_case(Str::lower($request->firstname), MB_CASE_TITLE, "UTF-8");
				$prenom = explode(' ', $firstname);
				$username = $prenom[0].' '.$lastname;
				$set = [
					'email' => $email,
					'lastname' => $lastname,
					'firstname' => $firstname,
					'number' => $request->number,
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						Inspector::create($set);
						$msg = 'Inspecteur enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Inspector::findOrFail($id)->update($set);
						$msg = 'Inspecteur modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Inspecteur: '.$username, $type, $color, Session::get('avatar'));
					Log::info($type.' Inspecteur : '.serialize($request->post()));
					$Ok = 1;
				}catch(\Exception $e){
					Log::warning("Inspecteur : ".serialize($request->post()));
					Log::warning("Inspecteur : ".$e->getMessage());
				}
			}else{
				$class = '.email';
				$msg = "Adresse e-mail déjà utilisée";
				Log::warning("Inspecteur : ".$email." : ".$msg);
			}
			return $Ok.'|'.$msg.'|'.$class;
		}else return 'x';
	}
}
