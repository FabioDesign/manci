<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Header;
use App\Models\Supplie;
use App\Models\DevisTyp;
use App\Models\Diameter;
use App\Models\Material;
use App\Models\Schedule;
use App\Models\Suppltyp;
use App\Models\Transport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class SettingsController extends Controller
{
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Type Devis';
			//Breadcrumb
			$breadcrumb = 'Paramètres';
			//Menu
			$currentMenu = 'settings';
			//Submenu
			$currentSubMenu = 'devistyp';
			//Modal
			$addmodal = '';
			//Requete Read
			$query = DevisTyp::all();
			return view('pages.devistyp', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	public function headers(){
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
	//Liste des Types
	public function lists(request $request){
		if(Session::has('idUsr')){
			//Requete Read
			$id = $request->id;
			switch($id){
				case 1 : $query = Schedule::whereStatus('1')->orderBy('libelle')->get(); break;
				case 2 : $query = Suppltyp::whereStatus('1')->orderBy('libelle')->get(); break;
				default : $query = Transport::whereStatus('1')->orderBy('libelle')->get();
			}
			$return = '<option value="" selected disabled>Sélectionner</option>';
			foreach($query as $data):
				$return .= "<option value='".$data->id."'>".$data->libelle."</option>";
			endforeach;
			if($id == 1) $return .= '<option value="1">Main d’œuvre</option>';
			if($id == 2){
				//Requete Read
				$material = Material::whereStatus('1')
				->orderBy('libelle')
				->get();
				$return .= '|<option value="0" selected>Aucun</option>';
				foreach($material as $data):
					$return .= "<option value='".$data->id."'>".$data->libelle."</option>";
				endforeach;
				//Requete Read
				$diameter = Diameter::whereStatus('1')
				->orderBy('libelle')
				->get();
				$return .= '|<option value="0" selected>Aucun</option>';
				foreach($diameter as $data):
					$return .= "<option value='".$data->id."'>".$data->libelle."</option>";
				endforeach;
			}
			return $return;
		}else return 'x';
	}
	//Liste des Types
	public function devprice(request $request){
		if(Session::has('idUsr')){
			//Requete Read
			$id = $request->id;
			$type = $request->type;
			switch($type){
				case 1 :
					$query = Schedule::whereId($id)->first();
					$return = $query->amount.'|';
				break;
				case 2 :
					$query = Supplie::where([
						['suppllib_id', $request->id],
						['material_id', $request->mat],
						['diameter_id', $request->dia],
					])->first();
					if($query != '')
						$return = $query->amount.'|'.$query->unit;
					else
						$return = '0|';
				break;
				default :
					$query = Transport::whereId($id)->first();
					$return = $query->amount.'|';
			}
			return $return;
		}else return 'x';
	}
}
