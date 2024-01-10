<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Commande extends Model
{
    use HasFactory;
    
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'unit',
        'valeur',
        'amount',
        'item_id',
        'display',
        'quantity',
        'devttr_id',
        'devtyp_id',
    ];
}
