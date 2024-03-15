<?php

namespace App\Http\Controllers;

use Session;
use Myhelper;
use Validator;
use App\Models\Page;
use App\Models\Right;
use App\Models\Profil;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\Habilitation;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class ProfilsController extends Controller
{
    //Liste des Profils
	public function index(){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Profils';
			//Breadcrumb
			$breadcrumb = 'Habilitation';
			//Menu
			$currentMenu = 'habilitation';
			//Submenu
			$currentSubMenu = 'profils';
			//Modal
			$addmodal = in_array(2, Session::get('rights')[4]) ? '<a href="/profilright/0" class="btn btn-sm fw-bold btn-primary">Ajouter un profil</a>':'';
			//Requete Read
			$query = Profil::where('id', '!=', 1)->get();
			return view('pages.profils', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'query'));
	    }else return redirect('/');
	}
	//Formulaire un Profil
	public function show(request $request){
    	if(Session::has('idUsr')){
			//Title
			$title = 'Profils';
			//Breadcrumb
			$breadcrumb = 'Habilitation';
			//Menu
			$currentMenu = 'habilitation';
			//Submenu
			$currentSubMenu = 'profils';
			//Modal
			$addmodal = '';
			$id = $request->id;
			//Page de la vue
			return view('forms.rights', compact('title', 'breadcrumb', 'currentMenu', 'currentSubMenu', 'addmodal', 'id'));
	    }else return redirect('/');
	}
	//Formulaire un Profil
	public function forms(request $request){
    	if(Session::has('idUsr')){
			$id = $request->id;
			if($id != 0){
				//Requete Read
				$query = Profil::whereId($id)->first();
				$libelle = $query->libelle;
			    $value = 'Modifier';
			    $titre = 'Modification';
			}else{
				$libelle = '';
			    $value = 'Valider';
			    $titre = 'Ajout';
			}
			$output = '<div class="row form-group fv-row mb-7">
			<label class="col-sm-12 col-xl-2 col-form-label text-lg-right fw-bolder text-dark fs-6 required">Nom</label>
	        <div class="col-sm-12 col-xl-6">
			<input type="text" name="libelle" class="form-control form-control-lg form-control-solid requiredField profil" placeholder="Libelle" value="'.$libelle.'" />
	        </div>
	      	</div>
	      	<div class="row form-group fv-row mb-2">
	        <label class="col-sm-12 col-xl-2 col-form-label text-lg-right fw-bolder text-dark fs-6">Tous cocher</label>
	        <div class="col-sm-12 col-xl-6" class="checkbox-inline">
	        <label class="boxcheck"><input type="checkbox" id="checkAll" class="iCheck">&nbsp;</label>
	        </div>
	      	</div>';
			//Requete Read
			$query1 = Page::where('status', '1')
			->orderBy('position')
			->get();
		    foreach($query1 as $data1):
		        if((Session::get('idPro') == 1)||(isset(Session::get('rights')[$data1->id]))){
				    $output .= '<div class="row form-group fv-row mb-2">
				        <label class="col-sm-12 col-xl-2 col-form-label text-lg-right fw-bolder text-dark fs-6">'.$data1->libelle.'</label>
				        <div class="col-sm-12 col-xl-10 checkbox-inline">';
					$show = 1;
					if($id == 1){
						$query2 = Right::all();
					}else{
						//Requete Read
						$query2 = Habilitation::select('rights.id', 'libelle')
				            ->join('rights', 'rights.id', '=', 'habilitations.right_id')
				            ->where([
				              ['profil_id', 1],
				              ['page_id', $data1->id],
				            ])
				            ->orderBy('rights.id')
				            ->get();
					}
					foreach($query2 as $data2):
						//Requete Read
						$count = Habilitation::where([
			              ['profil_id', $id],
			              ['page_id', $data1->id],
			              ['right_id', $data2->id],
			            ])->count();
						if($count != 0) $check = 'checked="checked"';
						else $check = '';
						if($data2->id == 1){
						  if($count == 0) $show = 0;
						$output .= '<label class="boxcheck"><input type="checkbox" name="check['.$data1->id.$data2->id.']" value="1" class="iCheck show" '.$check.'> <span style="margin: 0 15px 0 3px;">'.$data2->libelle.'</span></label>';
			            }else{
				            if($show == 0) $check = 'disabled="disabled"';
					        if(($id == 1)||(in_array($data2->id, Session::get('rights')[$data1->id]))){
					        	$output .= '<label class="boxcheck"><input type="checkbox" name="check['.$data1->id.$data2->id.']" value="'.$data2->id.'" class="iCheck check requiredField" '.$check.'> <span style="margin: 0 15px 0 3px;">'.$data2->libelle.'</span></label>';
					        }
				       	}
				    endforeach;
				    $output .= '</div></div>';
			    }
		  	endforeach;
		    $output .= '<span class="msgError" style="display: none;"></span>
			<div class="card-footer text-center">
			<button type="button" class="btn btn-square btn-danger font-weight-bold resetForm">Annuler</button>
			<button type="button" class="btn btn-square btn-primary font-weight-bold submitForm">'.$value.'</button>
			</div>';
			//Page de la vue
			return $output;
	    }else return 'x';
	}
	//Add/Mod Profil
	public function create(request $request){
    	if(Session::has('idUsr')){
			$Ok = 0;
			$msg = "Service indisponible, veuillez réessayer plus tard !";
			//Validator
			$validator = Validator::make($request->all(), [
				'libelle' => 'required',
			], [
				'libelle.required' => "Nom obligatoire.",
			]);
			//Error field
			if($validator->fails()){
				$errors = $validator->errors();
				Log::warning("Profil : ".serialize($request->post()));
				if($errors->has('libelle')) return $Ok.'|'.$errors->first('libelle');
			}
			$id = $request->id;
			$libelle = $request->libelle;
			if($id == 0) $count = Profil::whereLibelle($libelle)->count();
	    	else $count = Profil::where([
			    ['id', '!=', $id],
			    ['libelle', $libelle],
			])->count();
	    	if($count == 0){
				$set = [
					'libelle' => $libelle
				];
				try{
					if($id == 0){
						$set['status'] = '0';
						$set['user_id'] = Session::get('idUsr');
						$profil = Profil::create($set);
						$id = $profil->id;
						$msg = 'Profil enregistré avec succès.';
						$type = 'Ajouter';
						$color = 'success';
					}else{
						Profil::findOrFail($id)->update($set);
						$msg = 'Profil modifié avec succès.';
						$type = 'Modifier';
						$color = 'warning';
					}
					if($request->has('check')){
						Habilitation::whereProfilId($id)->delete();
						foreach($request->check as $key => $value):
							$set = [
								'profil_id' => $id,
								'right_id' => $value,
								'page_id' => substr($key, 0, -1)
							];
							Habilitation::create($set);
						endforeach;
					}
					$Ok = 1;
					Myhelper::logs(Session::get('username'), Session::get('profil'), 'Profil: '.$libelle, $type, $color, Session::get('avatar'));
					Log::info($type.' Profil : '.serialize($request->all()));
				}catch(\Exception $e){
					Log::warning("Profil : ".serialize($request->all()));
					Log::warning("Profil : ".$e->getMessage());
				}
			}else{
    			$class = '.profil';
	    		$msg = 'Profil déjà utilisé.';
	    		Log::warning("Profil : ".$libelle." : ".$msg);
	    	}
			return $Ok.'|'.$msg;
	    }else return 'x';
	}
}
