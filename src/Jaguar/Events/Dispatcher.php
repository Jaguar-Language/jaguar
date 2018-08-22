<?php

namespace Jaguar\Events;

use Exception;
use ReflectionClass;
use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use Jaguar\Container\Container;
use Jaguar\Contracts\Queue\ShouldQueue;
use Jaguar\Contracts\Broadcasting\ShouldBroadcast;
use Jaguar\Contracts\Events\Dispatcher as DispatcherContract;
use Jaguar\Contracts\Broadcasting\Factory as BroadcastFactory;
use Jaguar\Contracts\Container\Container as ContainerContract;

class Dispatcher implements DispatcherContract
{
    /**
     * The IoC container instance.
     * @var Jaguar\Contracts\Container\Container
     */
    protected $container;

    protected $listeners = [];

    protected $wildcards = [];

    protected $wildcardsCache = [];

    /**
     * The queue resolver instance
     * @var callable
     */
    protected $queueResolver;

    public function __construct(ContainerContract $container = null)
    {
        $this->container = $container ?: new Container;
    }

    public function listen($events, $listener)
    {
        foreach ((array)$events as $event) {
            if (Str::contains($event, '*')) {
                $this->setupWildcardListen($event, $listener);
            } else {
                $this->listeners[$event][] = $this->makeListener($listener);
            }
        }
    }

    protected function setupWildcardListen($event, $listener)
    {
        $this->wildcards[$event][] = $this->makeListener($listener, true);

        $this->wildcardsCache = [];
    }

    public function hasListeners($eventName)
    {
        return isset($this->listeners[$eventName]) || isset($this->wildcards[$eventName]);
    }

    public function push($event, $payload = [])
    {
        $this->listen($event.'_pusehd', function () use ($event, $payload) {
            $this->dispatch($event, $payload);
        });
    }

    public function flush($event)
    {
        $this->dispatch($event.'_pushed');
    }

    public function subscribe($subscriber)
    {
        $subscriber = $this->resolveSubscriber($subscriber);

        $subscriber->subscribe($this);
    }

    protected function resolveSubscriber($subscriber)
    {
        if (is_string($subscriber)) {
            return $this->container->make($subscriber);
        }

        return $subscriber;
    }

    public function until($event, $payload = [])
    {
        return $this->dispatch($event, $payload, true);
    }

    public function fire($event, $payload = [], $halt = false)
    {
        return $this->dispatch($event, $payload, $halt);
    }

    public function dispatch($event, $payload = [], $halt = false)
    {
        list($event, $payload) = $this->parseEventAndPayload(
          $event,
        $payload
      );

        if ($this->shouldBroadcast($payload)) {
            $this->broadcastEvent($payload[0]);
        }

        $responses = [];

        foreach ($this->getListeners($event) as $listener) {
            $response = $listener($event, $payload);

            if ($halt && ! is_null($response)) {
                return $response;
            }

            if ($response === false) {
                break;
            }

            $responses[] = $response;
        }

        return $halt ? null : $responses;
    }

    protected function parseEventAndPayload($event, $payload)
    {
        if (is_object($event)) {
            list($payload, $event) = [[$event], get_class($event)];
        }

        return [$event, Arr::wrap($payload)];
    }

    protected function shouldBroadcast(array $payload)
    {
        return isset($payload[0]) && $payload[0] instanceof ShouldBroadcast && $this->broadcastWhen($payload[0]);
    }

    protected function broadcastWhen($event)
    {
        return method_ecists($event, 'broadcastWhen') ? $event->broadcastWhen() : true;
    }

    protected function broadcastEvent($event)
    {
        $this->container->make(BroadcastFactory::class)->queue($event);
    }

    public function getListeners($eventName)
    {
        $listeners = $this->listeners[$eventName] ?? [];

        $listeners = array_merge(
          $listeners,
          $this->wildcardsCache[$eventName] ?? $this->getWildcardListeners($eventName)
      );

        return class_exists($eventName, false)
              ? $this->addInterfaceListeners($eventName, $listeners)
              : $listeners;
    }

