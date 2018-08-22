<?php

namespace Jaguar\Foundation\Filesystem;

use ErrorException;
use FilesystemIterator;
use Symfony\Component\Finder\Finder;
use Jaguar\Support\Traits\Macroable;
use Jaguar\Contracts\Foundation\Filesystem\FileNotFoundException;

class Filesystem
{
    use Macroable;

    public function exists($path)
    {
        return file_exists($path);
    }

    public function get($path, $lock = false)
    {
        if ($this->isFile($path)) {
            return $lock ? $this->sharedGet($path) : file_get_contents($path);
        }

        throw new FileNotFoundException("File does not exist at path {$path}");
    }

    public function sharedGet($path)
    {
        $contents = '';

        $handle = fopen($path, 'rb');

        if ($handle) {
            try {
                if (flock($handle, LOCK_SH)) {
                    clearstatcache(true, $path);

                    $contents = fread($handle, $this->size($path) ?: 1);

                    flock($handle, LOCK_UN);
                }
            } finally {
                fclose($handle);
            }
        }

        return $contents;
    }

    public function getRequire($path)
    {
        if ($this->isFile($path)) {
            return require $path;
        }

        throw new FileNotFoundException("File does not exist at path {$path}");
    }

    public function requireOnce($file)
    {
        require_once $file;
    }

    public function hash($path)
    {
        return md5_file($path);
    }

    public function put($path, $contents, $lock = false)
    {
        return file_put_contents($path, $contents, $lock ? LOCK_EX : 0);
    }

    public function prepend($path, $data)
    {
        if ($this->exists($path)) {
            return $this->put($path, $data.$this->get($path));
        }

        return $this->put($path, $data);
    }

    public function append($path, $data)
    {
        return file_put_contents($path, $data, FILE_APPEND);
    }

    public function chmod($path, $mode = null)
    {
        if ($mode) {
            return chmod($path, $mode);
        }

        return substr(sprintf('%o', fileperms($path)), -4);
    }

    public function delete($paths)
    {
        $paths = is_array($paths) ? $paths : func_get_args();

        $success = true;

        foreach ($paths as $path) {
            try {
                if (! @unlink($path)) {
                    $success = false;
                }
            } catch (ErrorException $e) {
                $success = false;
            }
        }

        return $success;
    }

    public function move($path, $target)
    {
        return rename($path, $target);
    }

    public function copy($path, $target)
    {
        return copy($path, $target);
    }

    public function link($target, $link)
    {
        if (! window_os()) {
            return symlink($target, $link);
        }

        $mode = $this->isDirectory($target) ? 'J' : 'H';
        exec("mklink /{$mode} \"{$link}\" \"{$target}\"");
    }

    public function name($path)
    {
        return pathinfo($path, PATHINFO_FILENAME);
    }

    public function basename($path)
    {
        return pathinfo($path, PATHINFO_BASENAME);
    }

    public function dirname($path)
    {
        return pathinfo($path, PATHINFO_DIRNAME);
    }

    public function extension($path)
    {
        return pathinfo($path, PATHINFO_EXTENSION);
    }

    public function type($path)
    {
        return filetype($path);
    }

    public function mimeType($path)
    {
        return finfo_file(finfo_open(FILEINFO_MIME_TYPE), $path);
    }

    public function size($path)
    {
        return filesize($path);
    }

    public function lastModified($path)
    {
        return filemtime($path);
    }

    public function isDirectory($directory)
    {
        return is_dir($directory);
    }

    public function isReadable($path)
    {
        return is_readable($path);
    }

    public function isWritable($path)
    {
        return is_writable($path);
    }

    public function isFile($file)
    {
        return is_file($file);
    }

    public function glob($pattern, $flags = 0)
    {
        return glob($pattern, $flags);
    }

    public function files($directory, $hidden = false)
    {
        return iterator_to_array(
          Finder::create()->files()->ignoreDotFiles(! $hidden)->in($directory)->depth(0)->sortByName(),
          false
        );
    }

    public function allFiles($directory, $hidden = false)
    {
        return iterator_to_array(
          Finder::create()->files()->ignoreDotFiles(! $hidden)->in($directory)->sortByName(),
          false
        );
    }

    public function directories($directory)
    {
        $directories = [];

        foreach (Finder::create()->in($directory)->directories()->depth(0)->sortByName() as $dir) {
            $directories[] = $dir->getPathname();
        }

        return $directories;
    }

    public function makeDirectory($path, $mode = 0755, $recursive = false, $force = false)
    {
        if ($force) {
            return @mkdir($path, $mode, $recursive);
        }

        return mkdir($path, $mode, $recursive);
    }

    public function moveDiretory($from, $to, $overwrite = false)
    {
        if ($overwrite && $this->isDirectory($to)) {
            if (! $this->deleteDirectory($to)) {
                return false;
            }
        }

        return @rename($from, $to) === true;
    }

    public function copyDirectory($directory, $destination, $options = null)
    {
        if (! $this->isDirectory($directory)) {
            return false;
        }

        $options = $options ?: FilesystemIterator::SKIP_DOTS;

        if (! $this->isDirectory($destination)) {
            $this->makeDirectory($destination, 0777, true);
        }

        $items = new FilesystemIterator($directory, $options);

        foreach ($items as $item) {
            $target = $destination.'/'.$item->getBasename();

            if ($item->isDir()) {
                $path = $item->getPathname();

                if (! $this->copyDirectory($path, $target, $options)) {
                    return false;
                }
            } else {
                if (! $this->copy($item->getPathname(), $target)) {
                    return false;
                }
            }
        }

        return true;
    }

    public function deleteDirectory($directory, $preserve = false)
    {
        if (! $this->isDirectory($directory)) {
            return false;
        }

        $items = new FilesystemIterator($directory);

        foreach ($items as $item) {
            if ($item->isDir() && ! $item->isLink()) {
                $this->deleteDirectory($item->getPathname());
            } else {
                $this->delete($item->getPathname());
            }
        }

        if (! $preserve) {
            @rmdir($directory);
        }

        return true;
    }

    public function deleteDirectories($directory)
    {
        $allDirectories = $this->directories($directory);

        if (! empty($allDirectories)) {
            foreach ($allDirectories as $directoryName) {
                $this->deleteDirectory($directoryName);
            }
            
            return true;
        }

        return false;
    }

    public function cleanDirectory($director)
    {
        return $this->deleteDirectory($directory, true);
    }
}
