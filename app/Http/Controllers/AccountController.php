<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\User;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;

class AccountController extends Controller
{
	//Parametre user
	public function index(request $request){
    	if(Session::has('idUsr')){
			//titre
			$title = 'Mon compte';
			//Breadcrumb
			$breadcrumb = 'Infos perso';
			//Menu
			$currentMenu = 'infosperso';
			//Submenu
			$currentSubMenu = 'account';
			//Modal
			$addmodal = '';
			//Requete Read
			$query = User::select('lastname', 'firstname', 'gender', 'number', 'email', 'avatar', 'libelle')
			->join('profils', 'profils.id', '=', 'users.profil_id')
			->where('users.id', Session::get('idUsr'))
			->first();
			//Page de la vue
			return view('forms.account', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire password
	public function password(request $request){
    	if(Session::has('idUsr')){
			//titre
			$title = 'Mot de passe';
			//Breadcrumb
			$breadcrumb = 'Infos perso';
			//Menu
			$currentMenu = 'infosperso';
			//Submenu
			$currentSubMenu = 'password';
			//Modal
			$addmodal = '';
			//Requete Read
			$query = User::select('lastname', 'firstname', 'gender', 'number', 'email', 'avatar', 'libelle')
			->join('profils', 'profils.id', '=', 'users.profil_id')
			->where('users.id', Session::get('idUsr'))
			->first();
			//Page de la vue
			return view('forms.password', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Change password
	public function changepass(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$class = '';
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
		        'oldpass' => 'required',
		        'password' => 'required|confirmed|min:5',
		    ], [
		        'oldpass.required' => "Mot de passe obligatoire.",
		        'password.required' => "Mot de passe obligatoire.",
		        'password.confirmed' => "Les mots de passe ne sont pas identiques.",
		        'password.min' => "Les mots de passe doivent être supérieur à 5 caractères.",
		    ]);
		    //Error field
		    if($validator->fails()){
		        $errors = $validator->errors();
				Log::warning("PasswordUser : ".serialize($request->all()));
		        if($errors->has('oldpass')) return $Ok.'|'.$errors->first('oldpass').'|.oldpass';
		        if($errors->has('password')) return $Ok.'|'.$errors->first('password').'|.password';
		    }
			$id = Session::get('idUsr');
			//Requete Read
			$query = User::whereId($id)->first();
			if(password_verify($request->oldpass, $query->password)){
				$Ok = 2;
	            $set = [
					'password_at' => now(),
	            	'password' => Hash::make($request->password)
	            ];
		        User::findOrFail($id)->update($set);
				$msg = "Mot de passe modifié avec succès.";
			}else{
				$class = '.oldpass';
				$msg = "Ancien mot de passe incorrect.";
			}
			return $Ok.'|'.$msg.'|'.$class;
	    }else return 'x';
	}
}
