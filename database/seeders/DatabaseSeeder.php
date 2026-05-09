<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\Treatment;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Seed roles and permissions first
        $this->call(RolePermissionSeeder::class);

        // Get roles for assignment
        $adminRole = Role::where('slug', 'admin')->first();
        $doctorRole = Role::where('slug', 'doctor')->first();

        // Create 1 Admin
        $admin = User::factory()->create([
            'name' => 'Admin User',
            'email' => 'admin@hospital.com',
            'password' => 'password',
        ]);

        // Assign admin role
        $admin->assignRole($adminRole);

        // Create 10 Doctors with known credentials for testing
        $doctors = collect();

        for ($i = 1; $i <= 10; $i++) {
            $doctor = User::factory()->create([
                'name' => "Dr. Doctor {$i}",
                'email' => "doctor{$i}@hospital.com",
                'password' => 'password',
            ]);

            // Assign doctor role
            $doctor->assignRole($doctorRole);

            $doctors->push($doctor);
        }

        // Create 10 Treatments with specific data
        $treatmentData = [
            ['title' => 'Dental Cleaning', 'duration' => 30, 'price' => 100],
            ['title' => 'ENT Consultation', 'duration' => 20, 'price' => 80],
            ['title' => 'Orthopedic Consultation', 'duration' => 30, 'price' => 120],
            ['title' => 'General Check-up', 'duration' => 15, 'price' => 50],
            ['title' => 'X-Ray', 'duration' => 10, 'price' => 60],
            ['title' => 'Blood Test', 'duration' => 10, 'price' => 40],
            ['title' => 'Physical Therapy', 'duration' => 45, 'price' => 90],
            ['title' => 'Cardiology Consultation', 'duration' => 40, 'price' => 150],
            ['title' => 'Dermatology Consultation', 'duration' => 25, 'price' => 85],
            ['title' => 'Eye Examination', 'duration' => 30, 'price' => 70],
        ];

        foreach ($treatmentData as $data) {
            $treatment = Treatment::create($data);

            // Randomly connect 2-5 doctors to each treatment
            $randomDoctors = $doctors->random(rand(2, 5));
            $treatment->doctors()->attach($randomDoctors->pluck('id'));
        }

        $this->command->info('Seeding completed!');
        $this->command->info('Admin Email: admin@hospital.com');
        $this->command->info('Doctor Emails: doctor1@hospital.com to doctor10@hospital.com');
        $this->command->info('Default Password: password');
    }
}
