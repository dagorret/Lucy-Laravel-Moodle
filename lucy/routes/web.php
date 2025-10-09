<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TeamsProvisionController;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/provision/teams', [TeamsProvisionController::class, 'form'])->name('teams.form');
//Borrar
//Route::get('/provision/teams', fn() => 'OK')->name('teams.form');

Route::post('/provision/teams', [TeamsProvisionController::class, 'provision'])->name('teams.provision');

