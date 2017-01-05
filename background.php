#!/usr/bin/php
<?php 
class BackgroundProcess {
    static function open($exec, $cwd = null) {
        if (!is_string($cwd)) {
                $cwd = @getcwd();
        }

        @chdir($cwd);

        if (strtoupper(substr(PHP_OS, 0, 3)) == 'WIN') {
                $WshShell = new COM("WScript.Shell");
                $WshShell->CurrentDirectory = str_replace('/', '\\', $cwd);
                $WshShell->Run($exec, 0, false);
        } else {
                exec($exec . " > /var/log/gammu/halopolisisms 2>&1 &");
        }
    }

    static function fork($phpScript, $phpExec = null) {
        $cwd = dirname($phpScript);

        if (!is_string($phpExec) || !file_exists($phpExec)) {
                if (strtoupper(substr(PHP_OS, 0, 3)) == 'WIN') {
                        $phpExec = str_replace('/', '\\', dirname(ini_get('extension_dir'))) . '\php.exe';

                        if (@file_exists($phpExec)) {
                                BackgroundProcess::open(escapeshellarg($phpExec) . " " . escapeshellarg($phpScript), $cwd);
                        }
                } else {
                        $phpExec = exec("which php-cli");

                        if ($phpExec[0] != '/') {
                                $phpExec = exec("which php");
                        }

                        if ($phpExec[0] == '/') {
                                BackgroundProcess::open(escapeshellarg($phpExec) . " " . escapeshellarg($phpScript), $cwd);
                        }
                }
        } else {
                if (strtoupper(substr(PHP_OS, 0, 3)) == 'WIN') {
                        $phpExec = str_replace('/', '\\', $phpExec);
                }

                BackgroundProcess::open(escapeshellarg($phpExec) . " " . escapeshellarg($phpScript), $cwd);
        }
    }
}

BackgroundProcess::fork('adisms.halopolisi.php');

?>

