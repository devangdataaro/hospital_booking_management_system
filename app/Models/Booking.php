<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Booking extends Model
{
    use HasFactory;

    protected $fillable = [
        'treatment_id',
        'doctor_id',
        'treatment_title',
        'snapshot_duration',
        'snapshot_price',
        'start_datetime',
        'end_datetime',
        'patient_name',
        'patient_email',
        'patient_phone',
        'is_cancelled',
    ];

    protected $casts = [
        'snapshot_duration' => 'integer',
        'snapshot_price' => 'decimal:2',
        'start_datetime' => 'datetime',
        'end_datetime' => 'datetime',
        'is_cancelled' => 'boolean',
    ];

    /**
     * The treatment for this booking
     */
    public function treatment(): BelongsTo
    {
        return $this->belongsTo(Treatment::class)->withTrashed();
    }

    /**
     * The doctor for this booking
     */
    public function doctor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'doctor_id');
    }
}
