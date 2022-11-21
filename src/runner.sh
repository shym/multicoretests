#!/bin/bash
# A runner for tests that adds timestamps and, in CI, anchors in logs
# All lines end as comments since bash on Windows CI seems to conjure
# some '\r' it doesn’t like into existence
test="$1"                                                     #
printf '\n\nStarting "./%s --verbose" in %s\n' "$test" "$PWD" #
if [ "$CI" = true ] ; then                                    #
  WARN_PREFIX="::warning::"                                   #
  ERR_PREFIX="::error::"                                      #
else                                                          #
  WARN_PREFIX="Warning: "                                     #
  ERR_PREFIX="Error: "                                        #
fi                                                            #
                                                              #
./"$test" --verbose                                           #
result="$?"                                                   #
case "$result" in                                             #
  0)                                                          #
    exit 0                                                    #
    ;;                                                        #
  1)                                                          #
    echo "${WARN_PREFIX}Failure in test $test"                #
    exit 1                                                    #
    ;;                                                        #
  139)                                                        #
    echo "${ERR_PREFIX}SIGSEGV in test $test"                 #
    kill -SIGSEGV $$                                          #
    ;;                                                        #
  135)                                                        #
    echo "${ERR_PREFIX}SIGBUS in test $test"                  #
    kill -SIGBUS $$                                           #
    ;;                                                        #
  137)                                                        #
    echo "${ERR_PREFIX}SIGKILL in test $test"                 #
    kill -SIGKILL $$                                          #
    ;;                                                        #
  *)                                                          #
    echo "${ERR_PREFIX}Result $result in test $test"          #
    exit "$result"                                            #
    ;;                                                        #
esac                                                          #
