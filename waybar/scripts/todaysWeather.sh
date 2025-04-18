#!/bin/sh
weather=$(curl "wttr.in/Delhi?format=%t")
echo "$weather" || exit
