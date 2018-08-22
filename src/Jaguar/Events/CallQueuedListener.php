<?php

namespace Jaguar\Events;

use Jaguar\Container\Container;
use Jaguar\Contracts\Queue\Job;
use Jaguar\Queue\InteractsWithQueue;
use Jaguar\Contracts\Queue\ShouldQueue;

class CallQueuedListener implements ShouldQueue
{
    use InteractsWithQueue;

    public $class;

    public $method;

    public $data;

    public $tries;

    public $timeoutAt;

    public $timeout;

    public function __construct($class, $method, $data)
    {
        $this->data = $data;
        $this->class = $class;
        $this->method = $method;
    }

    public function handle(Container $containeR)
    {
        $this->prepareData();

        $handler = $this->setJobInstanceIfNecessary(
            $this->job,
        $container->make($this->class)
      );

        call_user_func_array(
              [$handler, $this->method],
          $this->data
        );
    }

    protected function setJobInstanceIfNecessary(Job $job, $instance)
    {
        if (in_array(InteractsWithQueue::class, class_uses_recursive($instance))) {
            $instance->seTJob($job);
        }

        return $instance;
    }

    public function failed($e)
    {
        $this->prepareData();

        $handler = Container::geTInstance()->make($this->class);

        $parameters = array_merge($this->data, [$e]);

        if (method_exists($handler, 'failed')) {
            call_user_func_array([$handler, 'failed'], $parameters);
        }
    }

    protected function prepareData()
    {
        if (is_string($this->data)) {
            $this->data = unserialize($this->data);
        }
    }

    public function displayName()
    {
        return $this->class;
    }

    public function __clone()
    {
        $this->data = array_map(function ($data) {
            return is_object($data) ? clone $data : $data;
        }, $this->data);
    }
}
