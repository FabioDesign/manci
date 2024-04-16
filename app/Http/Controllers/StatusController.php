<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use App\Models\User;
use App\Models\Ship;
use App\Models\Devis;
use App\Models\Profil;
use App\Models\Client;
use App\Models\Header;
use App\Models\Supplie;
use App\Models\Commande;
use App\Models\Schedule;
use App\Models\BillAddr;
use App\Models\Devistyp;
use App\Models\Proforma;
use App\Models\Quantity;
use App\Models\Diameter;
use App\Models\Material;
use App\Models\Suppllib;
use App\Models\Suppltyp;
use App\Models\DevisTtr;
use App\Models\DevisTxt;
use App\Models\Inspector;
use App\Models\Transport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class StatusController extends Controller{
	public function index(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$id = $request->id;
			$val = $request->val;
			$typ = $request->typ;
			if($val == 0){
				$set = ['status' => '1'];
				$action = 'activé';
				$type = 'Activer';
				$color = 'success';
			}
			if($val == 1){
				$set = ['status' => '0'];
				$action = 'désactivé';
				$type = 'Désactiver';
				$color = 'danger';
			}
			$msg = "Une erreur s'est produite, veuillez réessayer plutard !";
			//Requete Read
			$select = '*';
			switch($typ){
				case 3:
					$Ok = 1;
					$title = 'Utilisateur';
					//Requete Read
					$query = User::whereId($id)->first();
					$prenom = explode(' ', $query->firstname);
					$libelle = $username = $prenom[0].' '.$query->lastname;
					//Libelle
					$txt = $username.' '.$action;
					//Requete Update
					User::findOrFail($id)->update($set);
				break;
				case 4:
					$Ok = 1;
					$title = 'Profil';
					//Requete Read
					$query = Profil::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Profil::findOrFail($id)->update($set);
				break;
				case 7:
					$Ok = 1;
					$title = 'Client';
					//Requete Read
					$query = Client::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Client::findOrFail($id)->update($set);
				break;
				case 8:
					$Ok = 1;
					$title = 'Navire';
					//Requete Read
					$query = Ship::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Ship::findOrFail($id)->update($set);
				break;
				case 9:
					$Ok = 1;
					$title = 'Inspecteur';
					//Requete Read
					$query = Inspector::whereId($id)->first();
					$prenom = explode(' ', $query->firstname);
					$libelle = $username = $prenom[0].' '.$query->lastname;
					//Libelle
					$txt = $username.' '.$action;
					//Requete Update
					Inspector::findOrFail($id)->update($set);
				break;
				case 10:
					$Ok = 1;
					$title = 'Adresse Facturaction';
					//Requete Read
					$query = BillAddr::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					BillAddr::findOrFail($id)->update($set);
				break;
				case 11:
					$Ok = 1;
					$title = 'Type Devis';
					//Requete Read
					$query = Devistyp::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Devistyp::findOrFail($id)->update($set);
				break;
				case 12:
					$Ok = 1;
					$title = 'Type (fourniture)';
					//Requete Read
					$query = Suppltyp::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Suppltyp::findOrFail($id)->update($set);
				break;
				case 13:
					$Ok = 1;
					$title = 'Horaire';
					//Requete Read
					$query = Schedule::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Schedule::findOrFail($id)->update($set);
				break;
				case 14:
					$Ok = 1;
					$title = 'Nom (Fourniture)';
					//Libelle
					$txt = $title.' '.$action;
					//Requete Update
					Suppllib::findOrFail($id)->update($set);
				break;
				case 15:
					$Ok = 1;
					$title = 'Transport';
					//Requete Read
					$query = Transport::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Transport::findOrFail($id)->update($set);
				break;
				case 16:
					$Ok = 1;
					$title = 'Quantité';
					//Requete Read
					$query = Quantity::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Quantity::findOrFail($id)->update($set);
				break;
				case 17:
					$Ok = 1;
					$title = 'Entête Facture';
					//Requete Read
					$query = Header::whereId($id)->first();
					$libelle = $query->libelle;
					//Libelle
					$txt = $libelle.' '.$action;
					//Requete Update
					Header::findOrFail($id)->update($set);
				break;
				case 18:
					$Ok = 1;
					//Requete Read
					$query = Devis::whereId($id)->first();
					//Supprimer
					if($val != 1){
						if($val == 0){
							$action = 'transmis';
							$type = 'Transmettre';
							$set['transmitted_at'] = now();
							$set['transmitted_id'] = Session::get('idUsr');
						}
						if($val == 2){
							$set = [
								'status' => '2',
								'approved_at' => now(),
								'approved_id' => Session::get('idUsr'),
							];
							$action = 'approuvé';
							$type = 'Approuver';
							$color = 'success';
						}
						if($val == 3){
							$set = [
								'status' => '3',
								'approved_at' => now(),
								'motif' => $request->motif,
								'approved_id' => Session::get('idUsr'),
							];
							$action = 'rejeté';
							$type = 'Rejeter';
							$color = 'danger';
						}
						if($val == 4){
							$set = [
								'status' => '4',
								'validated_at' => now(),
								'validated_id' => Session::get('idUsr'),
							];
							$action = 'validé';
							$type = 'Valider';
							$color = 'success';
						}
						if($val == 5){
							$set = [
								'status' => '5',
								'validated_at' => now(),
								'motif' => $request->motif,
								'validated_id' => Session::get('idUsr'),
							];
							$action = 'refusé';
							$type = 'Refuser';
							$color = 'danger';
						}
						//Requete Update
						Devis::findOrFail($id)->update($set);
					}else{
						$action = 'supprimé';
						$type = 'Supprimer';
						//Requete Read
						$sql = DevisTtr::where('devis_id', $id)->get();
						foreach($sql as $data):
							$where = [
								['devttr_id', $data->id],
							];
							DevisTxt::where($where)->delete();
							Proforma::where($where)->delete();
							Commande::where($where)->delete();
						endforeach;
						DevisTtr::where('devis_id', $id)->delete();
			    		Devis::destroy($id);
						//Requete Read
						$stats = DB::table('statistic')->where('status', '1')->first();
						$draft = $stats->draft - 1;
						$set = [
							'draft' => $draft,
						];
						DB::table('statistic')->where('status', '1')->update($set);
					}
					$title = $libelle = 'Devis';
					//Libelle
					$txt = $libelle.' N°'.$query->reference.' '.$action;
				break;
				case 20:
					$Ok = 1;
					$title = 'Matière';
					if($val == 2){
						$action = 'supprimé';
						$type = 'Supprimer';
						$color = 'danger';
			    		Material::destroy($id);
					}else{
						//Requete Update
						Material::findOrFail($id)->update($set);
					}
					//Libelle
					$txt = $title.' '.$action;
				break;
				case 21:
					$Ok = 1;
					$title = 'Qualification';
					//Libelle
					$txt = $title.' '.$action;
					//Requete Update
					Diameter::findOrFail($id)->update($set);
				break;
				case 22:
					$Ok = 1;
					$title = 'Fourniture';
					$action = 'supprimé';
					$type = 'Supprimer';
					$color = 'danger';
					Supplie::destroy($id);
					//Libelle
					$txt = $title.' '.$action;
				break;
				default: break;
			}
			$msg = $Ok == 1 ? $txt.' avec succès':$msg;
			//Log
			Log::info($type.' '.$title.' : '.serialize($request->post()));
			Myhelper::logs(Session::get('username'), Session::get('profil'), $title, $type, $color, Session::get('avatar'));
			return $Ok.'|'.$msg;
	    }else return redirect('/');
    }
}
