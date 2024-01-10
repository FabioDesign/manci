<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PDFController;
use App\Http\Controllers\LogsController;
use App\Http\Controllers\DevisController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\ShipsController;
use App\Http\Controllers\UsersController;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\ClientsController;
use App\Http\Controllers\ProfilsController;
use App\Http\Controllers\BilladdrController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\QuantityController;
use App\Http\Controllers\SuppliesController;
use App\Http\Controllers\SuppllibController;
use App\Http\Controllers\SuppltypController;
use App\Http\Controllers\DiametersController;
use App\Http\Controllers\MaterialsController;
use App\Http\Controllers\SchedulesController;
use App\Http\Controllers\TransportController;
use App\Http\Controllers\InspectorsController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

//404
Route::fallback(function(){
    return view('404');
});
//BACKEND
Route::view('/', 'login');
Route::view('forgotpass', 'forgotpass');
//Statut
Route::post('status', 'App\Http\Controllers\StatusController@index');
//Dashboard
Route::get('dashboard/{status}', 'App\Http\Controllers\DashboardController@index');
//Login
Route::controller(LoginController::class)->group(function(){
    Route::post('login', 'login');
    Route::get('logout', 'logout');
    Route::post('forgotpass', 'forgotpass');
});
//Profil
Route::controller(ProfilsController::class)->group(function(){
    Route::get('profils', 'index');
    Route::post('profilform', 'forms');
    Route::post('profilcreate', 'create');
    Route::get('profilright/{id}', 'show');
});
//Users
Route::controller(UsersController::class)->group(function(){
    Route::get('users', 'index');
    Route::post('userform', 'forms');
    Route::post('usercreate', 'create');
});
//My Profile
Route::controller(AccountController::class)->group(function(){
    Route::get('account', 'index');
    Route::get('settings', 'settings');
    Route::get('password', 'password');
    Route::post('changepass', 'changepass');
});
//Clients
Route::controller(ClientsController::class)->group(function(){
    Route::get('clients', 'index');
    Route::post('clientform', 'forms');
    Route::post('clientcreate', 'create');
});
//Ships
Route::controller(ShipsController::class)->group(function(){
    Route::get('ships', 'index');
    Route::post('shipform', 'forms');
    Route::post('shiplist', 'lists');
    Route::post('shipcreate', 'create');
    Route::post('shipdetail', 'detail');
});
//Inspectors
Route::controller(InspectorsController::class)->group(function(){
    Route::get('inspectors', 'index');
    Route::post('inspectorform', 'forms');
    Route::post('inspectorcreate', 'create');
});
//Billaddr
Route::controller(BilladdrController::class)->group(function(){
    Route::get('billaddr', 'index');
    Route::post('billaddrlist', 'lists');
    Route::post('billaddrform', 'forms');
    Route::post('billaddrcreate', 'create');
});
//Schedules
Route::controller(SchedulesController::class)->group(function(){
    Route::get('schedules', 'index');
    Route::post('scheduleform', 'forms');
    Route::post('schedulecreate', 'create');
});
//Suppltyp
Route::controller(SuppltypController::class)->group(function(){
    Route::get('suppltyp', 'index');
    Route::post('suppltypform', 'forms');
    Route::post('suppltypcreate', 'create');
});
//Suppllib
Route::controller(SuppllibController::class)->group(function(){
    Route::get('suppllib', 'index');
    Route::post('supplliblist', 'lists');
    Route::post('suppllibform', 'forms');
    Route::post('suppllibcreate', 'create');
});
//Materials
Route::controller(MaterialsController::class)->group(function(){
    Route::get('materials', 'index');
    Route::get('materiallist', 'lists');
    Route::post('materialform', 'forms');
    Route::post('materialcreate', 'create');
});
//Diameters
Route::controller(DiametersController::class)->group(function(){
    Route::get('diameters', 'index');
    Route::post('diameterform', 'forms');
    Route::post('diametercreate', 'create');
});
//Supplies
Route::controller(SuppliesController::class)->group(function(){
    Route::get('supplies', 'index');
    Route::post('supplieform', 'forms');
    Route::post('suppliecreate', 'create');
});
//Transport
Route::controller(TransportController::class)->group(function(){
    Route::get('transport', 'index');
    Route::post('transportform', 'forms');
    Route::post('transportcreate', 'create');
});
//Quantity
Route::controller(QuantityController::class)->group(function(){
    Route::get('quantity', 'index');
    Route::get('quantitylist', 'lists');
    Route::post('qtevalue', 'qtevalue');
    Route::post('quantityform', 'forms');
    Route::post('quantitycreate', 'create');
});
//Settings
Route::controller(SettingsController::class)->group(function(){
    Route::get('devistyp', 'index');
    Route::get('headers', 'headers');
    Route::post('devprice', 'devprice');
    Route::post('settinglist', 'lists');
});
//Devis
Route::controller(DevisController::class)->group(function(){
    Route::get('devis', 'index');
    Route::get('billings', 'bills');
    Route::post('devstatus', 'status');
    Route::post('devismod', 'listmod');
    Route::post('devlinemod', 'linemod');
    Route::post('deviscreate', 'create');
    Route::get('devisform/{id}', 'forms');
});
//Logs
Route::controller(LogsController::class)->group(function(){
    Route::match(['get', 'post'], 'logs', 'index');
});
//Export
Route::controller(PDFController::class)->group(function(){
    Route::post('pdfdevis', 'pdfdevis');
    Route::post('pdfbills', 'pdfbills');
});