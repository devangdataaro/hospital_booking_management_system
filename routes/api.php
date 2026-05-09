<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AvailableSlotController;
use App\Http\Controllers\Api\BookingController;
use App\Http\Controllers\Api\PermissionController;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\SlotController;
use App\Http\Controllers\Api\TreatmentController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application.
| These routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group.
|
*/

// Public routes (no authentication required)

// 1. LOGIN API
Route::post('/login', [AuthController::class, 'login']);

// 4. USER-LIST - Public API (no auth required)
Route::get('/users', [UserController::class, 'list']);

// 8. TREATMENT-LIST - Public API (no auth required)
Route::get('/treatments', [TreatmentController::class, 'list']);

// 11. AVAILABLE-SLOT-LIST - Public API (no auth required)
Route::get('/available-slots', [AvailableSlotController::class, 'list']);

// 12. BOOKING-CREATE - Public API (no auth required for patients)
Route::post('/bookings', [BookingController::class, 'create']);

// Protected routes (require authentication)
Route::middleware('auth:api')->group(function () {

    // 2. USER-CREATE - Admin only (requires 'user.create' permission)
    Route::post('/users', [UserController::class, 'create'])
        ->middleware('permission:user.create');

    // 3. USER-EDIT - Authenticated users can edit their own profile (requires 'user.edit' permission)
    Route::put('/users/profile', [UserController::class, 'edit'])
        ->middleware('permission:user.edit');

    // 5. TREATMENT-CREATE - Admin only (requires 'treatment.create' permission)
    Route::post('/treatments', [TreatmentController::class, 'create'])
        ->middleware('permission:treatment.create');

    // 6. TREATMENT-EDIT - Admin only (requires 'treatment.edit' permission)
    Route::put('/treatments/{id}', [TreatmentController::class, 'edit'])
        ->middleware('permission:treatment.edit');

    // 7. TREATMENT-DELETE - Admin only (requires 'treatment.delete' permission)
    Route::delete('/treatments/{id}', [TreatmentController::class, 'delete'])
        ->middleware('permission:treatment.delete');

    // 9. SLOT-CREATE-EDIT-DELETE - Doctor only (requires 'slot.create' permission)
    Route::post('/slots', [SlotController::class, 'manage'])
        ->middleware('permission:slot.create');

    // 10. SLOT-LIST - Doctor only (their own slots, requires 'slot.view' permission)
    Route::get('/slots', [SlotController::class, 'list'])
        ->middleware('permission:slot.view');

    // 13. BOOKING-LIST - Admin and Doctor (requires 'booking.view' or 'booking.view-all' permission)
    Route::get('/bookings', [BookingController::class, 'list'])
        ->middleware('permission:booking.view');

    // 14. BOOKING-CANCEL - Doctor only (requires 'booking.cancel' permission)
    Route::put('/bookings/{id}/cancel', [BookingController::class, 'cancel'])
        ->middleware('permission:booking.cancel');

    // ===== ROLE & PERMISSION MANAGEMENT APIs (Admin only) =====

    // Role Management (requires 'role.manage' permission)
    Route::middleware('permission:role.manage')->group(function () {
        Route::get('/roles', [RoleController::class, 'index']);
        Route::post('/roles', [RoleController::class, 'store']);
        Route::put('/roles/{id}', [RoleController::class, 'update']);
        Route::delete('/roles/{id}', [RoleController::class, 'destroy']);
    });

    // Role Assignment (requires 'role.assign' permission)
    Route::middleware('permission:role.assign')->group(function () {
        Route::post('/roles/assign', [RoleController::class, 'assignToUser']);
        Route::post('/roles/remove', [RoleController::class, 'removeFromUser']);
    });

    // Permission Management (requires 'permission.manage' permission)
    Route::middleware('permission:permission.manage')->group(function () {
        Route::get('/permissions', [PermissionController::class, 'index']);
        Route::get('/permissions/groups', [PermissionController::class, 'groups']);
        Route::post('/permissions', [PermissionController::class, 'store']);
        Route::put('/permissions/{id}', [PermissionController::class, 'update']);
        Route::delete('/permissions/{id}', [PermissionController::class, 'destroy']);
    });
});
