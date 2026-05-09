<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    use ApiResponse;
    /**
     * USER-CREATE - Admin only API to create new doctors
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function create(Request $request)
    {
        // Check if user is admin
        if (!$request->user()->isAdmin()) {
            return $this->forbiddenResponse('Unauthorized. Only admins can create users.');
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8',
        ]);

        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
            ]);

            $request = $request->merge(['role' => 'Doctor']);


            // Assign role to the new user
            $user->assignRole($request->role);

            return $this->successResponse([
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'roles' => $user->roles->pluck('slug'),
                'created_at' => $user->created_at,
            ], 'User created successfully', 201);
        } catch (\Exception $e) {
            return $this->errorResponse('User creation failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * USER-EDIT - Edit logged-in user's name only
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function edit(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $user = $request->user();
        $user->name = $request->name;
        $user->save();

        return $this->successResponse([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'roles' => $user->roles->pluck('slug'),
        ], 'User updated successfully');
    }

    /**
     * USER-LIST - Public API to list doctors
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function list(Request $request)
    {
        $request->validate([
            'search' => 'nullable|string',
            'treatment_id' => 'nullable|exists:treatments,id',
            'role' => 'nullable|string|exists:roles,slug',
            'sort_by' => ['nullable', Rule::in(['name', 'email'])],
            'sort_order' => ['nullable', Rule::in(['asc', 'desc'])],
            'per_page' => 'nullable|integer|min:1|max:100',
        ]);

        $query = User::query()->withCount('bookings');

        // Filter by role (default to doctor for backward compatibility)
        if ($request->filled('role')) {
            $query->whereHas('roles', function ($q) use ($request) {
                $q->where('slug', $request->role);
            });
        } else {
            // Default: show only doctors
            $query->whereHas('roles', function ($q) {
                $q->where('slug', 'doctor');
            });
        }

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        // Treatment filter
        if ($request->filled('treatment_id')) {
            $query->whereHas('treatments', function ($q) use ($request) {
                $q->where('treatments.id', $request->treatment_id);
            });
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'name');
        $sortOrder = $request->get('sort_order', 'asc');
        $query->orderBy($sortBy, $sortOrder);

        // Pagination
        $perPage = $request->get('per_page', 15);
        $users = $query->paginate($perPage);

        return $this->successResponse([
            'data' => $users->items(),
            'pagination' => [
                'current_page' => $users->currentPage(),
                'per_page' => $users->perPage(),
                'total' => $users->total(),
                'last_page' => $users->lastPage(),
                'from' => $users->firstItem(),
                'to' => $users->lastItem(),
            ],
        ]);
    }
}

