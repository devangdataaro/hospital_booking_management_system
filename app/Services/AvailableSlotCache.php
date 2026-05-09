<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Cache;

/**
 * Versioned cache keys for available-slot responses so mutations invalidate
 * results without flushing the entire application cache.
 */
class AvailableSlotCache
{
    private const TTL_SECONDS = 300;

    public static function versionKey(int $treatmentId): string
    {
        return "available_slots_ver_treatment_{$treatmentId}";
    }

    public static function currentVersion(int $treatmentId): int
    {
        return (int) Cache::get(self::versionKey($treatmentId), 0);
    }

    public static function bumpTreatment(int $treatmentId): void
    {
        Cache::increment(self::versionKey($treatmentId));
    }

    public static function bumpForDoctor(User $doctor): void
    {
        $ids = $doctor->treatments()->pluck('treatments.id');
        foreach ($ids as $tid) {
            self::bumpTreatment((int) $tid);
        }
    }

    /**
     * @template T
     *
     * @param  \Closure(): T  $callback
     * @return T
     */
    public static function remember(int $treatmentId, string $startYmd, string $endYmd, ?int $doctorId, \Closure $callback): mixed
    {
        $v = self::currentVersion($treatmentId);
        $suffix = $doctorId ?? 'all';
        $key = "available_slots:v{$v}:t{$treatmentId}:{$startYmd}:{$endYmd}:{$suffix}";

        return Cache::remember($key, self::TTL_SECONDS, $callback);
    }
}
