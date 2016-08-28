#!/bin/bash

result=$(sed '$!d' test_result.log)
#echo $result
if [ "$result" = "OK" ];
then
  echo "OK";
else
  failedTests=$(echo $result| grep -o -E '[0-9]+')
  if [ $(( $failedTests * 100 / 3)) -gt 10 ];
  then
        #echo $result;
        echo "FAILED";
  else
        # echo $result;
        echo "OK";
  fi
fi
