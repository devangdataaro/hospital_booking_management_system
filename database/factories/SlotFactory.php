<?php

namespace Database\Factories;

use App\Models\Slot;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Slot>
 */
class SlotFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $startHour = fake()->numberBetween(7, 20);
        $startMinute = fake()->randomElement([0, 30]);
        $startTime = sprintf('%02d:%02d:00', $startHour, $startMinute);

        // End time is 1-3 hours after start
        $durationHours = fake()->numberBetween(1, 3);
        $endDateTime = \Carbon\Carbon::parse($startTime)->addHours($durationHours);

        return [
            'doctor_id' => \App\Models\User::factory(),
            'date' => fake()->dateTimeBetween('now', '+30 days')->format('Y-m-d'),
            'start_time' => $startTime,
            'end_time' => $endDateTime->format('H:i:s'),
        ];
    }
}
