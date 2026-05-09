<?php

namespace Database\Factories;

use App\Models\Booking;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Booking>
 */
class BookingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $startDatetime = fake()->dateTimeBetween('now', '+30 days');
        $duration = fake()->numberBetween(10, 120); // 10 mins to 2 hours
        $endDatetime = (clone $startDatetime)->modify("+{$duration} minutes");

        return [
            'treatment_id' => \App\Models\Treatment::factory(),
            'doctor_id' => \App\Models\User::factory()->doctor(),
            'treatment_title' => fake()->randomElement(['Dental', 'ENT', 'Orthopedic', 'General Check-up']),
            'snapshot_duration' => $duration,
            'snapshot_price' => fake()->randomFloat(2, 40, 200),
            'start_datetime' => $startDatetime,
            'end_datetime' => $endDatetime,
            'patient_name' => fake()->name(),
            'patient_email' => fake()->safeEmail(),
            'patient_phone' => fake()->phoneNumber(),
            'is_cancelled' => false,
        ];
    }
}
