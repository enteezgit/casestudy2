#!/bin/bash

nohup Xvfb :10 -ac &
export DISPLAY=:10
firefox --safe-mode &

python test.py $1 $2 $3

result=$(sed '$!d' test_result.log)
#echo $result
if [ "$result" = "OK" ];
then
  echo "OK" > result.txt
else
  failedTests=$(echo $result| grep -o -E '[0-9]+')
  if [ $(( $failedTests * 100 / 3)) -gt 10 ];
  then
        #echo $result;
        echo "FAILED" > result.txt
  else
        # echo $result;
        echo "OK" > result.txt
  fi
fi
