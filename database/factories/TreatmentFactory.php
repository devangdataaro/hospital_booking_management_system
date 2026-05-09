<?php

namespace Database\Factories;

use App\Models\Treatment;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Treatment>
 */
class TreatmentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $treatmentTypes = [
            'Dental Cleaning' => ['duration' => 30, 'price' => 100],
            'ENT Consultation' => ['duration' => 20, 'price' => 80],
            'Orthopedic Consultation' => ['duration' => 30, 'price' => 120],
            'General Check-up' => ['duration' => 15, 'price' => 50],
            'X-Ray' => ['duration' => 10, 'price' => 60],
            'Blood Test' => ['duration' => 10, 'price' => 40],
            'Physical Therapy' => ['duration' => 45, 'price' => 90],
            'Cardiology Consultation' => ['duration' => 40, 'price' => 150],
            'Dermatology Consultation' => ['duration' => 25, 'price' => 85],
            'Eye Examination' => ['duration' => 30, 'price' => 70],
        ];

        $treatment = fake()->randomElement($treatmentTypes);

        return [
            'title' => fake()->unique()->randomElement(array_keys($treatmentTypes)),
            'duration' => $treatment['duration'],
            'price' => $treatment['price'],
        ];
    }
}
