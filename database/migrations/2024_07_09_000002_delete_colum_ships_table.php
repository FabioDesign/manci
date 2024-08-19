<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class DeleteColumShipsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up(){
        Schema::table('ships', function($table){
            $table->dropColumn('billaddr_id');
            $table->dropColumn('inspector_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down(){
        Schema::table('ships', function($table){
            $table->integer('billaddr_id');
            $table->integer('inspector_id');
        });
    }
}
