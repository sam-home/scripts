#!/bin/bash

TYPE=$1
OPERATION=$2
FILE=$3

if [ -z $TYPE ] || [ -z $OPERATION ] || [ -z $FILE ]; then
	echo "Usage: sh chver.sh <major|minor|patch> <up|down> <file>"
	exit
fi

VERSION=$(node -pe "require('./$FILE').version")

MAJOR=$(echo $VERSION | cut -d'.' -f1)
MINOR=$(echo $VERSION | cut -d'.' -f2)
PATCH=$(echo $VERSION | cut -d'.' -f3)

if [ $OPERATION == "up" ]; then
	if [ $TYPE == "major" ]; then
	MAJOR=$(($MAJOR + 1))
	elif [ $TYPE == "minor" ]; then
	MINOR=$(($MINOR + 1))
	elif [ $TYPE == "patch" ]; then
	PATCH=$(($PATCH + 1))
	fi
elif [ $OPERATION == "down" ]; then
	if [ $TYPE == "major" ]; then
	MAJOR=$(($MAJOR - 1))
	elif [ $TYPE == "minor" ]; then
	MINOR=$(($MINOR - 1))
	elif [ $TYPE == "patch" ]; then
	PATCH=$(($PATCH - 1))
	fi
fi

NEW_VERSION=$MAJOR.$MINOR.$PATCH

gsed -i "s/\"version\":\s\"$VERSION\"/\"version\": \"$NEW_VERSION\"/g" $FILE
