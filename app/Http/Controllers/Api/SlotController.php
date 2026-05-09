<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Slot;
use App\Services\AvailableSlotCache;
use App\Traits\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class SlotController extends Controller
{
    use ApiResponse;

    /**
     * SLOT-CREATE-EDIT-DELETE - Single API to manage slots for doctors
     * Clears existing slots for date range and creates new ones
     *
     * @return JsonResponse
     */
    public function manage(Request $request)
    {
        // Check if user is doctor
        if (! $request->user()->isDoctor()) {
            return $this->forbiddenResponse('Unauthorized. Only doctors can manage slots.');
        }

        $validator = Validator::make($request->all(), [
            'start_date' => 'required|date|date_format:Y-m-d',
            'end_date' => 'required|date|date_format:Y-m-d|after_or_equal:start_date',
            'slots' => 'nullable|array',
            'slots.*.start_time' => 'required_with:slots|date_format:H:i',
            'slots.*.end_time' => 'required_with:slots|date_format:H:i',
        ]);

        $validator->after(function ($v) use ($request) {
            foreach ($request->input('slots', []) as $i => $slot) {
                $start = $slot['start_time'] ?? null;
                $end = $slot['end_time'] ?? null;
                if ($start === null || $end === null) {
                    continue;
                }
                if (strtotime($end) <= strtotime($start)) {
                    $v->errors()->add("slots.{$i}.end_time", 'The end time must be after the start time.');
                }
            }
        });

        $validator->validate();

        $doctor = $request->user();
        $startDate = Carbon::parse($request->start_date);
        $endDate = Carbon::parse($request->end_date);

        DB::beginTransaction();
        try {
            // Delete existing slots for the date range
            Slot::where('doctor_id', $doctor->id)
                ->whereBetween('date', [$startDate, $endDate])
                ->delete();

            // If slots array is provided and not empty, create new slots
            if ($request->filled('slots') && count($request->slots) > 0) {
                $slotsToCreate = [];
                $currentDate = $startDate->copy();

                // For each date in the range
                while ($currentDate <= $endDate) {
                    // For each slot time provided
                    foreach ($request->slots as $slot) {
                        $slotsToCreate[] = [
                            'doctor_id' => $doctor->id,
                            'date' => $currentDate->format('Y-m-d'),
                            'start_time' => $slot['start_time'],
                            'end_time' => $slot['end_time'],
                            'created_at' => now(),
                            'updated_at' => now(),
                        ];
                    }
                    $currentDate->addDay();
                }

                // Bulk insert slots
                Slot::insert($slotsToCreate);
            }

            DB::commit();

            AvailableSlotCache::bumpForDoctor($doctor);

            // Get the created/remaining slots
            $slots = Slot::where('doctor_id', $doctor->id)
                ->whereBetween('date', [$startDate, $endDate])
                ->orderBy('date')
                ->orderBy('start_time')
                ->get();

            return $this->successResponse([
                'date_range' => [
                    'start_date' => $startDate->format('Y-m-d'),
                    'end_date' => $endDate->format('Y-m-d'),
                ],
                'slots_count' => $slots->count(),
                'slots' => $slots,
            ], 'Slots updated successfully');
        } catch (\Exception $e) {
            DB::rollBack();

            return $this->errorResponse('Failed to update slots: '.$e->getMessage(), 500);
        }
    }

    /**
     * SLOT-LIST - List slots for logged-in doctor
     *
     * @return JsonResponse
     */
    public function list(Request $request)
    {
        // Check if user is doctor
        if (! $request->user()->isDoctor()) {
            return $this->forbiddenResponse('Unauthorized. Only doctors can view their slots.');
        }

        $request->validate([
            'start_date' => 'nullable|date|date_format:Y-m-d',
            'end_date' => 'nullable|date|date_format:Y-m-d|after_or_equal:start_date',
            'sort_by' => ['nullable', Rule::in(['date', 'start_time', 'end_time'])],
            'sort_order' => ['nullable', Rule::in(['asc', 'desc'])],
            'per_page' => 'nullable|integer|min:1|max:100',
        ]);

        $doctor = $request->user();
        $query = Slot::where('doctor_id', $doctor->id);

        // Date range filter
        if ($request->filled('start_date')) {
            $query->where('date', '>=', $request->start_date);
        }
        if ($request->filled('end_date')) {
            $query->where('date', '<=', $request->end_date);
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'date');
        $sortOrder = $request->get('sort_order', 'asc');
        $query->orderBy($sortBy, $sortOrder);

        // Add secondary sorting to maintain consistency
        if ($sortBy !== 'date') {
            $query->orderBy('date', 'asc');
        }
        if ($sortBy !== 'start_time') {
            $query->orderBy('start_time', 'asc');
        }

        // Pagination
        $perPage = $request->get('per_page', 15);
        $slots = $query->paginate($perPage);

        return $this->successResponse([
            'data' => $slots->items(),
            'pagination' => [
                'current_page' => $slots->currentPage(),
                'per_page' => $slots->perPage(),
                'total' => $slots->total(),
                'last_page' => $slots->lastPage(),
                'from' => $slots->firstItem(),
                'to' => $slots->lastItem(),
            ],
        ]);
    }
}
