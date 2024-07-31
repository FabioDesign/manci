<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\User;
use App\Models\Profil;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;

class UsersController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Utilisateur';
			//Breadcrumb
			$breadcrumb = 'Habilitation';
			//Menu
			$currentMenu = 'habilitation';
			//Submenu
			$currentSubMenu = 'users';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[3]) ? '<a href="#" class="btn btn-sm btn-primary modalform" data-h="0|userform|" title="Ajouter un utilisateur" submitbtn="Valider">Ajouter un utilisateur</a>':'';
			//Requete Read
			$query = User::select('users.id', 'lastname', 'firstname', 'gender', 'number', 'email', 'avatar', 'users.status', 'users.created_at', 'libelle')
			->join('profils', 'profils.id', '=', 'users.profil_id')
			->where('users.id', '!=', 1)
			->orderByDesc('users.created_at')
			->get();
			return view('pages.users', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Utilisateur
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = User::whereId($id)->first();
				$email = $query->email;
				$number = $query->number;
				$gender = $query->gender;
				$lastname = $query->lastname;
				$firstname = $query->firstname;
				$profil_id = $query->profil_id;
			}else $lastname = $firstname = $gender = $number = $email = $profil_id = '';
			//Gender
			$arraySex = ['M' => "Homme", 'F' => "Femme"];
			//Requete Read
			$sqlpro = Profil::select('id', 'libelle')
			->where([
				['id', '!=', 1],
				['status', '1'],
			])
			->orderBy('libelle')
			->get();
			//Page de la vue
			return view('modals.users', compact('id', 'lastname', 'firstname', 'gender', 'number', 'email', 'profil_id', 'arraySex', 'sqlpro'));
	    }else return 'x';
	}
	//Add/Mod Utilisateur
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$class = '';
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'lastname' => 'required',
				'firstname' => 'required',
				'gender' => 'bail|required|in:M,F',
				'number' => 'bail|required|regex:/^[0-9\s]+$/',
				'email' => 'bail|required|email',
				'profil_id' => 'bail|required|integer|gt:0',
			], [
				'lastname.required' => "Nom obligatoire.",
				'firstname.required' => "Prenoms obligatoires.",
				'gender.*' => "Genre non valide.",
				'number.required' => "Numéro de téléphone obligatoire.",
				'number.regex' => "Numéro de téléphone non valide.",
				'email.required' => "Adresse e-mail obligatoire.",
				'email.email' => "Adresse e-mail non valide.",
				'profil_id.required' => "Profil obligatoire.",
				'profil_id.gt' => "Profil non valide.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Utilisateur : ".serialize($request->post()));
				if($errors->has('lastname')) return $Ok.'|'.$errors->first('lastname');
				if($errors->has('firstname')) return $Ok.'|'.$errors->first('firstname');
				if($errors->has('gender')) return $Ok.'|'.$errors->first('gender');
				if($errors->has('number')) return $Ok.'|'.$errors->first('number').'|.number';
				if($errors->has('email')) return $Ok.'|'.$errors->first('email').'|.email';
				if($errors->has('profil_id')) return $Ok.'|'.$errors->first('profil_id');
			}
			$id = $request->id;
			//Test Number
			$number = $request->number;
			if($id == 0) $count = User::whereNumber($number)->count();
			else $count = User::where([
				['id', '!=', $id],
				['number', $number],
			])->count();
			if($count == 0){
				//Test Email
				$email = Str::lower($request->email);
				if($id == 0) $count = User::whereEmail($email)->count();
				else $count = User::where([
					['id', '!=', $id],
					['email', $email],
				])->count();
				if($count == 0){
					$avatar = $request->gender == 'M' ? 'homme.jpg':'femme.jpg';
					$username = $lastname = Str::upper(Myhelper::valideString($request->lastname));
					$firstname = mb_convert_case(Str::lower($request->firstname), MB_CASE_TITLE, "UTF-8");
					$prenom = explode(' ', $firstname);
					$username = $prenom[0].' '.$lastname;
					$set = [
						'email' => $email,
						'avatar' => $avatar,
						'number' => $number,
						'lastname' => $lastname,
						'firstname' => $firstname,
						'gender' => $request->gender,
						'profil_id' => $request->profil_id,
					];
					if($request->hasFile('avatar')){
						//Validator
						$validator = Validator::make($request->all(), [
							'avatar' => 'bail|image|mimes:png,jpg,jpeg|max:5120|dimensions:min_width=100,min_height=100',
						], [
							'avatar.image' => "La photo joint n’est pas une image.",
							'avatar.mimes' => "Le type de la photo joint n’est pas autorisé, utiliser le format recommandé.",
							'avatar.max' => "La taille de la photo chargé doit être inférieure ou égale à 5Mo.",
							'avatar.dimensions' => "Les dimensions de la photo doivent être supérieures à 100H x 100L.",
						]);
						//Error field
						if($validator->fails()){
							$errors = $validator->errors();
							Log::warning("ImgUser : ".$errors->first('avatar'));
							if($errors->has('avatar')) return $Ok.'|'.$errors->first('avatar');
						}
						$dir = 'assets/media/avatars';
						$image = $request->file('avatar');
						$avatar = Str::lower(date('YmdHis').'.'.$image->getClientOriginalExtension());
						if($image->move($dir, $avatar)){
							$set['avatar'] = $avatar;
							Session::put('avatar', $avatar);
						}
					}
					try{
						if($id == 0){
							$set['status'] = '1';
							$set['user_id'] = Session::get('idUsr');
							$set['password'] = Hash::make('manci@2023');
							User::create($set);
							$msg = 'Utilisateur enregistré avec succès.';
							$type = 'Ajouter';
							$color = 'success';
						}else{
							User::findOrFail($id)->update($set);
							$msg = 'Utilisateur modifié avec succès.';
							$type = 'Modifier';
							$color = 'warning';
						}
						Myhelper::logs(Session::get('username'), Session::get('profil'), 'Utilisateur: '.$username, $type, $color, Session::get('avatar'));
						Log::info($type.' Utilisateur : '.serialize($request->post()));
						$Ok = 1;
					}catch(\Exception $e){
						Log::warning("Utilisateur : ".serialize($request->post()));
						Log::warning("Utilisateur : ".$e->getMessage());
					}
				}else{
					$class = '.email';
					$msg = "Adresse e-mail déjà utilisée";
					Log::warning("Utilisateur : ".$email." : ".$msg);
				}
			}else{
				$class = '.number';
				$msg = "Numéro de téléphone déjà utilisé";
				Log::warning("Utilisateur : ".$number." : ".$msg);
			}
			return $Ok.'|'.$msg.'|'.$class;
	    }else return 'x';
	}
}
