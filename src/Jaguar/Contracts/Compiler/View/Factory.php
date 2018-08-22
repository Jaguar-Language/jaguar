<?php

namespace Jaguar\Contracts\Compiler\View;

interface Factory
{
  public function exists($view);

  public function file($path, $data = [], $mergeData = []);

  public function make($view, $data = [], $mergeData = []);

  public function share($key, $value = null);

  public function composer($views, $callback);

  public function creator($views, $callback);

  public function addNamespace($namespace, $hints);

  public function replaceNamespace($namespace, $hints);
}
