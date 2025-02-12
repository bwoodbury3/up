#!/bin/bash

function _up_help() {
    echo "up [count | dir]"
    echo "  no argument: Go up one directory"
    echo "  count:       Go up this many directories"
    echo "  dir:         Go up until you hit this parent directory"
}

function up() {
    if [[ $# -gt "1" ]]; then
        _up_help
        return 1
    fi

    arg=$1
    case $arg in
        # Argument is empty
        "")
            echo "cd .."
            cd ..
            ;;

        # Argument is a positive number
        [0-9]*)
            # Sane upper bound to prevent bash from spinning
            if [[ $arg -gt "2048" ]]; then
                echo "cd /"
                cd /
                return 0
            fi;

            # Otherwise blindly traverse upwards
            dir="."
            while [[ $arg -gt "0" ]]; do
                dir="$dir/.."
                arg="$(($arg-1))"
            done
            echo "cd $dir"
            cd $dir
            ;;

        # Argument is a string
        *)
            dir=$(pwd)
            while : ; do
                if [[ "$(basename "${dir}")" = "${arg}" ]]; then
                    echo "cd -- ${dir}"
                    cd -- "${dir}"
                    return 0
                fi

                [[ "${dir}" != "/" ]] || break
                dir=$(dirname "${dir}");
            done

            echo "Parent directory not found: ${arg}"
            return -1
            ;;
    esac
}
