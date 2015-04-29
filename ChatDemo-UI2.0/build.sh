#!/bin/sh

## global variables
MAKE=make
MAKE_FLAGS=-j8


## user customizable variables. 
SDK_VERSION=8.1
TARGET_NAME=ChatDemo-UI2.0
CONFIGURATION=Release

ROOT=.
DIST=dist
BUILD=build
PAYLOAD=Payload

BUILD_DIR=${ROOT}/${BUILD}/${CONFIGURATION}-iphoneos
TARGET_DIR=${BUILD_DIR}/${TARGET_NAME}.app

## clean 
rm -rf ${ROOT}/${BUILD}
rm -rf ${ROOT}/${PAYLOAD}
rm -rf ${ROOT}/${DIST}
mkdir ${ROOT}/${DIST}

## prepare sdk directory
sh ${ROOT}/preparesdk.sh

## make 
${MAKE} ${MAKE_FLAGS} target_name=${TARGET_NAME} sdk_version=${SDK_VERSION} configuration=${CONFIGURATION}
ERROR=$?
if [ $ERROR -gt 0 ]; then
	echo 'Failed to build project!' 'target_name='${TARGET_NAME} 'sdk_version='${SDK_VERSION} 'configuration='${CONFIGURATION}
    exit $ERROR
fi

## create dist directory
mkdir -p ${ROOT}/${PAYLOAD}
cp -r ${TARGET_DIR} ${ROOT}/${PAYLOAD}

## make ipa
zip -r ${ROOT}/${TARGET_NAME}.zip ${ROOT}/${PAYLOAD}
mv ${ROOT}/${TARGET_NAME}.zip ${ROOT}/${DIST}/${TARGET_NAME}.ipa
cp -r ${TARGET_DIR}.dSYM ${ROOT}/${DIST}/${TARGET_NAME}.app.dSYM
# delete Payload directory
rm -rf ${ROOT}/${PAYLOAD}
# write version info
GIT_REVISION="`git rev-list HEAD -n 1`"
GIT_BRANCH="`git rev-parse --abbrev-ref HEAD`"
VERSION_INFO="`date '+%Y%m%d'`_`date '+%H%M%S'`_${GIT_BRANCH}_${GIT_REVISION}"
touch ${ROOT}/${DIST}/${VERSION_INFO}.txt

