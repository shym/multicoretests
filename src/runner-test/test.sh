#!/bin/bash
case "$1" in        #
  true)             #
    exit 0          #
    ;;              #
  false)            #
    exit 1          #
    ;;              #
  kill)             #
    kill -KILL $$   #
    ;;              #
  segv)             #
    kill -SEGV $$   #
    ;;              #
  bus)              #
    kill -SIGBUS $$ #
    ;;              #
  *)                #
    kill -TERM $$   #
    ;;              #
esac                #
