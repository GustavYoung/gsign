#!/bin/bash

#
# Boolean __isProcessRunning().
#

__isProcessRunning()
{
    running=1
    if [ "$( ps aux | grep $1 | grep -v grep | awk '{print $2}')" <> "0" ]; then
        running=0
    fi

    return $running
}


#
# Void __killProcessName().
#

__killProcessName()
{
    killall $1 >/dev/null 2>&1
}


#
# String __fileName().
# Return filename string (without path).
#

__fileName()
{
    filePath=$1
    echo -n "$filePath" | sed -r -e 's#(.*)/(.*)#\2#'
}


#
# String __cleanFileName().
# Return full filename string (with path); strip non alphanum chars.
#

__cleanFileName()
{
    filePath=$1
    echo -n "$filePath" | sed -r -e 's#(.*)/(.*)#\2#' | sed 's/[^[:alnum:].-]/_/g'
}


#
# String __fileType()
#

__fileType()
{
    filePath=$1
    fileType=""

    if echo $(file "$filePath") | grep -iq "media" || echo $(file "$filePath") | grep -iq "video"; then
        fileType="video"

    elif echo $(file "$filePath") | grep -iq "image"; then
        fileType="image"

    elif echo $(file "$filePath") | grep -iq "text"; then
        fileType="text"
    fi

    echo -n $fileType
}


#
# String __cleanLine().
#

__cleanLine()
{
    echo -n $1 | sed 's/\r//g'
}
