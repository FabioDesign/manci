<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateHeadersTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void {
        Schema::create('headers', function (Blueprint $table){
            $table->engine = 'InnoDB';
            $table->tinyIncrements('id');
            $table->string('libelle', 50);
            $table->string('header', 50);
            $table->text('footer');
            $table->enum('status', ['0', '1']);
            $table->dateTime('created_at');
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void {
        Schema::dropIfExists('headers');
    }
};
