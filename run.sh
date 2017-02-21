#!/bin/bash
printenv | sed 's/^\(.*\)$/export \1/g' | grep -E "^export ART" > project_env.sh

sh project_env.sh
echo "ID,Pressure,Temperature" > logs.csv

for X1 in $(seq 0 ${ART_DURATION})
#for X1 in {0 .. $ART_DURATION}
do
   ID=$((RANDOM % (1024) ))
   #for X2 in {0 .. $ART_ARRIVALRATE}
   for X2 in $(seq 0 ${ART_ARRIVALRATE})
   do
     PRESSURE=$((RANDOM % (860-720+1) +720 ))
     TEMPERATURE=$((RANDOM % (120) - 20 ))
     echo "$ID,$PRESSURE,$TEMPERATURE" >> logs.csv
   done
done

if [ ! -z "$ORION_PORT_1026_TCP_ADDR" ]
then
 export ART_TARGET=http://$ORION_PORT_1026_TCP_ADDR:$ORION_PORT_1026_TCP_PORT
fi

envsubst < contextBroker.yml.template > contextBroker.yml

DEBUG=$ART_DEBUG

export DEBUG

npm start
