#!/bin/bash
# A runner for tests that adds timestamps and, in CI, anchors in logs
# All lines end as comments since bash on Windows CI seems to conjure
# some '\r' it doesn’t like into existence
test="$1"                                                                   #
warning() {                                                                 #
if [ "$CI" = true ] ; then                                                  #
  printf '\n::warning title=%s::%s in %s/%s' "$1" "$2" "${PWD##*/}" "$test" #
else                                                                        #
  printf '\nWarning: %s in %s/%s' "$2" "${PWD##*/}" "$test"                 #
fi                                                                          #
}                                                                           #
error() {                                                                   #
if [ "$CI" = true ] ; then                                                  #
  printf '\n::error title=%s::%s in %s/%s' "$1" "$2" "${PWD##*/}" "$test"   #
else                                                                        #
  printf '\nError: %s in %s/%s' "$2" "${PWD##*/}" "$test"                   #
fi                                                                          #
}                                                                           #
                                                                            #
if [[ "$2" = "" ]] ; then                                                   #
  printf '\n\nStarting "./%s --verbose" in %s\n' "$test" "${PWD##*/}"       #
  ./"$test" --verbose                                                       #
  result="$?"                                                               #
else                                                                        #
  shift                                                                     #
  printf '\n\nStarting "./%s %s" in %s\n' "$test" "$*" "${PWD##*/}"         #
  ./"$test" "$@"                                                            #
  result="$?"                                                               #
fi                                                                          #
case "$result" in                                                           #
  0)                                                                        #
    exit 0                                                                  #
    ;;                                                                      #
  1)                                                                        #
    warning "Test failure"                                                  #
    exit 1                                                                  #
    ;;                                                                      #
  139)                                                                      #
    error SIGSEGV SIGSEGV                                                   #
    kill -SIGSEGV $$                                                        #
    ;;                                                                      #
  135)                                                                      #
    error SIGBUS SIGBUS                                                     #
    kill -SIGBUS $$                                                         #
    ;;                                                                      #
  137)                                                                      #
    error SIGKILL SIGKILL                                                   #
    kill -SIGKILL $$                                                        #
    ;;                                                                      #
  *)                                                                        #
    error "$result" "Result $result"                                        #
    exit "$result"                                                          #
    ;;                                                                      #
esac                                                                        #
