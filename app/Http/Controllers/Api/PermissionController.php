<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Permission;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class PermissionController extends Controller
{
    use ApiResponse;

    /**
     * List all permissions grouped by category
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index(Request $request)
    {
        $request->validate([
            'group' => 'nullable|string',
            'grouped' => 'nullable|boolean',
        ]);

        $query = Permission::query();

        // Filter by group if provided
        if ($request->filled('group')) {
            $query->where('group', $request->group);
        }

        $permissions = $query->orderBy('group')->orderBy('name')->get();

        // Return grouped by category if requested
        if ($request->boolean('grouped', true)) {
            $grouped = $permissions->groupBy('group')->map(function ($items, $group) {
                return [
                    'group' => $group ?? 'Other',
                    'permissions' => $items->map(function ($permission) {
                        return [
                            'id' => $permission->id,
                            'name' => $permission->name,
                            'slug' => $permission->slug,
                            'description' => $permission->description,
                        ];
                    })->values(),
                ];
            })->values();

            return $this->successResponse($grouped);
        }

        // Return flat list
        $data = $permissions->map(function ($permission) {
            return [
                'id' => $permission->id,
                'name' => $permission->name,
                'slug' => $permission->slug,
                'description' => $permission->description,
                'group' => $permission->group,
                'created_at' => $permission->created_at,
            ];
        });

        return $this->successResponse($data);
    }

    /**
     * Create a new permission
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:permissions,slug',
            'description' => 'nullable|string',
            'group' => 'nullable|string|max:255',
        ]);

        $permission = Permission::create([
            'name' => $request->name,
            'slug' => $request->slug,
            'description' => $request->description,
            'group' => $request->group,
        ]);

        return $this->successResponse([
            'id' => $permission->id,
            'name' => $permission->name,
            'slug' => $permission->slug,
            'description' => $permission->description,
            'group' => $permission->group,
            'created_at' => $permission->created_at,
        ], 'Permission created successfully', 201);
    }

    /**
     * Update an existing permission
     *
     * @param Request $request
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request, $id)
    {
        $permission = Permission::find($id);

        if (!$permission) {
            return $this->notFoundResponse('Permission not found');
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'slug' => [
                'required',
                'string',
                'max:255',
                Rule::unique('permissions', 'slug')->ignore($permission->id),
            ],
            'description' => 'nullable|string',
            'group' => 'nullable|string|max:255',
        ]);

        $permission->update([
            'name' => $request->name,
            'slug' => $request->slug,
            'description' => $request->description,
            'group' => $request->group,
        ]);

        return $this->successResponse([
            'id' => $permission->id,
            'name' => $permission->name,
            'slug' => $permission->slug,
            'description' => $permission->description,
            'group' => $permission->group,
            'updated_at' => $permission->updated_at,
        ], 'Permission updated successfully');
    }

    /**
     * Delete a permission
     *
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy($id)
    {
        $permission = Permission::find($id);

        if (!$permission) {
            return $this->notFoundResponse('Permission not found');
        }

        // Check if permission is assigned to any roles
        if ($permission->roles()->count() > 0) {
            return $this->errorResponse(
                'Cannot delete permission that is assigned to roles. Please remove permission from roles first.',
                409
            );
        }

        $permission->delete();

        return $this->successResponse(null, 'Permission deleted successfully');
    }

    /**
     * Get all permission groups
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function groups()
    {
        $groups = Permission::select('group')
            ->distinct()
            ->whereNotNull('group')
            ->orderBy('group')
            ->pluck('group');

        return $this->successResponse($groups);
    }
}
