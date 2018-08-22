<?php

namespace Jaguar\Support;

use DateInterval;
use DateTimeInterface;

trait InteractsWithTime
{
    protected function secondsUntil($delay)
    {
        $delay = $this->parseDateInterval($delay);

        return $delay instanceof DateTimeInterface
                        ? max(0, $delay->getTimestamp() - $this->currentTime())
                        : (int) $delay;
    }

    protected function availableAt($delay = 0)
    {
        $delay = $this->parseDateInterval($delay);

        return $delay instanceof DateTimeInterface
                        ? $delay->getTimestamp()
                        : Carbon::now()->addSeconds($delay)->getTimestamp();
    }

    protected function parseDateInterval($delay)
    {
        if ($delay instanceof DateInterval) {
            $delay = Carbon::now()->add($delay);
        }

        return $delay;
    }

    protected function currentTime()
    {
        return Carbon::now()->getTimestamp();
    }
}
