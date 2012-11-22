#!/bin/sh

# create new erlang project based on this template

PROJ_NAME=$1
if [ -z $PROJ_NAME ]; then
    echo "usage: ./clone.sh PROJ_NAME [DESTINATION]"
    exit 0
fi

DESTINATION=$2
if [ -z $DESTINATION ]; then
    DESTINATION=~/p
fi

DIR=$DESTINATION/$PROJ_NAME

echo "Clonning to $DIR"
mkdir -p $DIR
cp -r ./* $DIR
cp .gitignore $DIR

cd $DIR
rm clone.sh
echo "# $PROJ_NAME\n\nproject description here" > README.md

sed s:"-s some_app start":"-s ${PROJ_NAME}_app start": Makefile > Makefile.tmp
mv Makefile.tmp Makefile

cd src
sed s:"{application, some":"{application, $PROJ_NAME": some.app.src > some.app.src.tmp
sed s:"{mod, {some":"{mod, {$PROJ_NAME": some.app.src.tmp > ${PROJ_NAME}.app.src
rm some.app.src some.app.src.tmp

sed s:"-module(some":"-module($PROJ_NAME": some_app.erl > some_app.erl.tmp
sed s:"application\:start(some)":"application\:start($PROJ_NAME)": \
some_app.erl.tmp > ${PROJ_NAME}_app.erl
rm some_app.erl some_app.erl.tmp

exit 0