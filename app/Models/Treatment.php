<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Treatment extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'duration',
        'price',
    ];

    protected $casts = [
        'duration' => 'integer',
        'price' => 'decimal:2',
        'deleted_at' => 'datetime',
    ];

    /**
     * Doctors who can perform this treatment
     */
    public function doctors(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'doctor_treatment', 'treatment_id', 'doctor_id')
            ->whereHas('roles', function ($query) {
                $query->where('slug', 'doctor');
            })
            ->withTimestamps();
    }

    /**
     * Bookings for this treatment
     */
    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }
}
