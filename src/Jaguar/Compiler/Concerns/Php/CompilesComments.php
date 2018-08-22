<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesComments
{
  protected function compileComments($value)
  {
    $pattern = sprintf('/%s--(.*?)--%s/s', $this->contentTags[0], $this->contentTags[1]);

    return preg_replace($pattern, '', $value);
  }
}
