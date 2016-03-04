#!/bin/bash

cd "`dirname "$0"`"

find . -name "*.log" -type f -delete
find . -name "*.out" -type f -delete
find . -name "*.gz" -type f -delete
find . -name "*.toc" -type f -delete
find . -name "*.aux" -type f -delete
find . -name "*.bbl" -type f -delete
find . -name "*.blg" -type f -delete
find . -name "Master.pdf" -type f -delete

osascript -e 'tell application "Terminal" to quit' &
exit