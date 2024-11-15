#!/bin/bash

echo "Checking if Factorio exists"
if [ ! -f "${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio/bin/x64/factorio" ]; then
    echo "Factorio does not exist, downloading..."
    if [[ -z $FACTORIO_USERNAME || -z $FACTORIO_TOKEN ]]; then
        echo "Could not authenticate, cannot download without authentication, please confirm that environment variables FACTORIO_USERNAME & FACTORIO_TOKEN are set correctly"
        echo "Current:"
        echo "  FACTORIO_USERNAME: '$FACTORIO_USERNAME'"
        echo "  FACTORIO_TOKEN: '$FACTORIO_TOKEN'"
        echo "Exiting..."
        exit
    fi
    curl "https://www.factorio.com/get-download/${RELEASE_VERSION:-"latest"}/${RELEASE_TYPE:-"alpha"}/linux64?username=$FACTORIO_USERNAME&token=$FACTORIO_TOKEN" -L -o /root/factorio-linux64.tar.xz
    echo "Extracting..."
    tar xvf /root/factorio-linux64.tar.xz -C ${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"} && mkdir -p ${MAPSHOT_FACTORIO_DATA_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"}/mods && echo '{}' >${MAPSHOT_FACTORIO_DATA_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"}/mods/mod-list.json
else
    echo "Factorio exists, proceeding without download"
fi

MAPSHOT_SAVE_NAME=$(basename "$FACTORIO_SAVE" .zip)
MAPSHOT_SCRIPT_OUTPUT_DIR=${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio/script-output/mapshot/$MAPSHOT_SAVE_NAME

# Delete old d-* folders except the latest one
if [ -d "$MAPSHOT_SCRIPT_OUTPUT_DIR" ]; then
    echo "Cleaning up old d-* directories..."
    cd "$MAPSHOT_SCRIPT_OUTPUT_DIR"
    ls -dt d-* | tail -n +2 | xargs rm -rf
    echo "Cleanup complete."
else
    echo "No previous mapshot directories to clean."
fi

if [ "$MAPSHOT_MODE" == "render" ]; then
    echo 'Mapshot mode set to "render", rendering map...'
    # Surfaces can be "nauvis"
    timeout $MAPSHOT_INTERVAL xvfb-run -a mapshot render --logtostderr --factorio_binary ${MAPSHOT_FACTORIO_BINARY_PATH:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio/bin/x64/factorio"} --factorio_datadir ${MAPSHOT_FACTORIO_DATA_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"} --work_dir ${MAPSHOT_WORKING_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"} --area ${MAPSHOT_AREA:-"all"} --tilemin ${MAPSHOT_MINIMUM_TILES:-64} --tilemax ${MAPSHOT_MAXIMUM_TILES:-0} --jpgquality ${MAPSHOT_JPEG_QUALITY:-90} --minjpgquality ${MAPSHOT_MINIMUM_JPEG_QUALITY:-90} --surface ${MAPSHOT_SURFACES_TO_RENDER:-"_all_"} ${MAPSHOT_VERBOSE_FACTORIO_LOGGING:-"--factorio_verbose"} -v ${MAPSHOT_VERBOSE_MAPSHOT_LOG_LEVEL_INT:-9 } $FACTORIO_SAVE
elif [ "$MAPSHOT_MODE" == "serve" ]; then
    mapshot serve --factorio_binary ${MAPSHOT_FACTORIO_BINARY_PATH:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio/bin/x64/factorio"} --factorio_datadir ${MAPSHOT_FACTORIO_DATA_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"} --work_dir ${MAPSHOT_WORKING_DIRECTORY:-"${MAPSHOT_ROOT_DIRECTORY:-"/mapshot"}/factorio"}
else
    echo 'Mapshot mode set to "serve", serving map...'
    echo 'Please set environment variable $MAPSHOT_MODE to "render" or "serve", exiting..'
fi
