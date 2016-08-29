#!/bin/bash

nohup Xvfb :10 -ac &
export DISPLAY=:10
firefox --safe-mode &

python test.py $1 $2 $3

result=$(sed '$!d' test_result.log)
echo $result
#Write the number of failed cases to the result.txt
if [ "$result" = "OK" ];
then
  failedTests=0
else
  failedTests=$(echo $result| grep -o -E '[0-9]+')
fi
echo $failedTests > result.txt
