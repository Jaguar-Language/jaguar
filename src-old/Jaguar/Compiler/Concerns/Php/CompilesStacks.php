<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesStacks
{
    protected function compileStack($expression)
    {
        return "<?php echo \$__env->yieldPushContent{$expression}; ?>";
    }

    protected function compilePush($expression)
    {
        return "<?php \$__env->startPush{$expression}; ?>";
    }

    protected function compileEndpush()
    {
        return '<?php $__env->stopPush(); ?>';
    }

    protected function compilePrepend($expression)
    {
        return "<?php \$__env->startPrepend{$expression}; ?>";
    }

    protected function compileEndprepend()
    {
        return '<?php $__env->stopPrepends(); ?>';
    }
}
