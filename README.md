# CabalEnv

A simple `zsh` script that works with `cabal sandbox` initialised in the same directory as the project directory.  

## Usage

`lscabalenv` returns a list of directory names.  

When a particular `.cabal-sandbox/bin` path is in `$PATH`, the `$CABAL_ENV` environment variable will be assigned its parent directory name (which we simply refer to as the cabal environment name) and the `$PROMPT` will also be updated to show the cabal environment name.

To begin working on a project, simply run

`cabalenv THE_CABAL_ENVIRONMENT_NAME`

This `cabalenv` function will update 

* `$PATH` with `THE_CABAL_ENVIRONMENT_NAME`'s cabal sandbox path
* set `$CABAL_ENV`
* update `$PROMPT` with `THE_CABAL_ENVIRONMENT_NAME`

## Installation

`cd /usr/local/bin && sudo wget https://raw.githubusercontent.com/calvinchengx/cabalenv/master/cabalenv.sh && sudo chmod +x cabalenv.sh`

## Current Limitations, i.e. TODOs

* Does not support *shared* cabal sandboxes yet.
* Only works on `zsh`.  Will support `bash` in due course.
* A simple command to get out of current cabal environment.
* Package it for `brew` and for `port`, perhaps.