<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BillAddr extends Model
{
    public $table = 'bill_addr';
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'status',
        'libelle',
        'content',
        'user_id',
        'client_id',
    ];
}
