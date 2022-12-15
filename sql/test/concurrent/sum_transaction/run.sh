#!/bin/bash


SKDB=../../../../build/skdb

rm -f /tmp/test.db

$SKDB --init /tmp/test.db

cat create.sql | $SKDB --data /tmp/test.db

for i in {1..100}
do
    cat inserts.sql | $SKDB --data /tmp/test.db &
done
wait

echo "SELECT * FROM t1;" | $SKDB --data /tmp/test.db  > /tmp/test_result
sum=`cat /tmp/test_result | egrep '^[0-9]+$' | awk '{x += $1} END {print x}'`

if [[ sum -eq 2054 ]]
then
   echo -e "CONCURRENT SUM:\tOK"
else
    echo -e "CONCURRENT SUM:\tERROR"
fi

