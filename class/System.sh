#!/bin/bash

#
# System class.
#

function System()
{
    base=$FUNCNAME
    this=$1

    # Declare methods.
    for method in $(compgen -A function)
    do
        export ${method/#$base\_/$this\_}="${method} ${this}"
    done

    # Properties list.
    # - Array of strings: imageFiles
    # - Array of strings: videoFiles

    # Source folder: any folder; will be of course the USB key.
    # Media folder: directory to slide media from.
}

# ##################################################################################################################################################
# "Public static" methods
# ##################################################################################################################################################

#
# Void System_slide().
#

function System_slide()
{
    timestamp0=$(date +%s)

    # Hide blinking cursor.
    System_cursorHide

    # Kill running fbi process(es) (if any).
    System_cleanRunningProcesses

    # Empty (clean) the media folder if the source folder contains at least one RS-valid file (image, video or text file).
    System_cleanTargetFolder $SOURCE_FOLDER $MEDIA_FOLDER

    # Copy all image, video and text files from the source folder (if any) into the media folder, with clean file names (no spaces etc).
    System_populateTargetFolderFromSourceFolder $SOURCE_FOLDER $MEDIA_FOLDER

    # Download linked media into (cleaned) $TEMP_MEDIA_FOLDER_REMOTEURLS for the remote-urls functionality (if remote-urls.txt file exists).
    System_populateTempFolderFromRemoteUrls $TEMP_MEDIA_FOLDER_REMOTEURLS "$MEDIA_FOLDER/remote-urls.txt"

    while true; do
        # Read all files in the media and temp media folders and put their path in video/image arrays.
        System_populateDataStructure $MEDIA_FOLDER $TEMP_MEDIA_FOLDER_REMOTEURLS

        # Display video/image arrays' content and refresh timing info.
        if [ "$DEBUG" = "y" ]; then
            System_mediaInformationsShow
            sleep 5
        else
            clear
        fi

        while true; do
            # Slide according to the entries in the arrays.
            if [ "$(System_videoNumber)" -eq "0" ]; then 
                System_playImagesForever
            else
                System_playAllOnce
            fi
        done
    done
}

# ##################################################################################################################################################
# "Private static" methods
# ##################################################################################################################################################

#
# Void System_cursorHide().
#

function System_cursorHide()
{
    echo -e '\033[?17;0;0c' > /dev/tty1
    echo -e '\033[?17;0;0c' > /dev/tty2
}


#
# Void System_cleanTargetFolder().
#

function System_cleanTargetFolder()
{
    sourceFolder=$1
    targetFolder=$2

    sourceContainingFiles="n"
    for sourceFile in ${sourceFolder}/*; do
        sourceFileType=$(__fileType "$sourceFile")

        if [ "$sourceFileType" == "video" ] || [ "$sourceFileType" == "image" ]; then
            sourceContainingFiles="y"
        fi
        if [ "$sourceFileType" == "text" ]; then
            if echo $sourceFile | grep -iq "remote"; then
                sourceContainingFiles="y"
            fi
        fi
    done

    if [ "$sourceContainingFiles" == "y" ]; then
        echo si es necesario purgar folder manualmente. #rm -fR ${targetFolder}/*
    fi
}


#
# Void System_populateTargetFolderFromSourceFolder().
#

function System_populateTargetFolderFromSourceFolder()
{
    sourceFolder=$1
    targetFolder=$2

    for sourceFile in ${sourceFolder}/*; do
        sourceFileType=$(__fileType "$sourceFile")

        if [ "$sourceFileType" == "video" ] || [ "$sourceFileType" == "image" ] || [ "$sourceFileType" == "text" ]; then
            cp -f "$sourceFile" ${targetFolder}/$(__cleanFileName "$sourceFile") >/dev/null 2>&1
        fi
    done
}


#
# Void System_populateTempFolderFromRemoteUrls().
#

function System_populateTempFolderFromRemoteUrls()
{
    tempMediaFolder=$1
    remoteUrlsFile=$2

    cd $tempMediaFolder
    rm -f $tempMediaFolder/*

    if [ -f $remoteUrlsFile ]; then
        while read -r line; do
            if [ "$line" != "" ]; then
                lineCleaned=$(__cleanLine $line)

                if [ "$DEBUG" = "y" ]; then
                    wget $lineCleaned
                else
                    wget $lineCleaned >/dev/null 2>&1
                fi
            fi
        done <<< "$(cat $remoteUrlsFile)"

        # Clean file names (no spaces).
        for tmpWorkingFile in ${tempMediaFolder}/*; do
            mv -f "$tmpWorkingFile" ${tempMediaFolder}/$(__cleanFileName "$tmpWorkingFile") >/dev/null 2>&1
        done
    fi
}


#
# Void System_cleanRunningProcesses().
#

function System_cleanRunningProcesses()
{
    if (__isProcessRunning "fbi"); then
        __killProcessName "fbi" >/dev/null 2>&1
    fi
}


#
# Void System_populateDataStructure().
#

function System_populateDataStructure()
{
    mainWorkingFolder=$1
    tempWorkingFolder1=$2

    declare -g imageFiles
    declare -g videoFiles
    imageFiles=()
    videoFiles=()

    # For every file in all folders.
    workingFolders=($mainWorkingFolder $tempWorkingFolder1)
    for workingFolder in ${workingFolders[@]}; do
        for workingFile in ${workingFolder}/*; do
            workingFileType=$(__fileType "$workingFile")

            if [ "$workingFileType" == "video" ]; then
                # Insert the file path in the video array $videoFiles[].
                videoFiles=(${videoFiles[@]} "$workingFile")

            elif [ "$workingFileType" == "image" ]; then
                # Insert the file path in the image array $imageFiles[].
                imageFiles=(${imageFiles[@]} "$workingFile")
            fi
        done
    done
}


#
# Void System_mediaInformationsShow().
#

function System_mediaInformationsShow()
{
    echo "The following images will be slided:"
    for i in "${imageFiles[@]}"; do
        echo -n " * "; echo $(__fileName "$i")
    done
    printf "\n\n"

    echo "The following videos will be slided:"
    for i in "${videoFiles[@]}"; do
        echo -n " * "; echo $(__fileName "$i")
    done
    printf "\n\n"
}


#
# Void System_videoNumber().
#

function System_videoNumber()
{
    videoNumber=0
    for i in "${videoFiles[@]}"; do
        let videoNumber=videoNumber+1
    done

    echo -n $videoNumber
}


#
# Void System_playAllOnce().
#

function System_playAllOnce()
{
    # Play images in alphabetical order (fullpath); passing FBI the file with the list of all files to play.
    # FBI daemonizes itself, so adding a sleep timing, wtf!
    imageFilesList=""
    imageFilesNumber=0
    vFilesNumber=0

    fbiListFile="/tmp/fbi.list"
    if [ -f $fbiListFile ]; then
        rm -f $fbiListFile
    fi

    for i in "${imageFiles[@]}"; do
        [ "$imageFilesNumber" -lt "5" ] && echo $i >> $fbiListFile
        let imageFilesNumber=imageFilesNumber+1
    done

    if [ "$imageFilesNumber" -gt "0" ]; then
        let imageTime_ms=TRANSITION_TIME_S*1000
        let imageTime_ms=imageTime_ms+BLEND_TIME_MS
        let sleepTime_ms=imageFilesNumber*imageTime_ms
        let sleepTime_s=sleepTime_ms/1000

        if [ "$DEBUG" = "y" ]; then
           $IMAGE_PLAYER $fbiListFile
        else
            $IMAGE_PLAYER $fbiListFile >/dev/null 2>&1 | clear
        fi

        sleep $sleepTime_s

        if [ "$DEBUG" = "y" ]; then
            System_cleanRunningProcesses
        else
            System_cleanRunningProcesses >/dev/null 2>&1 | clear
        fi
    fi

    # Play videos in alphabetical order (fullpath). Videos are played after all images playback.
    # Jessie build of Omxplayer does not daemonize.
    for v in "${videoFiles[@]}"; do
        if [ "$vFilesNumber" -lt "5" ]; then
            if [ "$DEBUG" = "y" ]; then
                $VIDEO_PLAYER $v
            else
                $VIDEO_PLAYER $v >/dev/null 2>&1 | clear
            fi
            let vFilesNumber=vFilesNumber+1
        fi
    done
}


#
# Void System_playImagesForever().
#

function System_playImagesForever()
{
    # Play images in alphabetical order (fullpath); passing FBI the file with the list of all files to play.
    # FBI daemonizes itself, so adding an infinite sleep timing.
    imageFilesList=""
    imageFilesNumber=0

    fbiListFile="/tmp/fbi.list"
    if [ -f $fbiListFile ]; then
        rm -f $fbiListFile
    fi

    for i in "${imageFiles[@]}"; do
        [ "$imageFilesNumber" -lt "5" ] && echo $i >> $fbiListFile
        let imageFilesNumber=imageFilesNumber+1
    done

    if [ "$imageFilesNumber" -gt "0" ]; then
        if [ "$DEBUG" = "y" ]; then
           $IMAGE_PLAYER_IMAGES_ONLY $fbiListFile
        else
            $IMAGE_PLAYER_IMAGES_ONLY $fbiListFile >/dev/null 2>&1 | clear
        fi

        sleep 365d
    fi
}
