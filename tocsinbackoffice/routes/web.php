<?php

use Illuminate\Support\Facades\Route;

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

Auth::routes();


Route::group(['middleware' => ['auth']], function () {
    Route::get('/', [App\Http\Controllers\NewsController::class, 'index'])->name('index');
    Route::get('/newsLists', [App\Http\Controllers\NewsController::class, 'index'])->name('newslists');
    Route::get('/newsLists/{id}', [App\Http\Controllers\NewsController::class, 'show'])->name('viewnews');
    Route::get('/newsLists/{id}/del', [App\Http\Controllers\NewsController::class, 'destroy'])->name('delnews');

    Route::post('newsLists/found', [App\Http\Controllers\LocationController::class, 'store'])->name('storelocation');

    Route::get('newsLists/{id}/edit', [App\Http\Controllers\LocationController::class, 'edit'])->name('editlocation');
    Route::get('newsLists/{id}/nedit', [App\Http\Controllers\LocationController::class, 'edit_notfound'])->name('editlocation-notfound');
    Route::post('newsLists/{id}/update', [App\Http\Controllers\LocationController::class, 'update'])->name('updatelocation');
    Route::post('newsLists/{id}/del', [App\Http\Controllers\LocationController::class, 'destroy'])->name('dellocation');

    Route::post('newsLists/notfound', [App\Http\Controllers\NewsController::class, 'update'])->name('notfoundlocation');



    Route::get('/crimeLocations', [App\Http\Controllers\LocationController::class, 'index'])->name('crimelocations');
    Route::post('crimeLocations/{id}', [App\Http\Controllers\LocationController::class, 'switchStatus'])->name('switch-locationstatus');


});


Route::get('logout', 'LoginController@logout')->name('logout');
