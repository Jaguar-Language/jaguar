<?php

namespace Jaguar\Queue\Jobs;

use Jaguar\Support\InteractsWithTime;

abstract class Job
{
    use InteractsWithTime;

    protected $instance;

    protected $container;

    protected $deleted = false;

    protected $released = false;

    protected $failed = false;

    protected $connectionName;

    protected $queue;

    abstract public function getJobId();

    abstract public function getRawBody();

    public function fire()
    {
        $payload = $this->payload();

        list($class, $method) = JobName::parse($payload['job']);

        ($this->instance = $this->resolve($class))->{$method}($this, $payload['data']);
    }

    public function delete()
    {
        $this->deleted = true;
    }

    public function isDeleted()
    {
        return $this->deleted;
    }

    public function release($delay = 0)
    {
        $this->released = true;
    }

    public function isReleased()
    {
        return $this->released;
    }

    public function isDeletedOrReleased()
    {
        return $this->isDeleted() || $this->isReleased();
    }

    public function hasFailed()
    {
        return $this->failed;
    }

    public function markAsFailed()
    {
        $this->failed = true;
    }

    public function failed($e)
    {
        $this->markAsFailed();

        $payload = $this->payload();

        list($class, $method) = JobName::parse($payload['job']);

        if (method_exists($this->instance = $this->resolve($class), 'failed')) {
            $this->instance->failed($payload['data'], $e);
        }
    }

    protected function resolve($class)
    {
        return $this->container->make($class);
    }

    public function payload()
    {
        return json_decode($this->getRawBody(), true);
    }

    public function maxTries()
    {
        return $this->payload()['maxTries'] ?? null;
    }

    public function timeout()
    {
        return $this->payload()['timeout'] ?? null;
    }

    public function timeoutAt()
    {
        return $this->payload()['timeoutAt'] ?? null;
    }

    public function getName()
    {
        return $this->payload()['job'];
    }

    public function resolveName()
    {
        return JobName::resolve($this->getName(), $this->payload());
    }

    public function getConnectionName()
    {
        return $this->connectionName;
    }

    public function getQueue()
    {
        return $this->queue;
    }

    public function getContainer()
    {
        return $this->container;
    }
}
