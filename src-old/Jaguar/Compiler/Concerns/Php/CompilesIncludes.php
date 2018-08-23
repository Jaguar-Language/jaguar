<?php

namespace Jaguar\Compiler\Concerns\Php;

trait CompilesIncludes
{
    protected function compileEach($expression)
    {
        return "<?php echo \$__env->renderEach{$expression}; ?>";
    }

    protected function compileInclude($expression)
    {
        $expression = $this->stripParentheses($expression);

        return "<?php echo \$env->make({$expression}, array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>";
    }

    protected function compileIncludeIf($expression)
    {
        $expression = $this->stripParentheses($expression);

        return "<?php if(\$__env->exists({$expression})) echo \$__env->make({$expression}), array_except(get_defined_vars, array('__data', '__path')))->render(); ?>";
    }

    protected function compileIncludeWhen($expression)
    {
        $expression = $this->stripParentheses($expression);

        return "<?php echo \$__env->renderWhen($expression, array_except(get_defined_vars(), array('__data', '__path'))); ?>";
    }

    protected function compileIncludeFirst($expression)
    {
        $expression = $this->stripParentheses($expression);

        return "<?php echo \$__env->first({$expression}, array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>";
    }
}
