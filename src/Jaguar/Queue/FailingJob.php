<?php

namespace Jaguar\Queue;

use Jaguar\Container\Container;
use Jaguar\Queue\Events\JobFailed;
use Jaguar\Contracts\Events\Dispatcher;

class FailingJob
{
    public static function handle($connectionName, $job, $e = null)
    {
        $job->markAsFailed();

        if ($job->isDeleted()) {
            return ;
        }

        try {
            $job->delete();
            $job->failed($e);
        } finally {
            static::events()->dispatch(new JobFailed(
              $connectionName,
          $job,
          $e ?: new ManuallyFailedException
        ));
        }
    }

    protected static function events()
    {
        return Container::getInstance()->make(Dispatcher::class);
    }
}
