<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Habilitation extends Model
{
    use HasFactory;

    protected $fillable = [
        'page_id',
        'right_id',
        'profil_id',
    ];
}
