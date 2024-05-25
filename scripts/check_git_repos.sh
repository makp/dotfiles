#!/bin/bash

dir="$1"

if [ -z "$dir" ]; then
    dir="$(pwd)"
else
    # Change dir but exit if it fails
    cd $dir || exit
fi


# Loop over all subdirectories
# The `find` cmd will recursively find all .git directories (the opt `-type d`
# ensures that only directories are returned).  The `while` reads each line
# of the output of the `find` command into the var `gitdir`.
find . -type d -name ".git" | while read -r gitdir; do
    repo_dir=$(dirname $gitdir)
    echo "Checking $repo_dir"

    mod=0
    pushd "$repo_dir" > /dev/null || exit

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u} 2> /dev/null || echo "no-remote")
    BASE=$(git merge-base @ @{u} 2> /dev/null || echo "no-base")


    # Check for modified files
    if ! git diff --quiet; then
	mod=1
	echo -en "\033[0;31m"
	echo "Modified files"
	echo -en "\033[0m"
    fi

    # Check for staged but uncommitted files
    if ! git diff --cached --quiet; then
	mod=1
	echo -en "\033[0;31m"
	echo "Staged files"
	echo -en "\033[0m"
    fi

    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
	mod=1
	echo -en "\033[0;31m"
	echo "Untracked files"
	echo -en "\033[0m"
    fi

    # Check remote
    if [ "$REMOTE" = "no-remote" ]; then
	echo -en "\033[0;31m"
	echo "No remote branch"
	echo -en "\033[0m"
    elif [ "$BASE" = "no-base" ]; then
	echo -en "\033[0;31m"
	echo "No common base"
	echo -en "\033[0m"
    elif [ "$LOCAL" = "$REMOTE" ]; then
        echo "Up-to-date"
    elif [ "$LOCAL" = "$BASE" ]; then
	mod=1
	echo -en "\033[0;31m"
        echo "Need to push"
	echo -en "\033[0m"
    else
	mod=1
	echo -en "\033[0;31m"
        echo "Diverged"
	echo -en "\033[0m"
    fi

    popd > /dev/null || exit
    echo
done
