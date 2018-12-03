
usage() { echo "Usage: $0 [-c <channel name>] [-i <app id>] [-u <uid>] [-k <channel key>] [-s <session id>]" 1>&2; exit 1; }

while getopts ":c:i:u:k:s:" o; do
    case "${o}" in
        c)
            CHANNEL_NAME=${OPTARG}
            ;;
        i)
            APP_ID=${OPTARG}
            ;;
        k)
            CHANNEL_KEY=${OPTARG}
            ;;
        u)
            recorder=${OPTARG}
            ;;
        s)
            session_id=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


TS=$session_id

if [ -z "${CHANNEL_NAME}" ] || [ -z "${APP_ID}" ] || [ -z "${session_id}" ]; then
    usage
else
    #ok to go
    # ps aux | grep -ie  Agora_EDU_Recording_SDK_for_Linux/samples/cpp/release/bin/recorder\ --appid\ ${APP_ID}.*\ --channel\ ${CHANNEL_NAME}.*\ | awk '{print $2}' | xargs kill -s 2

    #Setup config path
    [ -d ./output ] || mkdir ./output
    rm -rf ./output/${APP_ID}-${CHANNEL_NAME}-${TS}
    [ -d ./output/${APP_ID}-${CHANNEL_NAME}-${TS} ] || mkdir ./output/${APP_ID}-${CHANNEL_NAME}-${TS}
    echo {\"Recording_Dir\":\"`pwd`/output/${APP_ID}-${CHANNEL_NAME}-${TS}\"} > ./output/${APP_ID}-${CHANNEL_NAME}-$
    echo "Setup config path completed"
    
    #Setup recording path
    recordingRootPath = "/var/www/html/recording"
    thisRecordingSessionFolderName = "${APP_ID}-${CHANNEL_NAME}-${TS}"
    thisRecordingSessionFolderPath = "${recordingRootPath}/${recordingSessionFolderNamel̥}/"

    [ -d $recordingRootPath ] || mkdir $recordingRootPath
    rm -rf $thisRecordingSessionFolderPath
    [ -d $thisRecordingSessionFolderPath ] || mkdir $thisRecordingSessionFolderPath
    echo "Setup recording path completed"

    SCRIPT="nohup ./Agora_EDU_Recording_SDK_for_Linux/samples/cpp/release/bin/recorder --appId ${APP_ID} --channel ${CHANNEL_NAME} --recordFilrRootDir $thisRecordingSessionFolderPath --appliteDir `pwd`/Agora_EDU_Recording_SDK_for_Linux/bin/ --channelProfile 1 --isMixingEnabled 1 --mixedVideoAudio 2 --idle 60"
    if [ -z "${CHANNEL_KEY}" ]; then
        echo "KEY_NOT_ENABLED"
    else
        SCRIPT="${SCRIPT} --channelKey ${CHANNEL_KEY}"
    fi
    SCRIPT="${SCRIPT} >> ./log/recorder.log 2>&1 &"
    echo $SCRIPT
    eval $SCRIPT
    echo $! > "$thisRecordingSessionFolderPath/pid"
    cat "$thisRecordingSessionFolderPath.log"
fi