<?php

namespace Jaguar\Container;

use Jaguar\Contracts\Container\ContextualBindingBuilder as ContextualBindingBuilderContract;

class ContextualBindingBuilder implements ContextualBindingBuilderContract
{
  protected $container;

  protected $concrete;

  protected $needs;

  public function __construct(Container $container, $concrete)
  {
    $this->concrete = $concrete;
    $this->container = $container;
  }

  public function needs($abstract)
  {
    $this->needs = $abstract;

    return $this;
  }

  public function give($implementation)
  {
    $this->container->addContextualBinding(
      $this->concrete, $this->needs, $implementation
    );
  }
}
