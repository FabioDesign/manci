<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Devis extends Model
{
    public $table = 'devis';
    
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'mt_ht',
        'motif',
        'status',
        'mt_rem',
        'mt_tva',
        'mt_ttc',
        'mt_euro',
        'sum_tva',
        'sum_rem',
        'see_tva',
        'see_rem',
        'date_at',
        'ship_id',
        'user_id',
        'see_euro',
        'filename',
        'reference',
        'header_id',
        'billaddr_id',
        'approved_at',
        'approved_id',
        'validated_at',
        'validated_id',
        'transmitted_at',
        'transmitted_id',
    ];
}