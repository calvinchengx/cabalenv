# CabalEnv

A simple `zsh` script that works with `cabal sandbox` initialised in the same directory as the project directory.  

## Usage

`lscabalenv` returns a list of directory names that contain `.cabal-sandbox`.  In the context of our `cabalenv` utility, we refer to these directory names as **cabal environment names**. 

When a particular `.cabal-sandbox/bin` path is in `$PATH`, the `$CABAL_ENV` environment variable will be assigned the cabal environment name and the `$PROMPT` will also be updated to show the cabal environment name.

To begin working on a project, simply run

`cabalenv THE_CABAL_ENVIRONMENT_NAME`

This `cabalenv` function will update 

* `$PATH` with `THE_CABAL_ENVIRONMENT_NAME`'s cabal sandbox path
* set `$CABAL_ENV` with the current cabal environment name
* update `$PROMPT` with `THE_CABAL_ENVIRONMENT_NAME`

## Installation

`cd /usr/local/bin && sudo wget https://raw.githubusercontent.com/calvinchengx/cabalenv/master/cabalenv.sh && sudo chmod +x cabalenv.sh`

In your `~/.zprofile`, specify

```
export HS_PROJ_HOME=$HOME/work
source `which cabalenv.sh`
```

where `work` is just a place where I create all my haskell project directories in.  You don't have to use `work` of course.

## Current Limitations, i.e. TODOs

* Does not support *shared* cabal sandboxes yet.
* Only works on `zsh`.  Will support `bash` in due course.
* A simple command to get out of current cabal environment.
* Package it for `brew` and for `port`, perhaps.