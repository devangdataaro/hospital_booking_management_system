<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Treatment;
use App\Models\User;
use App\Services\AvailableSlotCache;
use App\Traits\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Validation\Rule;

class TreatmentController extends Controller
{
    use ApiResponse;

    /**
     * TREATMENT-CREATE - Admin only API to create treatments
     *
     * @return JsonResponse
     */
    public function create(Request $request)
    {
        // Check if user is admin
        if (! $request->user()->isAdmin()) {
            return $this->forbiddenResponse('Unauthorized. Only admins can create treatments.');
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'duration' => 'required|integer|min:10|max:120',
            'price' => 'required|numeric|min:0',
            'user_ids' => 'present|array',
            'user_ids.*' => 'integer|exists:users,id',
        ]);

        // Verify all user_ids are doctors
        if ($request->filled('user_ids')) {
            $users = User::whereIn('id', $request->user_ids)->get();
            foreach ($users as $user) {
                if (!$user->hasRole('doctor')) {
                    return $this->errorResponse('All assigned users must be doctors.', 422);
                }
            }
        }

        $treatment = Treatment::create([
            'title' => $request->title,
            'duration' => $request->duration,
            'price' => $request->price,
        ]);

        $treatment->doctors()->sync($request->input('user_ids'));

        AvailableSlotCache::bumpTreatment($treatment->id);

        $treatment->load('doctors');

        return $this->successResponse([
            'id' => $treatment->id,
            'title' => $treatment->title,
            'duration' => $treatment->duration,
            'price' => $treatment->price,
            'doctors' => $treatment->doctors,
            'created_at' => $treatment->created_at,
        ], 'Treatment created successfully', 201);
    }

    /**
     * TREATMENT-EDIT - Admin only API to edit treatments
     *
     * @param  int  $id
     * @return JsonResponse
     */
    public function edit(Request $request, $id)
    {
        // Check if user is admin
        if (! $request->user()->isAdmin()) {
            return $this->forbiddenResponse('Unauthorized. Only admins can edit treatments.');
        }

        $treatment = Treatment::find($id);

        if (! $treatment) {
            return $this->notFoundResponse('Treatment not found');
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'duration' => 'required|integer|min:10|max:120',
            'price' => 'required|numeric|min:0',
            'user_ids' => 'present|array',
            'user_ids.*' => 'integer|exists:users,id',
        ]);

        // Verify all user_ids are doctors
        if ($request->filled('user_ids')) {
            $users = User::whereIn('id', $request->user_ids)->get();
            foreach ($users as $user) {
                if (!$user->hasRole('doctor')) {
                    return $this->errorResponse('All assigned users must be doctors.', 422);
                }
            }
        }

        $treatment->update([
            'title' => $request->title,
            'duration' => $request->duration,
            'price' => $request->price,
        ]);

        $treatment->doctors()->sync($request->input('user_ids'));

        AvailableSlotCache::bumpTreatment((int) $treatment->id);

        $treatment->load('doctors');

        return $this->successResponse([
            'id' => $treatment->id,
            'title' => $treatment->title,
            'duration' => $treatment->duration,
            'price' => $treatment->price,
            'doctors' => $treatment->doctors,
            'updated_at' => $treatment->updated_at,
        ], 'Treatment updated successfully');
    }

    /**
     * TREATMENT-DELETE - Admin only API to delete treatments
     *
     * @param  int  $id
     * @return JsonResponse
     */
    public function delete(Request $request, $id)
    {
        // Check if user is admin
        if (! $request->user()->isAdmin()) {
            return $this->forbiddenResponse('Unauthorized. Only admins can delete treatments.');
        }

        $treatment = Treatment::find($id);

        if (! $treatment) {
            return $this->notFoundResponse('Treatment not found');
        }

        // Soft delete - won't delete existing bookings
        AvailableSlotCache::bumpTreatment((int) $treatment->id);
        $treatment->delete();

        return $this->successResponse(null, 'Treatment deleted successfully');
    }

    /**
     * TREATMENT-LIST - Public API to list treatments
     *
     * @return JsonResponse
     */
    public function list(Request $request)
    {
        $request->validate([
            'search' => 'nullable|string',
            'sort_by' => ['nullable', Rule::in(['duration', 'price'])],
            'sort_order' => ['nullable', Rule::in(['asc', 'desc'])],
            'per_page' => 'nullable|integer|min:1|max:100',
            'currency' => 'nullable|string|size:3|regex:/^[A-Za-z]{3}$/',
        ]);

        $query = Treatment::query();

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where('title', 'like', "%{$search}%");
        }

        // Sorting
        if ($request->filled('sort_by')) {
            $sortBy = $request->sort_by;
            $sortOrder = $request->get('sort_order', 'asc');
            $query->orderBy($sortBy, $sortOrder);
        } else {
            $query->orderBy('title', 'asc');
        }

        // Pagination
        $perPage = $request->get('per_page', 15);
        $treatments = $query->paginate($perPage);

        // Currency conversion (Extra Points)
        $conversionRate = 1;
        $currency = strtoupper($request->input('currency', 'USD'));

        if ($currency !== 'USD') {
            $conversionRate = $this->getCurrencyConversionRate($currency);
        }

        // Transform data
        $data = $treatments->map(function ($treatment) use ($conversionRate, $currency) {
            return [
                'id' => $treatment->id,
                'title' => $treatment->title,
                'duration' => $treatment->duration,
                'price' => round($treatment->price * $conversionRate, 2),
                'currency' => $currency,
                'created_at' => $treatment->created_at,
            ];
        });

        return $this->successResponse([
            'data' => $data,
            'pagination' => [
                'current_page' => $treatments->currentPage(),
                'per_page' => $treatments->perPage(),
                'total' => $treatments->total(),
                'last_page' => $treatments->lastPage(),
                'from' => $treatments->firstItem(),
                'to' => $treatments->lastItem(),
            ],
        ]);
    }

    /**
     * Get currency conversion rate from USD
     * Extra Points - Currency conversion using exchangerate-api.com
     *
     * @param  string  $currency
     * @return float
     */
    private function getCurrencyConversionRate($currency)
    {
        try {
            // Get API key from env (you need to register at exchangerate-api.com)
            $apiKey = env('EXCHANGE_RATE_API_KEY', 'demo_key');

            // Try to get from cache first (cache for 1 hour)
            $cacheKey = "exchange_rate_usd_{$currency}";

            return cache()->remember($cacheKey, 3600, function () use ($apiKey, $currency) {
                $response = Http::get("https://v6.exchangerate-api.com/v6/{$apiKey}/latest/USD");

                if ($response->successful()) {
                    $data = $response->json();
                    if (isset($data['conversion_rates'][$currency])) {
                        return (float) $data['conversion_rates'][$currency];
                    }
                }

                return 1; // Return 1 if API fails (no conversion)
            });
        } catch (\Exception $e) {
            return 1; // Return 1 if conversion fails
        }
    }
}
