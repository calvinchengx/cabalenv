#!/usr/bin/env bash

_checkenvvar() {
	if [[ ! -n "${HS_PROJ_HOME}" ]]; then
	  echo "Please set your haskell project directory home HS_PROJ_HOME environment."
	fi
}

_checkenvexists() {
	local res="$(lscabalenv)"
	echo "Checking if $1 is already present"
	string=$(find $HS_PROJ_HOME -name .cabal-sandbox  2>/dev/null | xargs -I{} dirname {} | xargs -I{} basename {});
	arr=(${(f)string})  # This works only for zsh
	for i in $arr; do
		if [[ $i == $1 ]]; then
			echo $1" already exists."
			return 0
		fi
	done
	echo $1" does not exist."
	return 0
}

_removeoldpath() {
	local string=$PATH
	old_arr=(${(s/:/)string})  # This works only for zsh
	new_arr=""
	for i in $old_arr; do
		if [[ ! $i =~ "$1" ]]; then
			new_arr=${new_arr:+$new_arr:}$i
		fi
	done
	echo $new_arr
}

cabalenv() {
	echo "A Haskell Cabal sandbox environment utility."

	# no sandbox name?
	if  [[ -z "$1" ]]; then
		   echo "Please provide your Cabal sandbox name."
		return 0
	fi

	# given sandbox name, does it exist?
	local res="$(_checkenvexists $1)"
	if [[ $res == *"already exists"* ]]; then
		# sandbox exist: 
		# cd into it 
		# remove the previous .cabal-sandbox line in $PATH, if any
		# set $HS_PROJ_HOME/[given sandbox name]/.cabal-sandbox/bin to $PATH

		# remove old .cabal-sandbox path from $PATH and clear the cabal name in $PROMPT
		PATH="$(_removeoldpath .cabal-sandbox)"
		unset CABAL_ENV
		PROMPT=$(echo $PROMPT | sed -e 's|\[cabal: .*\] ||g')

		export CABAL_ENV=$1
		echo "Switching to "$CABAL_ENV
		PATH=$HS_PROJ_HOME/$CABAL_ENV/.cabal-sandbox/bin:$PATH
		PROMPT="[cabal: "$CABAL_ENV"] "$PROMPT 
		cd $HS_PROJ_HOME/$CABAL_ENV
		return 0
	else
		# sandbox do not exist
		echo $res
		return 0
	fi
}

lscabalenv() {
	local res="$(_checkenvvar)"
	if [[ ! -z $res ]]; then 
		echo $res
		return 1
	else
		string=$(find $HS_PROJ_HOME -name .cabal-sandbox  2>/dev/null | xargs -I{} dirname {} | xargs -I{} basename {});
		echo $string;
		arr=(${(f)string})  # This works only for zsh
		return 0
	fi
}

_findtarget() {
    dir=$PWD
    target="cabal.sandbox.config"
    while [[ ! -e $dir/$target && $dir != "/" ]]; do
        dir=${dir%/*}
        [[ $dir = "/" ]] && return 1
    done
}

# Wrapper function for runhaskell 
# that automatically detects a cabal sandbox and passes the package db value to the -package-db flag
runhaskells() {
    if _findtarget; then
        local db=$(sed -ne '/^package-db: */{s///p;q;}' "$dir/$target")
        runhaskell -no-user-package-db -package-db="$db" "$@"
    else
        runhaskell "$@"
    fi
}

# Wrapper function for ghc
# that automatically detects a cabal sandbox and passes the package db value to the -package-db flag
ghcs() {
    if _findtarget; then
        local db=$(sed -ne '/^package-db: */{s///p;q;}' "$dir/$target")
        ghc -no-user-package-db -package-db="$db" "$@"
    else
        ghc "$@"
    fi
}

# Wrapper function for ghci
# that automatically detects a cabal sandbox and passes the package db value to the -package-db flag
ghcis() {
    if _findtarget; then
        local db=$(sed -ne '/^package-db: */{s///p;q;}' "$dir/$target")
        ghci -no-user-package-db -package-db="$db" "$@"
    else
        ghci "$@"
    fi
}
