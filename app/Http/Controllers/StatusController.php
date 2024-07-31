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
use Illuminate\Support\Str;
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
			//Désactiver
			if($val == 0){
				$set = ['status' => '1'];
				$action = 'activé';
				$type = 'Activer';
				$color = 'success';
			}
			//Activer
			if($val == 1){
				$set = ['status' => '0'];
				$action = 'désactivé';
				$type = 'Désactiver';
				$color = 'danger';
			}
			//Supprimer
			if($val == 2){
				$action = 'supprimé';
				$type = 'Supprimer';
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
					//Supprimer
					if($val == 2)
						//Requete Delete
			    		Client::destroy($id);
					else
						//Requete Update
						Client::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 8:
					$Ok = 1;
					$title = 'Navire';
					//Requete Read
					$query = Ship::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Ship::destroy($id);
					else
						//Requete Update
						Ship::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
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
					//Supprimer
					if($val == 2)
						//Requete Delete
			    		Client::destroy($id);
					else
						//Requete Update
						BillAddr::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
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
					$title = 'Catégorie (fourniture)';
					//Requete Read
					$query = Suppltyp::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Suppltyp::destroy($id);
					else
						//Requete Update
						Suppltyp::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 13:
					$Ok = 1;
					$title = 'Horaire';
					//Requete Read
					$query = Schedule::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Requete Delete
			    		Schedule::destroy($id);
					else
						//Requete Update
						Schedule::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 14:
					$Ok = 1;
					$title = 'Nom commercial (Fourniture)';
					//Requete Read
					$query = Suppllib::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Suppllib::destroy($id);
					else
						//Requete Update
						Suppllib::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 15:
					$Ok = 1;
					$title = 'Transport';
					//Requete Read
					$query = Transport::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Transport::destroy($id);
					else
						//Requete Update
						Transport::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 16:
					$Ok = 1;
					$title = 'Quantité';
					//Requete Read
					$query = Quantity::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Quantity::destroy($id);
					else
						//Requete Update
						Quantity::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
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
					switch($val){
						case 0 :
							$action = 'transmis';
							$type = 'Transmettre';
							$set['transmitted_at'] = now();
							$set['transmitted_id'] = Session::get('idUsr');
							//Requete Update
							Devis::findOrFail($id)->update($set);
						break;
						case 1 :
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
						break;
						case 2 :
							$set = [
								'status' => '2',
								'approved_at' => now(),
								'approved_id' => Session::get('idUsr'),
							];
							//Requete Update
							Devis::findOrFail($id)->update($set);
							$action = 'approuvé';
							$type = 'Approuver';
							$color = 'success';
						break;
						case 3 :
							$set = [
								'status' => '3',
								'approved_at' => now(),
								'motif' => $request->motif,
								'approved_id' => Session::get('idUsr'),
							];
							//Requete Update
							Devis::findOrFail($id)->update($set);
							$action = 'rejeté';
							$type = 'Rejeter';
							$color = 'danger';
						break;
						case 4 :
							$set = [
								'status' => '4',
								'validated_at' => now(),
								'validated_id' => Session::get('idUsr'),
							];
							//Requete Update
							Devis::findOrFail($id)->update($set);
							$action = 'validé';
							$type = 'Valider';
							$color = 'success';
						break;
						case 5 :
							$set = [
								'status' => '5',
								'validated_at' => now(),
								'motif' => $request->motif,
								'validated_id' => Session::get('idUsr'),
							];
							//Requete Update
							Devis::findOrFail($id)->update($set);
							$action = 'refusé';
							$type = 'Refuser';
							$color = 'danger';
						break;
						case 6 :
							$last = Devis::all()->last();
							$array = Str::of($last->reference)->explode('/');
							$count = $array[0] + 1;
							$reference = sprintf('%04d', $count).'/'.date('y');
							$set = [
								'status' => '0',
								'date_at' => now(),
								'reference' => $reference,
								'ship_id' => $query->ship_id,
								'sum_rem' => $query->sum_rem,
								'sum_tva' => $query->sum_tva,
								'see_rem' => $query->see_rem,
								'see_tva' => $query->see_tva,
								'see_euro' => $query->see_euro,
								'header_id' => $query->header_id,
								'user_id' => Session::get('idUsr'),
								'billaddr_id' => $query->billaddr_id,
								'filename' => date('YmdHis').substr(microtime(), 2, 6).'.pdf',
							];
							$devis = Devis::create($set);
							// Requete Read
							$query1 = DevisTtr::whereDevisId($id)->get();
							foreach($query1 as $data1):
								$set = [
									'devis_id' => $devis->id,
									'libelle' => $data1->libelle,
								];
								$devisttr = DevisTtr::create($set);
								//Requete Read
								$query2 = DevisTyp::all();
								foreach($query2 as $devtyp):
									//Requete Read
									$where = [
										['devttr_id', $data1->id],
										['devtyp_id', $devtyp->id],
									];
									$query3 = DevisTxt::where($where)->first();
									if($query3 != ''){
										$set = [
											'devtyp_id' => $devtyp->id,
											'devttr_id' => $devisttr->id,
											'content' => $query3->content,
										];
										$DevisTxt = DevisTxt::create($set);
									}
									// Requete Read
									$query4 = Commande::where($where)->get();
									foreach($query4 as $data4):
										$set = [
											'unit' => $data4->unit,
											'valeur' => $data4->valeur,
											'amount' => $data4->amount,
											'devtyp_id' => $devtyp->id,
											'devttr_id' => $devisttr->id,
											'item_id' => $data4->item_id,
											'quantity' => $data4->quantity,
										];
										Commande::create($set);
									endforeach;
									// Requete Read
									$query5 = Proforma::where($where)->get();
									foreach($query5 as $data5):
										$set = [
											'total' => $data5->total,
											'mt_rem' => $data5->mt_rem,
											'devtyp_id' => $devtyp->id,
											'devttr_id' => $devisttr->id,
											'see_rem' => $data5->see_rem,
											'see_price' => $data5->see_price,
										];
										Proforma::create($set);
									endforeach;
								endforeach;
							endforeach;
							$action = 'dupliqué';
							$type = 'Dupliquer';
							$color = 'success';
						break;
					}
					$title = $libelle = 'Devis';
					//Libelle
					$txt = $libelle.' N°'.$query->reference.' '.$action;
				break;
				case 20:
					$Ok = 1;
					$title = 'Matière';
					//Requete Read
					$query = Material::whereId($id)->first();
					$libelle = $query->libelle;
					if($val == 2)
						//Supprimer
			    		Material::destroy($id);
					else
						//Requete Update
						Material::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 21:
					$Ok = 1;
					$title = 'Dimension';
					//Requete Read
					$query = Diameter::whereId($id)->first();
					$libelle = $query->libelle;
					//Supprimer
					if($val == 2)
						//Supprimer
			    		Diameter::destroy($id);
					else
						//Requete Update
						Diameter::findOrFail($id)->update($set);
					//Libelle
					$txt = $libelle.' '.$action;
				break;
				case 22:
					$Ok = 1;
					$title = 'Fourniture';
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
