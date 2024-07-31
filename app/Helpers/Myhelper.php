<?php
	namespace App\Helpers;
	
	use \Carbon\Carbon;
	use App\Models\User;
	use GuzzleHttp\Psr7;
	use App\Models\Logs;
	use App\Models\Devis;
	use GuzzleHttp\Client;
	use App\Models\Supplie;
	use App\Models\Commande;
	use App\Models\BillAddr;
	use App\Models\Suppllib;
	use App\Models\Messagerie;
	use Illuminate\Support\Str;
	use Illuminate\Http\Request;
	use PHPMailer\PHPMailer\SMTP;
	use PHPMailer\PHPMailer\PHPMailer;
	use Illuminate\Support\Facades\Log;
	use GuzzleHttp\Exception\GuzzleException;

	class Myhelper
	{
    	//sans accent
    	public static function valideString($string, $encoding='utf-8'){
      		// transformer les caractères accentués en entités HTML
      		$string = htmlentities($string, ENT_NOQUOTES, $encoding);
      		// remplacer les entités HTML pour avoir juste le premier caractères non accentués
      		// Exemple : "&ecute;" => "e", "&Ecute;" => "E", "Ã " => "a" ...
      		$string = preg_replace('#&([A-za-z])(?:acute|grave|cedil|circ|orn|ring|slash|th|tilde|uml);#', '\1', $string);
      		// Remplacer les ligatures tel que : Œ, Æ ...
      		// Exemple "Å“" => "oe"
      		$string = preg_replace('#&([A-za-z]{2})(?:lig);#', '\1', $string);
      		// Supprimer tout le reste
      		$string = preg_replace('#&[^;]+;€#', '', $string);
      		return $string;
    	}
		//Format English
	  	public static function formatDateEn($date){
			if($date != ''){
				$arrayDate = Str::of($date)->explode(' ');
				if(sizeof($arrayDate) == 1)
					return Carbon::parse($date)->format('Y-m-d');
				else
					return Carbon::parse($date)->format('Y-m-d H:i');
			}
	  	}
	    //Format Français
		public static function formatDateFr($date){
			if($date != ''){
				$arrayDate = Str::of($date)->explode(' ');
				if(sizeof($arrayDate) == 1)
					return Carbon::parse($date)->format('d-m-Y');
				else
					return Carbon::parse($date)->format('d-m-Y H:i');
			}
	  	}
		//Format Français
	  	public static function datejour($date){
			$mois = substr($date, 5, 2) - 1;
			$months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
			$date = substr($date, 8, 2).' '.$months[$mois].' '.substr($date, 0, 4);
	    	return $date;
	  	}
		//Format Euro
	  	public static function formatEuro($euro){
		  	$arrayEuro = Str::of($euro)->explode('.');
			if(sizeof($arrayEuro) == 1)
				$euro = number_format($euro, 0, ',', '.');
			else
		  		$euro = number_format($arrayEuro[0], 0, ',', '.').",".$arrayEuro[1];
			return $euro;
		}
		//Piste d'audit
		public static function logs($username, $profil, $libelle, $action, $color, $avatar){
			try{
				$set = [
					'color' => $color,
					'action' => $action,
					'profil' => $profil,
					'avatar' => $avatar,
					'libelle' => $libelle,
					'username' => $username,
				];
				Logs::create($set);
			}catch(Exception $e){
				Log::warning('Error : '.$e->getMessage());
			}
		}
		//Search Client
		public static function searchClt($field){
			$count = BillAddr::where('client_id', $field)->count();
			return $count;
		}
		//Search Navire
		public static function searchShip($field){
			$count = Devis::where('ship_id', $field)->count();
			return $count;
		}
		//Search Billing Address
		public static function searchAddr($field){
			$count = Devis::where('billaddr_id', $field)->count();
			return $count;
		}
		//Search Nom
		public static function searchNom($field){
			$count = Supplie::where('suppllib_id', $field)->count();
			return $count;
		}
		//Search Material
		public static function searchMat($field){
			$count = Supplie::where('material_id', $field)->count();
			return $count;
		}
		//Search Dimension
		public static function searchQualif($field){
			$count = Supplie::where('diameter_id', $field)->count();
			return $count;
		}
		//Search Type Fourniture
		public static function searchFounrTyp($field){
			$count = Suppllib::where('suppltyp_id', $field)->count();
			return $count;
		}
		//Search Supplie/
		public static function searchDevtyp($field, $typ){
			$count = Commande::where([
				'item_id' => $field,
				'devtyp_id' => $typ,
			])->count();
			return $count;
		}
    	//Send mail
	  	public static function sendMail($to, $cc, $subject, $content){
	  		require base_path("vendor/autoload.php");
      		$mail = new PHPMailer(true);   // Passing `true` enables exceptions
      		$mail->CharSet = "UTF-8";
      		$config = Messagerie::first();
	      	try{
		        // Email server settings
		        $mail->SMTPDebug = 0;
		        $mail->isSMTP();
		        $mail->Host = $config->host;           	// smtp host
		        $mail->SMTPAuth = true;
		        $mail->Username = $config->user;   		// sender username
		        $mail->Password = $config->password;    // sender password
		        $mail->SMTPSecure = "ssl";              // encryption - ssl/tls
		        $mail->Port = $config->port;            // port - 587/465
		        $mail->timeout = null;
		        $mail->Encoding = 'base64';

		        $mail->setFrom($config->user, $config->sender);
		        $mail->addAddress($to);
				if($cc != ''){
					foreach($cc as $email):
						$mail->AddCC($email);
					endforeach;
				}
		        $mail->addReplyTo($config->user, $config->sender);
		        $mail->SMTPOptions = [
			    	'ssl' => [
				        'verify_peer' => false,
				        'verify_peer_name' => false,
				        'allow_self_signed' => false
				    ]
				];
		        $mail->isHTML(true);                	// Set email content format to HTML
		        $mail->Subject = $subject;
		        $mail->Body = $content;
	        	if($mail->send())
        			Log::info('Success : Email has been sent.');
	        	else
	    			Log::warning('failed : '.$mail->ErrorInfo);
	      	}catch(Exception $e){
	           	Log::warning('Error : '.$e->getMessage());
	      	}
		}
		//Génération du password
		public static function generate(){			
			// liste des valeurs possibles pour chaque type de caractères
			$chars = "abcdefghijklmnopqrstuvwxyz";
			$caps = Str::upper($chars);
			$nums = "0123456789";
			$syms = "!@#$%^&*()-+?";
			
			$out = self::select($chars, 5); // sélectionne aléatoirement 5 lettres minuscules
			$out .= self::select($caps, 1); // sélectionne aléatoirement 1 lettre majuscule
			$out .= self::select($nums, 1); // sélectionne aléatoirement 1 chiffre
			$out .= self::select($syms, 1); // sélectionne aléatoirement 1 caractère spécial
			
			// Tout est là, on mélange le tout
			return str_shuffle($out);
		}
		private static function select($src, $l){
			$out = '';
			for($i = 0; $i < $l; $i++):
			   $out .= Str::substr($src, mt_rand(0, strlen($src)-1), 1);
			endfor;
			return $out;
		}
	}