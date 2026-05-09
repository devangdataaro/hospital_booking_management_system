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
use Illuminate\Support\Collection;

class AvailableSlotController extends Controller
{
    use ApiResponse;

    /**
     * AVAILABLE-SLOT-LIST - Public API to get available slots for treatment
     * This is the most complex API with caching for performance
     *
     * @return JsonResponse
     */
    public function list(Request $request)
    {
        $request->validate([
            'treatment_id' => 'required|exists:treatments,id',
            'start_date' => 'nullable|date|date_format:Y-m-d',
            'end_date' => 'nullable|date|date_format:Y-m-d|after_or_equal:start_date',
            'doctor_id' => [
                'nullable',
                'integer',
                'exists:users,id',
                function (string $attribute, mixed $value, \Closure $fail) use ($request) {
                    if ($value === null || $value === '') {
                        return;
                    }
                    $user = User::find((int) $value);
                    if (! $user || ! $user->isDoctor()) {
                        $fail('The selected doctor is invalid.');

                        return;
                    }
                    $treatment = Treatment::find($request->treatment_id);
                    if ($treatment && ! $treatment->doctors()->where('users.id', (int) $value)->exists()) {
                        $fail('This doctor does not offer the selected treatment.');
                    }
                },
            ],
        ]);

        // Treatment existence already validated, safe to use find()
        $treatment = Treatment::find($request->treatment_id);

        // Extra safety check (shouldn't happen due to validation)
        if (!$treatment) {
            return $this->errorResponse('Treatment not found or has been deleted', 404);
        }

        // Set default date range (today and tomorrow if not provided)
        $startDate = $request->filled('start_date')
            ? Carbon::parse($request->start_date)
            : Carbon::today();
        $endDate = $request->filled('end_date')
            ? Carbon::parse($request->end_date)
            : Carbon::today()->addDay();

        $doctorId = $request->filled('doctor_id') ? (int) $request->doctor_id : null;

        $availableSlots = AvailableSlotCache::remember(
            $treatment->id,
            $startDate->format('Ymd'),
            $endDate->format('Ymd'),
            $doctorId,
            fn () => $this->calculateAvailableSlots($treatment, $startDate, $endDate, $doctorId)
        );

        return $this->successResponse([
            'treatment' => [
                'id' => $treatment->id,
                'title' => $treatment->title,
                'duration' => $treatment->duration,
                'price' => $treatment->price,
            ],
            'date_range' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
            ],
            'available_slots' => $availableSlots,
        ]);
    }

    /**
     * Calculate available slots for the treatment
     *
     * @param  Treatment  $treatment
     * @param  Carbon  $startDate
     * @param  Carbon  $endDate
     * @param  int|null  $doctorId
     * @return array
     */
    private function calculateAvailableSlots($treatment, $startDate, $endDate, $doctorId = null)
    {
        $treatmentDuration = $treatment->duration;

        // Get doctors who can perform this treatment
        $doctorIds = $doctorId
            ? [$doctorId]
            : $treatment->doctors()->pluck('users.id')->toArray();

        if (empty($doctorIds)) {
            return [];
        }

        // Get all slots for these doctors in date range
        $slots = Slot::whereIn('doctor_id', $doctorIds)
            ->whereBetween('date', [$startDate, $endDate])
            ->orderBy('date')
            ->orderBy('start_time')
            ->get();

        // Get all non-cancelled bookings in this date range
        $bookings = Booking::whereIn('doctor_id', $doctorIds)
            ->where('is_cancelled', false)
            ->where(function ($query) use ($startDate, $endDate) {
                $query->whereBetween('start_datetime', [
                    $startDate->format('Y-m-d 00:00:00'),
                    $endDate->format('Y-m-d 23:59:59'),
                ]);
            })
            ->get();

        // Group slots by date
        $availableSlotsByDate = [];

        foreach ($slots as $slot) {
            // Ensure date is in proper format (strip time if present)
            $dateString = $slot->date instanceof Carbon
                ? $slot->date->format('Y-m-d')
                : (is_string($slot->date) ? substr($slot->date, 0, 10) : $slot->date);

            $slotStartTime = Carbon::parse($dateString.' '.$slot->start_time);
            $slotEndTime = Carbon::parse($dateString.' '.$slot->end_time);

            // Generate possible time slots based on treatment duration
            $currentTime = $slotStartTime->copy();

            while ($currentTime->copy()->addMinutes($treatmentDuration) <= $slotEndTime) {
                $slotStart = $currentTime->copy();
                $slotEnd = $slotStart->copy()->addMinutes($treatmentDuration);

                // Check if this time slot is available (not booked)
                $isAvailable = $this->isSlotAvailable($slotStart, $slotEnd, $slot->doctor_id, $bookings);

                if ($isAvailable) {
                    $dateKey = $slotStart->format('Y-m-d');
                    $timeKey = $slotStart->format('H:i');

                    // Add to available slots if not already added
                    if (! isset($availableSlotsByDate[$dateKey])) {
                        $availableSlotsByDate[$dateKey] = [];
                    }

                    if (! in_array($timeKey, $availableSlotsByDate[$dateKey])) {
                        $availableSlotsByDate[$dateKey][] = $timeKey;
                    }
                }

                // Move to next possible slot (in 10-minute increments)
                $currentTime->addMinutes(10);
            }
        }

        // Sort time slots for each date and keep only first and last
        foreach ($availableSlotsByDate as $date => &$times) {
            sort($times);

            // Keep only the first and last time slot for each date
            if (count($times) > 2) {
                $times = [$times[0], $times[count($times) - 1]];
            }
        }

        return $availableSlotsByDate;
    }

    /**
     * Check if a specific time slot is available for a doctor
     *
     * @param  Carbon  $slotStart
     * @param  Carbon  $slotEnd
     * @param  int  $doctorId
     * @param  Collection  $bookings
     * @return bool
     */
    private function isSlotAvailable($slotStart, $slotEnd, $doctorId, $bookings)
    {
        foreach ($bookings as $booking) {
            // Check if this booking is for the same doctor
            if ($booking->doctor_id !== $doctorId) {
                continue;
            }

            $bookingStart = Carbon::parse($booking->start_datetime);
            $bookingEnd = Carbon::parse($booking->end_datetime);

            // Check for time overlap
            if ($slotStart < $bookingEnd && $slotEnd > $bookingStart) {
                return false; // Slot is not available
            }
        }

        return true; // Slot is available
    }
}
