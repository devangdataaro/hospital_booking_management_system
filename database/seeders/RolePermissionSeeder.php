<?php

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Seeder;

class RolePermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Define permissions grouped by functionality
        $permissions = [
            // User Management
            ['name' => 'Create User', 'slug' => 'user.create', 'group' => 'User Management', 'description' => 'Create new users/doctors'],
            ['name' => 'Edit User', 'slug' => 'user.edit', 'group' => 'User Management', 'description' => 'Edit user profile'],
            ['name' => 'View Users', 'slug' => 'user.view', 'group' => 'User Management', 'description' => 'View list of users/doctors'],
            ['name' => 'Delete User', 'slug' => 'user.delete', 'group' => 'User Management', 'description' => 'Delete users'],

            // Treatment Management
            ['name' => 'Create Treatment', 'slug' => 'treatment.create', 'group' => 'Treatment Management', 'description' => 'Create new treatments'],
            ['name' => 'Edit Treatment', 'slug' => 'treatment.edit', 'group' => 'Treatment Management', 'description' => 'Edit existing treatments'],
            ['name' => 'Delete Treatment', 'slug' => 'treatment.delete', 'group' => 'Treatment Management', 'description' => 'Delete treatments'],
            ['name' => 'View Treatments', 'slug' => 'treatment.view', 'group' => 'Treatment Management', 'description' => 'View list of treatments'],

            // Slot Management
            ['name' => 'Create Slot', 'slug' => 'slot.create', 'group' => 'Slot Management', 'description' => 'Create availability slots'],
            ['name' => 'Edit Slot', 'slug' => 'slot.edit', 'group' => 'Slot Management', 'description' => 'Edit availability slots'],
            ['name' => 'Delete Slot', 'slug' => 'slot.delete', 'group' => 'Slot Management', 'description' => 'Delete availability slots'],
            ['name' => 'View Slots', 'slug' => 'slot.view', 'group' => 'Slot Management', 'description' => 'View own availability slots'],
            ['name' => 'View All Slots', 'slug' => 'slot.view-all', 'group' => 'Slot Management', 'description' => 'View all doctors slots'],

            // Booking Management
            ['name' => 'Create Booking', 'slug' => 'booking.create', 'group' => 'Booking Management', 'description' => 'Create new bookings'],
            ['name' => 'Cancel Booking', 'slug' => 'booking.cancel', 'group' => 'Booking Management', 'description' => 'Cancel bookings'],
            ['name' => 'View Bookings', 'slug' => 'booking.view', 'group' => 'Booking Management', 'description' => 'View own bookings'],
            ['name' => 'View All Bookings', 'slug' => 'booking.view-all', 'group' => 'Booking Management', 'description' => 'View all bookings'],
            ['name' => 'Edit Booking', 'slug' => 'booking.edit', 'group' => 'Booking Management', 'description' => 'Edit bookings'],

            // Role & Permission Management (Super Admin only)
            ['name' => 'Manage Roles', 'slug' => 'role.manage', 'group' => 'Role Management', 'description' => 'Create and manage roles'],
            ['name' => 'Manage Permissions', 'slug' => 'permission.manage', 'group' => 'Permission Management', 'description' => 'Assign permissions to roles'],
            ['name' => 'Assign Roles', 'slug' => 'role.assign', 'group' => 'Role Management', 'description' => 'Assign roles to users'],
        ];

        // Create permissions
        foreach ($permissions as $permission) {
            Permission::firstOrCreate(
                ['slug' => $permission['slug']],
                $permission
            );
        }

        // Define roles with their permissions
        $roles = [
            'admin' => [
                'name' => 'Administrator',
                'slug' => 'admin',
                'description' => 'Full system access with all permissions',
                'permissions' => [
                    'user.create', 'user.edit', 'user.view', 'user.delete',
                    'treatment.create', 'treatment.edit', 'treatment.delete', 'treatment.view',
                    'slot.view-all',
                    'booking.view-all', 'booking.cancel', 'booking.edit',
                    'role.manage', 'permission.manage', 'role.assign',
                ]
            ],
            'doctor' => [
                'name' => 'Doctor',
                'slug' => 'doctor',
                'description' => 'Medical professional with slot and booking management',
                'permissions' => [
                    'user.edit', // Can edit own profile
                    'treatment.view',
                    'slot.create', 'slot.edit', 'slot.delete', 'slot.view',
                    'booking.view', 'booking.cancel',
                ]
            ],
            'patient' => [
                'name' => 'Patient',
                'slug' => 'patient',
                'description' => 'Patient with booking capabilities',
                'permissions' => [
                    'user.edit', // Can edit own profile
                    'user.view', // Can view doctors
                    'treatment.view',
                    'booking.create', 'booking.view', // Can book and view own bookings
                ]
            ],
            'receptionist' => [
                'name' => 'Receptionist',
                'slug' => 'receptionist',
                'description' => 'Front desk staff managing bookings',
                'permissions' => [
                    'user.view',
                    'treatment.view',
                    'booking.create', 'booking.view-all', 'booking.edit', 'booking.cancel',
                ]
            ],
        ];

        // Create roles and assign permissions
        foreach ($roles as $roleData) {
            $role = Role::firstOrCreate(
                ['slug' => $roleData['slug']],
                [
                    'name' => $roleData['name'],
                    'description' => $roleData['description'],
                ]
            );

            // Sync permissions for this role
            $permissionIds = Permission::whereIn('slug', $roleData['permissions'])->pluck('id')->toArray();
            $role->permissions()->sync($permissionIds);
        }

        $this->command->info('Roles and Permissions seeded successfully!');
    }
}
