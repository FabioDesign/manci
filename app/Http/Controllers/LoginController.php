<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\User;
use Illuminate\Support\Str;
use App\Models\Habilitation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;

class LoginController extends Controller
{
    //Logic Login
    public function login(request $request){
		$msgError = "Service indisponible, veuillez réessayer plus tard !";
		//Validator
		$validator = Validator::make($request->all(), [
	        'login' => 'required',
	        'password' => 'required|min:5',
	    ], [
	        'login.required' => "Login ou mot de passe incorrect.",
	        'password.*' => "Login ou mot de passe incorrect.",
	    ]);
	    //Error field
	    if($validator->fails()){
	        $errors = $validator->errors();
	        if($errors->has('login'))
	          	$msgError = $errors->first('login');
	        else if($errors->has('password'))
	          	$msgError = $errors->first('password');
			Log::warning('Login : '.serialize($request->all()));
	        return '0|'.$msgError;
	    }
		//Requete Read
		$query = User::select('users.id', 'gender', 'lastname', 'firstname', 'number', 'email', 'avatar', 'password', 'users.status AS status_usr', 'profil_id', 'libelle', 'profils.status AS status_pro')
		->join('profils', 'profils.id','=','users.profil_id')
        ->whereNumber($request->login)
        ->orWhere('email', $request->login)
        ->first();
		//Test Connexion
		if($query == null)
			return '0|Pseudo ou mot de passe incorrect.';
		else if($query->status_usr == '0')
			return '0|Votre compte est désactivé.';
		else if($query->status_pro == '0')
			return '0|Votre profil est désactivé.';
		else if(!(password_verify($request->password, $query->password))){
			Log::warning('Login : '.serialize($request->all()));
			return '0|Pseudo ou mot de passe incorrect.';
		}else{
    		$id = $query->id;
			$prenom = explode(' ', $query->firstname);
			$username = $prenom[0].' '.$query->lastname;
    		Session::put('idUsr', $id);
			Session::put('username', $username);
    		Session::put('idPro', $query->profil_id);
			Session::put('number', $query->number);
			Session::put('avatar', $query->avatar);
			Session::put('profil', $query->libelle);
			//Requete Read
			$euro = DB::table('euros')->whereStatus('1')->first();
			Session::put('euro', $euro->value);
			//Requete Read
			$droits = Habilitation::select('fichier', 'page_id', 'right_id')
			->join('pages', 'pages.id','=','habilitations.page_id')
	        ->where([
			    ['status', '1'],
			    ['profil_id', $query->profil_id],
			])->orderBy('position')
	        ->get();
			$rights = [];
			foreach($droits as $key => $data):
				if($key == 0) $page = $data->fichier;
				$rights[$data->page_id][] = $data->right_id;
			endforeach;
			Session::put('page', $page);
			Session::put('rights', $rights);
			try{
				//update last_login
				User::findOrFail($id)->update([
					'login_at' => now()
				]);
			}catch(\Exception $e){
				Log::warning("UpdateUser : ".$e->getMessage());
			}
			Myhelper::logs($username, $query->libelle, 'Accueil', 'Connecter', 'primary', $query->avatar);
			return '1|'.$page;
		}
    }
	//Logic Forgot password
	public function forgotpass(request $request){
		$Ok = 0;
		$msgError = "Adresse e-mail non valide.";
		//Validator
		$validator = Validator::make($request->all(), [
        	'email' => 'bail|required|email',
	    ], [
        	'email.*' => $msgError,
	    ]);
	    //Error field
	    if($validator->fails()){
	        $errors = $validator->errors();
	        if($errors->has('email'))
	        return '0|'.$errors->first('email');
			Log::warning('Forgotpass : '.serialize($request->all()));
	    }
		//Requete Read
		$where = [
			'users.status' => '1',
			'email' => $request->email
		];
		$query = User::join('profils', 'profils.id', '=', 'users.profil_id')
		->where($where)
		->first();
		if($query != null){
			$Ok = 1;
			$prenom = explode(' ', $query->firstname);
			$username = $prenom[0].' '.$query->lastname;
			//Requete Read
			$password = Myhelper::generate();
			$subject = "Nouveau Mot de passe";
			$gender = $query->gender == 'M' ? 'Cher':'Chère';
			$content = $gender." ".$username.",<br/>
			Votre nouveau mot de passe est : <strong>".$password."</strong>.<br/><br/>
			Cordialement<br/>
			L'équipe MANCI<br>
			27 21 25 08 14<br>
			maintenancenavireci@yahoo.fr";
			Myhelper::sendMail($query->email, '', $subject, $content);
			//Update passwd_change_code
			User::findOrFail($query->id)->update([
				'password_at' => now(),
				'password' => Hash::make($password),
			]);
			$msgError = "Mot de passe envoyé par mail avec succès.";
			Myhelper::logs($username, $query->libelle, 'Mot de passe oublié', 'Modifier', 'warning', $query->avatar);
		}else Log::warning('Forgotpass : '.$request->email);
		return $Ok.'|'.$msgError;
	}
    //Déconnexion
    public function logout(request $request){
    	if(Session::has('idUsr')){
			Myhelper::logs(Session::get('username'), Session::get('profil'), Session::get('page'), 'Deconnecter', 'primary', Session::get('avatar'));
			$request->session()->flush();
	    }
		return redirect('/');
    }
}
