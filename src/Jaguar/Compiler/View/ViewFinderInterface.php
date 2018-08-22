<?php

namespace Jaguar\Compiler\View;

interface ViewFinderInterface
{
  const HINT_PATH_DELIMITER = "::";

  public function find($view);

  public function addLocation($location);

  public function addNamespace($namespace, $hints);

  public function prependNamespace($namespace, $hints);

  public function replaceNamespace($namespace, $hints);

  public function addExtension($extension);

  public function flush();
}
