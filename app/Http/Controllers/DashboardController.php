<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use App\Models\Devis;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class DashboardController extends Controller
{
	//Tableau de bord
  	public function index(request $request){
		$arrayStatus = ['0', '1', '2', '3', '4', '5'];
		if((Session::has('idUsr'))&&(in_array($request->status, $arrayStatus))){
			//Title
			$title = 'Tableau de bord';
			//Breadcrumb
			$breadcrumb = 'Tableau de bord';
			//Menu
			$currentMenu = 'dashboard';
			//Submenu
			$currentSubMenu = '';
			//Modal
			$addmodal = '';
			//Requete Read
			$stats = DB::table('statistic')->first();
			$draft = $stats == '' ? 0:$stats->draft;
			$pending = $stats == '' ? 0:$stats->pending;
			$approved = $stats == '' ? 0:$stats->approved;
			$rejected = $stats == '' ? 0:$stats->rejected;
			$validated = $stats == '' ? 0:$stats->validated;
			$canceled = $stats == '' ? 0:$stats->canceled;
			//Requete Read
			$req = Devis::select('reference', 'date_at', 'mt_ttc', 'devis.status', 'libelle', 'lastname', 'firstname')
			->join('bill_addr', 'bill_addr.id', '=', 'devis.billaddr_id');
			//request->status
			switch($request->status){
				case '1' :
					$req->join('users', 'users.id', '=', 'devis.transmitted_id');
				break;
				case '2' :
				case '3' :
					$req->join('users', 'users.id', '=', 'devis.approved_id');
				break;
				case '4' :
				case '5' :
					$req->join('users', 'users.id', '=', 'devis.validated_id');
				break;
				default :
					$req->join('users', 'users.id', '=', 'devis.user_id');
			}
			$query = $req->where('devis.status', $request->status)
			->orderByDesc('date_at')
			->get();
			return view('pages.dashboard', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'draft', 'pending', 'approved', 'rejected', 'validated', 'canceled', 'query'));
		}else return redirect('/');
  	}
}
