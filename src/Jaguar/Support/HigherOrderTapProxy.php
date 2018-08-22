<?php

namespace Jaguar\Support;

class HigherOrderTapProxy
{
    public $target;

    public function __construct($target)
    {
        $this->target = $target;
    }

    public function __call($method, $parameters)
    {
        $this->target->{$method}(...$parameters);

        return $this->target;
    }
}
