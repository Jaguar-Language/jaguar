<?php

namespace Jaguar\Support;

use JsonSerializable;
use Carbon\Carbon as BaseCarbon;
use Jaguar\Support\Traits\Macroable;

class Carbon extends BaseCarbon implements JsonSerializable
{
    use Macroable;

    protected static $serializer;

    public function jsonSerialize()
    {
        if (static::$serializer) {
            return call_user_func(static::$serializer, $this);
        }

        $carbon = $this;

        return call_user_func(function () use ($carbon) {
            return get_object_vars($carbon);
        });
    }

    public static function serializeUsing($callback)
    {
        static::$serializer = $callback;
    }
}
