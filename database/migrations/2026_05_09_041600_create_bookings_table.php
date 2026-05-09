<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('treatment_id')->nullable()->constrained('treatments')->nullOnDelete();
            $table->foreignId('doctor_id')->constrained('users')->onDelete('cascade');

            // Snapshot fields to preserve treatment data at booking time
            $table->string('treatment_title');
            $table->integer('snapshot_duration'); // in minutes
            $table->decimal('snapshot_price', 10, 2); // in USD

            // Booking datetime
            $table->dateTime('start_datetime');
            $table->dateTime('end_datetime');

            // Patient information
            $table->string('patient_name');
            $table->string('patient_email');
            $table->string('patient_phone');

            // Booking status
            $table->boolean('is_cancelled')->default(false);
            $table->timestamps();

            // Indexes for performance
            $table->index('treatment_id');
            $table->index('doctor_id');
            $table->index('start_datetime');
            $table->index('end_datetime');
            $table->index('is_cancelled');
            $table->index(['doctor_id', 'start_datetime', 'end_datetime']);
            $table->index(['patient_email', 'patient_phone']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
