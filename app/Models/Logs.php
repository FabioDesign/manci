<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Logs extends Model
{
    public $table = 'logs';
    
    protected $fillable = [
        'color',
        'action',
        'profil',
        'avatar',
        'libelle',
        'username',
    ];
}
