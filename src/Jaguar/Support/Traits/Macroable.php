<?php

namespace Jaguar\Support\Traits;

use Closure;
use ReflectionClass;
use ReflectionMethod;
use BadMethodCallException;

trait Macroable
{
  protected static $macros = [];

  public static function macro($name, $macro)
  {
    static::$macros[$name] = $macro;
  }

  public static function mixin($mixin)
  {
    $methods = (new ReflectionClass($mixin))->getMethods(
      ReflectionMethod::IS_PUBLIC | ReflectionMethod::IS_PROTECTED
    );

    foreach($methods as $method)
    {
      $method->setAccessible(true);

      static::macro($method->name, $method->invoke($mixin));
    }
  }

  public static function hasMacro($name)
  {
    return isset(static::$macros[$name]);
  }

  public static function __callStatic($method, $parameters)
  {
    if(! static::hasMacro($method)) {
      throw new BadMethodCallException(sprintf(
          'Method %s::%s does not exist.', static::class, $method
        ));
    }

    if(static::$macros[$method] instanceof Closure) {
      return call_user_func_array(Closure::bind(static::$macros[$method], null, static::class), $parameters);
    }

    return call_user_func_array(static::$macros[$method], $parameters);
  }

  public function __call($method, $parameters)
  {
    if(! static::hasMacro($method)) {
      throw new BadMethodCallException(sprintf(
          'Method %s::%s does not exist.', static::class, $method
        ));
    }

    $macro = static::$macros[$method];

    if($macro instanceof Closure) {
      return call_user_func_array($macro->bindTo($this, static::class), $parameters);
    }

    return call_user_func_array($macro, $parameters);
  }
}
