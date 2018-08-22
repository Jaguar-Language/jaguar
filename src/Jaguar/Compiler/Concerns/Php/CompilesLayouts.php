<?php

namespace Jaguar\Compiler\Concerns\Php;

use Jaguar\Compiler\View\Factory as ViewFactory;

trait CompilesLayouts
{
    protected $lastSection;

    protected function compileExtends($expression)
    {
        $expression = $this->stripParentheses($expression);

        $echo = "<?php echo \$__env->make({$expression}, array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>";

        $this->footer[] = $echo;

        return '';
    }

    protected function compileSection($expression)
    {
        $this->lastSection = trim($expression, "()'\" ");

        return "<?php \$__env->startSection{$expression}; ?>";
    }

    protected function compileParent()
    {
        return ViewFactory::parentPlaceholder($this->lastSection ?: '');
    }

    protected function compileYield($expression)
    {
        return "<?php echo \$__env->yieldContent{$expression}; ?>";
    }

    protected function compileShow()
    {
        return "<?php echo \$__env->yieldSection(); ?>";
    }

    protected function compileAppend()
    {
        return "<?php \$__env->appendSection(); ?>";
    }

    protected function compileOverwrite()
    {
        return "<?php \$__env->stopSection(true); ?>";
    }

    protected function compileStop()
    {
        return "<?php \$__env->stopSection(); ?>";
    }

    protected function compileEndsection()
    {
        return "<?php \$__env->stopSection(); ?>";
    }
}
