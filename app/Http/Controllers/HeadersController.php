<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Header;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class HeadersController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Entête Facture';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'settings';
			//Submenu
			$currentSubMenu = 'headers';
			//Modal
			$addmodal = '';
			//Requete Read
			$query = Header::all();
			return view('pages.headers', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire Headers
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			//Requete Read
			$query = Header::whereId($id)->first();
			$libelle = $query->libelle;
			$footer = $query->footer;
			//Page de la vue
			return view('modals.headers', compact('id', 'libelle', 'footer'));
	    }else return 'x';
	}
	//Add/Mod Headers
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'footer' => 'required',
			], [
				'footer.required' => "Pied d'entête obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Header : ".serialize($request->post()));
				if($errors->has('footer')) return $Ok.'|'.$errors->first('footer');
			}
			$id = $request->id;
			$set = [
				'footer' => $request->footer,
			];
			try{
				Header::findOrFail($id)->update($set);
				$msg = 'Pieds de page modifié avec succès.';
				$type = 'Modifier';
				$color = 'warning';
				Myhelper::logs(Session::get('username'), Session::get('profil'), 'Header: Pied de page de '.$request->libelle, $type, $color, Session::get('avatar'));
				Log::info($type.' Header : '.serialize($request->post()));
				$Ok = 1;
			}catch(\Exception $e){
				Log::warning("Header : ".serialize($request->post()));
				Log::warning("Header : ".$e->getMessage());
			}
			return $Ok.'|'.$msg;
		}else return 'x';
	}
}
