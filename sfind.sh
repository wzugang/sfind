#!/bin/bash

help()
{
    echo """Usage:
    ./sfind.sh dir cmd name str1 str2 str3 ...
Options:
    -o search and display if one of strs is exists.
    -a search and display if all strs in the file."""
    exit 1
}

DIR=$1
CMD=$2
NAME=$3
STR=$4
STRS=$*
ARGN=$#
OLD_IFS="$IFS" 
IFS=" "
ARR=($STRS)
IFS=OLD_IFS


[ $# -lt 4 ] && help
! [ -d "${DIR}" ] && echo "${DIR} not exists." && exit 
[ "$CMD" != "-a" ] && [ "$CMD" != "-o" ] && help

unset ARR[0]
unset ARR[1]
unset ARR[2]

if_have_all()
{
i=3
OBJ=$1
[ "${OBJ}" = "" ] && return
for str in ${ARR[@]} ; do
    RES=$(grep ${str} ${OBJ})
    if [ "$RES" = "" ] ;then
        break
    fi
    let i=$i+1
    if [ ${i} -ge ${ARGN} ] ;then
        echo "${OBJ}"
    fi
done
}

if_have()
{
OBJ=$1
[ "${OBJ}" = "" ] && return
for str in ${ARR[@]} ;do
    RES=$(grep ${str} ${OBJ})
    if [ "$RES" != "" ]; then
        echo "${OBJ}"
        break
    fi
done
}


OBJS=`find $DIR -name "*${NAME}"|xargs echo`

find_and()
{
for file in ${OBJS} ;do
    ! [ -f $file ] && return 1
    if_have_all $file
done
}

find_or()
{
for file in ${OBJS} ;do
    ! [ -f $file ] && return 1
    if_have $file
done
}

search()
{
OLD_IFS="$IFS" 
IFS=" "
[ "$CMD" = "-a" ] && find_and
[ "$CMD" = "-o" ] && find_or
IFS=OLD_IFS
}

search




