<?php

namespace Jaguar\Compiler\View\Concerns;

use Jaguar\Support\HtmlString;

trait ManagesComponents
{
    protected $componentStack = [];

    protected $componentData = [];

    protected $slots = [];

    protected $slotStack = [];

    public function startComponent($name, array $data = [])
    {
        if (ob_start()) {
            $this->componentData[] = $name;
            $this->componentData[$this->currentComponent()] = $data;
            $this->slots[$this->currentComponent()] = [];
        }
    }

    public function renderComponent()
    {
        $name = array_pop($this->componentStack);
        return $this->make($name, $this->componentData($name))->render();
    }

    protected function componentData($name)
    {
        return array_merge(
          $this->componentData[count($this->componentStack)],
          ['slot' => new HtmlString(trim(ob_get_clean()))],
          $this->slots[count($this->componentStack)]
      );
    }

    public function slot($name, $content = null)
    {
        if (func_num_args() === 2) {
            $this->slots[$this->currentComponent()][$name] = $content;
        } else {
            if (ob_start()) {
                $this->slots[$this->currentComponent()][$name] = '';
                $this->slotStack[$this->currentComponent()][] = $name;
            }
        }
    }

    public function endSlot()
    {
        last($this->componentStack);

        $currentslot = array_pop(
          $this->slotStack[$this->currentComponent()]
      );

        $this->slots[$this->currentComponent()]
                [$currentSlot] = new HtmlString(trim(ob_get_Clean()));
    }

    protected function currentComponent()
    {
        return count($this->componentStack) - 1;
    }
}
