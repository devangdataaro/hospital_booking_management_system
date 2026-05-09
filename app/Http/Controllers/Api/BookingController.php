<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Slot;
use App\Models\Treatment;
use App\Models\User;
use App\Services\AvailableSlotCache;
use App\Traits\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class BookingController extends Controller
{
    use ApiResponse;

    /**
     * BOOKING-CREATE - Public API to create bookings
     *
     * @return JsonResponse
     */
    public function create(Request $request)
    {
        $request->validate([
            'treatment_id' => 'required|exists:treatments,id',
            'start_date_time' => 'required|date_format:Y-m-d H:i',
            'doctor_id' => [
                'nullable',
                'integer',
                'exists:users,id',
            ],
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone_number' => 'required|string|max:20',
        ]);

        // Verify doctor_id belongs to a doctor if provided
        if ($request->filled('doctor_id')) {
            $doctor = User::find($request->doctor_id);
            if (!$doctor || !$doctor->hasRole('doctor')) {
                return $this->validationErrorResponse(
                    ['doctor_id' => ['The selected doctor must be a valid doctor user.']],
                    'The selected doctor id is invalid.'
                );
            }
        }

        // Treatment existence already validated, safe to use find()
        $treatment = Treatment::find($request->treatment_id);

        // Extra safety check (shouldn't happen due to validation)
        if (!$treatment) {
            return $this->errorResponse('Treatment not found or has been deleted', 404);
        }

        $startDatetime = Carbon::parse($request->start_date_time);

        if ($request->filled('doctor_id')) {
            $doctorId = (int) $request->doctor_id;
            if (! $treatment->doctors()->where('users.id', $doctorId)->exists()) {
                return $this->errorResponse('The selected doctor does not offer this treatment.', 422);
            }
        }
        $endDatetime = $startDatetime->copy()->addMinutes($treatment->duration);

        DB::beginTransaction();
        try {
            // Find available doctor
            $doctorId = $request->doctor_id;

            if (! $doctorId) {
                // If no doctor specified, find any available doctor for this treatment
                $doctorId = $this->findAvailableDoctor($treatment, $startDatetime, $endDatetime);

                if (! $doctorId) {
                    return $this->errorResponse('No doctor available for the selected time slot.', 404);
                }
            } else {
                // Verify if specified doctor is available
                if (! $this->isDoctorAvailable($doctorId, $treatment, $startDatetime, $endDatetime)) {
                    return $this->errorResponse('The selected doctor is not available for this time slot.', 409);
                }
            }

            // Create the booking with snapshot data
            $booking = Booking::create([
                'treatment_id' => $treatment->id,
                'doctor_id' => $doctorId,
                'treatment_title' => $treatment->title,
                'snapshot_duration' => $treatment->duration,
                'snapshot_price' => $treatment->price,
                'start_datetime' => $startDatetime,
                'end_datetime' => $endDatetime,
                'patient_name' => $request->name,
                'patient_email' => $request->email,
                'patient_phone' => $request->phone_number,
                'is_cancelled' => false,
            ]);

            DB::commit();

            AvailableSlotCache::bumpTreatment($treatment->id);

            $booking->load('doctor', 'treatment');

            return $this->successResponse([
                'id' => $booking->id,
                'treatment' => [
                    'id' => $booking->treatment_id,
                    'title' => $booking->treatment_title,
                    'duration' => $booking->snapshot_duration,
                    'price' => $booking->snapshot_price,
                ],
                'doctor' => [
                    'id' => $booking->doctor->id,
                    'name' => $booking->doctor->name,
                    'email' => $booking->doctor->email,
                ],
                'start_datetime' => $booking->start_datetime,
                'end_datetime' => $booking->end_datetime,
                'patient' => [
                    'name' => $booking->patient_name,
                    'email' => $booking->patient_email,
                    'phone' => $booking->patient_phone,
                ],
                'created_at' => $booking->created_at,
            ], 'Booking created successfully', 201);
        } catch (\Exception $e) {
            DB::rollBack();

            return $this->errorResponse('Failed to create booking: '.$e->getMessage(), 500);
        }
    }

    /**
     * BOOKING-LIST - List bookings for Admin and Doctor
     *
     * @return JsonResponse
     */
    public function list(Request $request)
    {
        $user = $request->user();

        // Check if user is admin or doctor
        if (! $user->isAdmin() && ! $user->isDoctor()) {
            return $this->forbiddenResponse('Unauthorized. Only admins and doctors can view bookings.');
        }

        $request->validate([
            'search' => 'nullable|string',
            'user_id' => 'nullable|exists:users,id',
            'start_date' => 'nullable|date|date_format:Y-m-d',
            'end_date' => 'nullable|date|date_format:Y-m-d|after_or_equal:start_date',
            'treatment_id' => 'nullable|exists:treatments,id',
            'is_cancelled' => 'nullable|boolean',
            'sort_by' => ['nullable', Rule::in(['start_datetime', 'end_datetime', 'patient_name', 'patient_email', 'patient_phone'])],
            'sort_order' => ['nullable', Rule::in(['asc', 'desc'])],
            'per_page' => 'nullable|integer|min:1|max:100',
        ]);

        $query = Booking::with(['doctor', 'treatment']);

        // If doctor, only show their own bookings
        if ($user->isDoctor()) {
            $query->where('doctor_id', $user->id);
        } elseif ($request->filled('user_id')) {
            // Admin can filter by user_id
            $query->where('doctor_id', $request->user_id);
        }

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('patient_name', 'like', "%{$search}%")
                    ->orWhere('patient_email', 'like', "%{$search}%")
                    ->orWhere('patient_phone', 'like', "%{$search}%");
            });
        }

        // Date range filter
        if ($request->filled('start_date')) {
            $query->whereDate('start_datetime', '>=', $request->start_date);
        }
        if ($request->filled('end_date')) {
            $query->whereDate('start_datetime', '<=', $request->end_date);
        }

        // Treatment filter
        if ($request->filled('treatment_id')) {
            $query->where('treatment_id', $request->treatment_id);
        }

        // Cancelled filter
        if ($request->has('is_cancelled')) {
            $query->where('is_cancelled', $request->is_cancelled);
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'start_datetime');
        $sortOrder = $request->get('sort_order', 'asc');
        $query->orderBy($sortBy, $sortOrder);

        // Pagination
        $perPage = $request->get('per_page', 15);
        $bookings = $query->paginate($perPage);

        // Transform data
        $data = $bookings->map(function ($booking) {
            return [
                'id' => $booking->id,
                'treatment' => [
                    'id' => $booking->treatment_id,
                    'title' => $booking->treatment_title,
                    'duration' => $booking->snapshot_duration,
                    'price' => $booking->snapshot_price,
                ],
                'doctor' => [
                    'id' => $booking->doctor->id,
                    'name' => $booking->doctor->name,
                    'email' => $booking->doctor->email,
                ],
                'start_datetime' => $booking->start_datetime,
                'end_datetime' => $booking->end_datetime,
                'patient' => [
                    'name' => $booking->patient_name,
                    'email' => $booking->patient_email,
                    'phone' => $booking->patient_phone,
                ],
                'is_cancelled' => $booking->is_cancelled,
                'created_at' => $booking->created_at,
            ];
        });

        return $this->successResponse([
            'data' => $data,
            'pagination' => [
                'current_page' => $bookings->currentPage(),
                'per_page' => $bookings->perPage(),
                'total' => $bookings->total(),
                'last_page' => $bookings->lastPage(),
                'from' => $bookings->firstItem(),
                'to' => $bookings->lastItem(),
            ],
        ]);
    }

    /**
     * BOOKING-CANCEL - Cancel booking (Doctor only)
     *
     * @param  int  $id
     * @return JsonResponse
     */
    public function cancel(Request $request, $id)
    {
        $user = $request->user();

        // Check if user is doctor
        if (! $user->isDoctor()) {
            return $this->forbiddenResponse('Unauthorized. Only doctors can cancel bookings.');
        }

        $booking = Booking::find($id);

        if (! $booking) {
            return $this->notFoundResponse('Booking not found');
        }

        // Doctor can only cancel their own bookings
        if ($booking->doctor_id !== $user->id) {
            return $this->forbiddenResponse('Unauthorized. You can only cancel your own bookings.');
        }

        if ($booking->is_cancelled) {
            return $this->errorResponse('Booking is already cancelled', 400);
        }

        $booking->is_cancelled = true;
        $booking->save();

        AvailableSlotCache::bumpTreatment((int) $booking->treatment_id);

        return $this->successResponse([
            'id' => $booking->id,
            'is_cancelled' => $booking->is_cancelled,
            'updated_at' => $booking->updated_at,
        ], 'Booking cancelled successfully');
    }

    /**
     * Find an available doctor for the treatment and time slot
     *
     * @param  Treatment  $treatment
     * @param  Carbon  $startDatetime
     * @param  Carbon  $endDatetime
     * @return int|null
     */
    private function findAvailableDoctor($treatment, $startDatetime, $endDatetime)
    {
        $doctorIds = $treatment->doctors()->pluck('users.id')->toArray();

        foreach ($doctorIds as $doctorId) {
            if ($this->isDoctorAvailable($doctorId, $treatment, $startDatetime, $endDatetime)) {
                return $doctorId;
            }
        }

        return null;
    }

    /**
     * Check if doctor is available for the time slot
     *
     * @param  int  $doctorId
     * @param  Treatment  $treatment
     * @param  Carbon  $startDatetime
     * @param  Carbon  $endDatetime
     * @return bool
     */
    private function isDoctorAvailable($doctorId, $treatment, $startDatetime, $endDatetime)
    {
        $date = $startDatetime->format('Y-m-d');
        $startTime = $startDatetime->format('H:i:s');
        $endTime = $endDatetime->format('H:i:s');

        // Check if doctor has a slot that covers this time
        $hasSlot = Slot::where('doctor_id', $doctorId)
            ->where('date', $date)
            ->where('start_time', '<=', $startTime)
            ->where('end_time', '>=', $endTime)
            ->exists();

        if (! $hasSlot) {
            return false;
        }

        // Check if doctor has any conflicting bookings
        $hasConflict = Booking::where('doctor_id', $doctorId)
            ->where('is_cancelled', false)
            ->where(function ($query) use ($startDatetime, $endDatetime) {
                $query->where(function ($q) use ($startDatetime, $endDatetime) {
                    $q->where('start_datetime', '<', $endDatetime)
                        ->where('end_datetime', '>', $startDatetime);
                });
            })
            ->exists();

        return ! $hasConflict;
    }
}
