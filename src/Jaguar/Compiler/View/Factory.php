<?php

namespace Jaguar\Compiler\View;

use Jaguar\Support\Arr;
use Jaguar\Support\Str;
use InvalidArgumentException;
use Jaguar\Contracts\Events\Dispatcher;
use Jaguar\Contracts\Support\Arrayable;
use Jaguar\Compiler\View\Engines\EngineResolver;
use Jaguar\Contracts\Container\Container;
use Jaguar\Contracts\Compiler\View\Factory as FactoryContract;

class Factory implements FactoryContract
{
    protected $engines;

    protected $finder;

    protected $events;

    protected $container;

    protected $shared = [];

    protected $extensions = [
    '.jaguar' => 'jaguar',
    '.jag' => 'jaguar',
    'php' => 'php',
    'css' => 'file',
  ];

    protected $composers = [];

    protected $renderCount = 0;

    public function __construct(EngineResolver $engines, ViewFinderInterface $finder, Dispatcher $events)
    {
        $this->finder = $finder;
        $this->events = $events;
        $this->engines = $engines;

        $this->share('__env', $this);
    }

    public function file($path, $data = [], $mergeData = [])
    {
        $data = array_merge($mergeData, $this->parseData($data));

        return tap($this->viewInstance($path, $path, $data), function ($view) {
            $this->callCreator($view);
        });
    }

    public function make($view, $data = [], $mergeData = [])
    {
        $path = $this->finder->find(
          $view = $this->normalizeName($view)
        );

        $data = array_merge($mergeData, $this->parseData($data));

        return tap($this->viewInstance($view, $path, $data), function ($view) {
            $this->callCreator($view);
        });
    }

    public function first(array $views, $data = [], $mergeData = [])
    {
        $view = Arr::first($views, function ($view) {
            return $this->exists($view);
        });

        if (! $view) {
            throw new InvalidArgumentException("None of the views in the given array exist.");
        }

        return $this->make($view, $data, $mergeData);
    }

    public function renderWhen($condition, $view, $data = [], $mergeData = [])
    {
        if (!$condition) {
            return '';
        }

        return $this->make($view, $this->parseData($data), $mergeData)->render();
    }

    public function renderEach($view, $data, $iterator, $empty = 'raw|')
    {
        $result = '';

        if (count($data) > 0) {
            foreach ($data as $key => $value) {
                $result .= $this->make(
                $view,
              ['key' => $key, $iterator => $value]
            )->render();
            }
        } else {
            $result = Str::startsWith($empty, 'raw|')
                        ? substr($empty, 4)
                        : $this->make($empty)->render();
        }

        return $result;
    }

    protected function normalizeName($name)
    {
        return ViewName::normalize($name);
    }

    protected function parseData($data)
    {
        return $data instanceof Arrayable ? $data->toArray() : $data;
    }

    protected function viewInstance($view, $path, $data)
    {
        return new View($this, $this->getEngineFromPath($path), $view, $path, $data);
    }

    public function exists($view)
    {
        try {
            $this->finder->find($view);
        } catch (InvalidArgumentException $e) {
            return false;
        }

        return true;
    }

    public function getEngineFromPath($path)
    {
        if (! $extension = $this->getExtension($path)) {
            throw new InvalidArgumentException("Unrecognized extension in file: {$path}");
        }

        $engine = $this->extensions[$extension];

        return $this->engines->resolve($engine);
    }

    protected function getExtension($path)
    {
        $extensions = array_keys($this->extensions);

        return Arr::first($extensions, function ($value) use ($path) {
            return Str::endsWith($path, '.'.$value);
        });
    }

    public function share($key, $value = null)
    {
        $keys = is_array($key) ? $key : [$key => $value];

        foreach ($keys as $key => $value) {
            $this->shared[$key] = $value;
        }

        return $value;
    }

    public function incrementRender()
    {
        $this->renderCount++;
    }

    public function decrementRender()
    {
        $this->renderCount--;
    }

    public function doneRendering()
    {
        return $this->renderCount == 0;
    }

    public function addLocation($location)
    {
        $this->finder->addLocation($location);
    }

    public function addNamespace($namespace, $hints)
    {
        $this->finder->addNamespace($namespace, $hints);
        return $this;
    }

    public function prependNamespace($namespace, $hints)
    {
        $this->finder->prependNamespace($namespace, $hints);
        return $this;
    }

    public function replaceNamespace($namespace, $hints)
    {
        $this->finder->replaceNamespace($namespace, $hints);
        return $this;
    }

    public function addExtension($extension, $engine, $resolver = null)
    {
        $this->finder->addExtension($extension);

        if (isset($resolver)) {
            $this->engines->register($engine, $resolver);
        }

        unset($this->extensions[$extension]);

        $this->extensions = array_merge([$extension => $engine], $this->extensions);
    }

    public function flushState()
    {
        $this->renderCount = 0;

        $this->flushSections();
        $this->flushStacks();
    }

    public function flushStateIfDoneRendering()
    {
        if ($this->doneRendering()) {
            $this->flushState();
        }
    }

    public function getExtensions()
    {
        return $this->extensions;
    }

    public function getEngineResolver()
    {
        return $this->engines;
    }

    public function getFinder()
    {
        return $this->finder;
    }

    public function setFinder(ViewFinderInterface $finder)
    {
        $this->finder = $finder;
    }

    public function flushFinderCache()
    {
        $this->getFinder()->flush();
    }

    public function getDispatcher()
    {
        return $this->events;
    }

    public function setDispatcher(Dispatcher $events)
    {
        $this->events = $events;
    }

    public function getContainer()
    {
        return $this->container;
    }

    public function setContainer(Container $container)
    {
        $this->container = $container;
    }

    public function shared($key, $default = null)
    {
        return Arr::get($this->shared, $key, $default);
    }

    public function getShared()
    {
        return $this->shared;
    }
}
