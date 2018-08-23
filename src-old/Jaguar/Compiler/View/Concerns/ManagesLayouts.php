<?php

namespace Jaguar\Compiler\View\Concerns;

use InvalidArgumentException;
use Jaguar\Contracts\Compiler\View\View;

trait ManagesLayouts
{
    protected $sections = [];

    protected $sectionStack = [];

    protected static $parentPlaceholder = [];

    public function startSection($section, $content = null)
    {
        if ($content === null) {
            if (ob_start()) {
                $this->sectionStack[] = $section;
            }
        } else {
            $this->extendSection($section, $content instanceof View ? $content: e($content));
        }
    }

    public function inject($section, $content)
    {
        $this->startSection($section, $content);
    }

    public function yieldSection()
    {
        if (empty($this->sectionStack)) {
            return '';
        }

        return $this->yieldContent($this->stopSection());
    }

    public function stopSection($overwrite = false)
    {
        if (empty($this->sectionStack)) {
            throw new InvalidArgumentException("cannot end a section without first starting one.");
        }

        $last = array_pop($this->sectionStack);

        if ($overwrite) {
            $this->sections[$last] = ob_get_clean();
        } else {
            $this->extendSection($last, ob_get_clean());
        }

        return $last;
    }

    public function appendSection()
    {
        if (empty($this->sectionStack)) {
            throw new InvalidArgumentException("Cannot end a section without first starting one.");
        }

        $last = array_pop($this->sectionStack);

        if (isset($this->sections[$last])) {
            $this->sections[$last] .= ob_get_clean();
        } else {
            $this->sections[$last] = ob_get_clean();
        }

        return $last;
    }

    protected function extendSection($section, $content)
    {
        if (isset($this->sections[$section])) {
            $content = str_replace(static::parentPlaceholder($section), $content, $this->sections[$section]);
        }

        $this->sections[$section] = $content;
    }

    public function yieldContent($section, $default = '')
    {
        $sectionContent = $default instanceof View ? $default : e($default);

        if (isset($this->sections[$section])) {
            $sectionContent = $this->sections[$section];
        }

        $sectionContent = str_replace('%%parent', '--parent--holder--', $sectionContent);

        return str_replace(
          '--parent--holder--',
        '%parent',
        str_replace(static::parentPlaceholder($section), '', $sectionContent)
      );
    }

    public static function parentPlaceholder($section = '')
    {
        if (! isset(static::$parentPlaceholder[$section])) {
            static::$parentPlaceholder[$section] = '##parent-placeholder-'.sha1($section).'##';
        }

        return static::$parentPlaceholder[$section];
    }

    public function hasSection($name)
    {
        return array_key_exists($name, $this->sections);
    }

    public function getSection($name, $default = null)
    {
        return $this->getSections()[$name] ?? $default;
    }

    public function getSections()
    {
        return $this->sections;
    }

    public function flushSections()
    {
        $this->sections = [];
        $this->sectionStack = [];
    }
}
