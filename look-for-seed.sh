#!/bin/bash
# bash because we need pipefail

OCAMLRUN="${OCAMLRUN:-ocamlrun}"
BYTECODE="${1:-effect_lin_tests_dsl.bc}"

set -o pipefail
export CI=true
for i in $(seq 10000); do
  if ! seed="$($OCAMLRUN "$BYTECODE" -v | awk '/random seed/ { print $3 }')"; then
    # is it reproducible?
    if $OCAMLRUN "$BYTECODE" -v -s "$seed"; then
      printf 'Seed %s not robust\n' "$seed";
    else
      printf 'Failure reproduced with seed %s\n' "$seed"
      break
    fi
  fi
done