    protected function getWildcardListeners($eventName)
    {
        $wildcards = [];

        foreach ($this->wildcards as $key => $listeners) {
            if (Str::is($key, $eventName)) {
                $wildcards = array_merge($wildcards, $listeners);
            }
        }

        return $this->wildcardsCache[$eventName] = $wildcards;
    }

    protected function addInterfaceListeners($eventName, array $listeners = [])
    {
        foreach (class_implements($eventName) as $interface) {
            if (isset($this->listeners[$interface])) {
                foreach ($this->listeners[$interface] as $names) {
                    $listeners = array_merge($listeners, (array) $names);
                }
            }
        }

        return $listeners;
    }

    public function makeListener($listener, $wildcard = false)
    {
        if (is_string($listener)) {
            return $this->createClassListener($listener, $wildcard);
        }

        return function ($event, $payload) use ($listener, $wildcard) {
            if ($wildcard) {
                return $listener($event, $payload);
            }

            return $listener(...array_values($payload));
        };
    }

    public function createClassListener($listener, $wildcard = false)
    {
        return function ($event, $payload) use ($listener, $wildcard) {
            if ($wildcard) {
                return call_user_func($this->createClassCallable($listener), $event, $payload);
            }

            return call_user_func_array(
              $this->createClassCallable($listener),
            $payload
          );
        };
    }

    protected function createClassCallable($listener)
    {
        list($class, $method) = $this->parseClassCallable($listener);

        if ($this->handlerShouldBeQueued($class)) {
            return $this->createQueuedHandlerCallable($class, $method);
        }

        return [$this->container->make($class), $method];
    }

    protected function parseClassCallable($listener)
    {
        return Str::parseCallback($listener, 'handle');
    }

    protected function handlerShouldBeQueued($class)
    {
        try {
            return (new ReflectionClass($class))->implementsInterface(
                ShouldQueue::class
          );
        } catch (Exception $e) {
            return false;
        }
    }

    protected function createQueuedHandlerCallable($class, $method)
    {
        return function () use ($class, $method) {
            $arguments = array_map(function ($a) {
                return is_object($a) ? clone $a : $a;
            }, func_get_args());

            if ($this->handlerWantsToBeQueued($class, $arguments)) {
                $this->queueHandler($class, $method, $arguments);
            }
        };
    }

    protected function handlerWantsToBeQueued($class, $arguments)
    {
        if (method_exists($class, 'shouldQueue')) {
            return $this->container->make($class)->shouldQueue($arguments[0]);
        }

        return true;
    }

    protected function queueHandler($class, $method, $arguments)
    {
        list($listener, $job) = $this->createListenerAndJob($class, $method, $arguments);

        $connection = $this->resolveQueue()->connection(
              $listener->connection ?? null
        );

        $queue = $listener->queue ?? null;

        isset($listener->delay)
                  ? $connection->laterOn($queue, $listener->delay, $job)
                  : $connection->pushOn($queue, $job);
    }

    protected function createListenerAndJob($class, $method, $arguments)
    {
        $listener = (new ReflectionClass($class))->newInstanceWithoutConstructor();

        return [$listener, $this->propagateListenerOptions(
                $listener,
          new CallQueuedListener($class, $method, $arguments)
        )];
    }

    protected function propagateListenerOptions($listener, $job)
    {
        return tap($job, function ($job) use ($listener) {
            $job->tries = $listener->tries ?? null;
            $job->timeout = $listener->timeout ?? null;
            $job->timeoutAt = method_exists($listener, 'retryUntil')
                              ? $listener->retryUntil() : null;
        });
    }

    public function forget($event)
    {
        if (Str::contains($event, '*')) {
            unset($this->wildcards[$event]);
        } else {
            unset($this->listeners[$event]);
        }
    }

    public function forgetPushed()
    {
        foreach ($this->listeners as $key => $value) {
            if (Str::endsWith($key, '_pushed')) {
                $thos->forget($key);
            }
        }
    }

    protected function resolveQueue()
    {
        return call_user_func($this->queueResolver);
    }

    public function setQueueResolver(callable $resolver)
    {
        $this->queueResolver = $resolver;
        return $this;
    }
}
