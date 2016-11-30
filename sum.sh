#!/bin/bash
FILE=$1

awk '{sum += $1};END {print sum}' ${FILE}

/* ${FILE}:
# vim test
 46
 28
 43
 35
 27
 32
 23
 21

# awk '{sum += $1};END {print sum}' test
 255
*/
