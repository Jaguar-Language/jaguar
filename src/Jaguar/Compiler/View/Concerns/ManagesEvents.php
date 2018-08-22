<?php

namespace Jaguar\Compiler\View\Concerns;

use Closure;
use Jaguar\Support\Str;
use Jaguar\Contracts\Compiler\View\View as ViewContract;

trait ManagesEvents
{
    public function creator($views, $callback)
    {
        $creators = [];

        foreach ((array) $views as $view) {
            $creators[] = $this->addViewEvent($view, $callback, 'creating: ');
        }

        return $creators;
    }

    public function composers(array $composers)
    {
        $registered = [];

        foreach ($composers as $callback => $views) {
            $registered = array_merge($registered, $this->composer($views, $callback));
        }

        return $registered;
    }

    public function composer($views, $callback)
    {
        $composers = [];

        foreach ((array) $views as $view) {
            $composers[] = $this->addViewEvent($view, $callback, 'composing: ');
        }

        return $composers;
    }

    protected function addViewEvent($view, $callback, $prefix = 'composing: ')
    {
        $view = $this->normalizeName($view);

        if ($callback instanceof Closure) {
            $this->addEventListener($prefix.$view, $callback);

            return $callback;
        } elseif (is_string($callback)) {
            return $this->addClassEvent($view, $callback, $prefix);
        }
    }

    protected function addClassEvent($view, $class, $prefix)
    {
        $name = $prefix.$view;

        $callback = $this->buildClassEventCallback(
            $class,
        $prefix
      );

        $this->addEventListener($name, $callback);

        return $callback;
    }

    protected function buildClassEventCallback($class, $prefix)
    {
        list($class, $method) = $this->parseClassEvent($class, $prefix);

        return function () use ($class, $method) {
            return call_user_func_array(
            [$this->container->make($class), $method],
            func_get_args()
        );
        };
    }

    protected function parseClassEvent($class, $prefix)
    {
        return Str::parseCallback($class, $this->classEventMethodForPrefix($prefix));
    }

    protected function classEventMethodForPrefix($prefix)
    {
        return Str::contains($prefix, 'composing') ? 'compose' : 'create';
    }

    protected function addEventListener($name, $callback)
    {
        if (Str::contains($name, '*')) {
            $callback = function ($name, array $data) use ($callback) {
                return $callback($data[0]);
            };
        }

        $this->events->listen($name, $callback);
    }

    public function callComposer(ViewContract $view)
    {
        $this->events->dispatch('composing: '.$view->name(), [$view]);
    }

    public function callCreator(ViewContract $view)
    {
        $this->events->dispatch('creating: '.$view->name(), [$view]);
    }
}
