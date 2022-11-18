#!/bin/bash
# A runner for tests that adds timestamps and, in CI, anchors in logs
test="$1"
printf '\n\nStarting "./%s --verbose" at %(%c)T\n' "$test" -1
if [ "$CI" = true ] ; then
  WARN_PREFIX="::warning::"
  ERR_PREFIX="::error::"
else
  WARN_PREFIX="Warning: "
  ERR_PREFIX="Error: "
fi
#
./"$test" --verbose
result="$?"
if [ "$result" = 1 ] ; then
  echo "${WARN_PREFIX}Failure in test $test"
else if [ "$result" '!=' 0 ] ; then
  case "$result" in
    139)
      echo "${ERR_PREFIX}SIGSEGV in test $test"
      kill -SIGSEGV $$
      ;;
    135)
      echo "${ERR_PREFIX}SIGBUS in test $test"
      kill -SIGBUS $$
      ;;
    137)
      echo "${ERR_PREFIX}SIGKILL in test $test"
      kill -SIGKILL $$
      ;;
    *)
      echo "${ERR_PREFIX}Result $result in test $test"
      ;;
  esac
fi
fi
exit "$result"
