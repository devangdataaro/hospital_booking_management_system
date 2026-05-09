<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Role;
use App\Models\Permission;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class RoleController extends Controller
{
    use ApiResponse;

    /**
     * List all roles with their permissions
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        $roles = Role::with('permissions')->get();

        $data = $roles->map(function ($role) {
            return [
                'id' => $role->id,
                'name' => $role->name,
                'slug' => $role->slug,
                'description' => $role->description,
                'permissions' => $role->permissions->map(function ($permission) {
                    return [
                        'id' => $permission->id,
                        'name' => $permission->name,
                        'slug' => $permission->slug,
                    ];
                }),
                'users_count' => $role->users()->count(),
                'created_at' => $role->created_at,
            ];
        });

        return $this->successResponse($data);
    }

    /**
     * Create a new role
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:roles,slug',
            'description' => 'nullable|string',
            'permission_ids' => 'nullable|array',
            'permission_ids.*' => 'exists:permissions,id',
        ]);

        $role = Role::create([
            'name' => $request->name,
            'slug' => $request->slug,
            'description' => $request->description,
        ]);

        if ($request->filled('permission_ids')) {
            $role->permissions()->sync($request->permission_ids);
        }

        $role->load('permissions');

        return $this->successResponse([
            'id' => $role->id,
            'name' => $role->name,
            'slug' => $role->slug,
            'description' => $role->description,
            'permissions' => $role->permissions,
            'created_at' => $role->created_at,
        ], 'Role created successfully', 201);
    }

    /**
     * Update an existing role
     *
     * @param Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        $role = Role::find($id);

        if (!$role) {
            return $this->notFoundResponse('Role not found');
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'slug' => [
                'required',
                'string',
                'max:255',
                Rule::unique('roles', 'slug')->ignore($role->id),
            ],
            'description' => 'nullable|string',
            'permission_ids' => 'nullable|array',
            'permission_ids.*' => 'exists:permissions,id',
        ]);

        $role->update([
            'name' => $request->name,
            'slug' => $request->slug,
            'description' => $request->description,
        ]);

        if ($request->has('permission_ids')) {
            $role->permissions()->sync($request->permission_ids ?? []);
        }

        $role->load('permissions');

        return $this->successResponse([
            'id' => $role->id,
            'name' => $role->name,
            'slug' => $role->slug,
            'description' => $role->description,
            'permissions' => $role->permissions,
            'updated_at' => $role->updated_at,
        ], 'Role updated successfully');
    }

    /**
     * Delete a role
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        $role = Role::find($id);

        if (!$role) {
            return $this->notFoundResponse('Role not found');
        }

        // Check if role is assigned to any users
        if ($role->users()->count() > 0) {
            return $this->errorResponse(
                'Cannot delete role that is assigned to users. Please remove users from this role first.',
                409
            );
        }

        $role->delete();

        return $this->successResponse(null, 'Role deleted successfully');
    }

    /**
     * Assign role to user
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function assignToUser(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'role_id' => 'required|exists:roles,id',
        ]);

        $user = \App\Models\User::findOrFail($request->user_id);
        $role = Role::findOrFail($request->role_id);

        $user->assignRole($role);

        return $this->successResponse([
            'user_id' => $user->id,
            'user_name' => $user->name,
            'role_id' => $role->id,
            'role_name' => $role->name,
        ], 'Role assigned to user successfully');
    }

    /**
     * Remove role from user
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function removeFromUser(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'role_id' => 'required|exists:roles,id',
        ]);

        $user = \App\Models\User::findOrFail($request->user_id);
        $role = Role::findOrFail($request->role_id);

        $user->removeRole($role);

        return $this->successResponse(null, 'Role removed from user successfully');
    }
}
