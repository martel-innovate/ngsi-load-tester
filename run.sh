#!/bin/bash
printenv | sed 's/^\(.*\)$/export \1/g' | grep -E "^export ART" > project_env.sh

sh project_env.sh
echo "ID,Pressure,Temperature" > logs.csv

loop=$((${ART_DURATION} * ${ART_RAMPTO}))

awk -v loop=$loop -v range=$loop 'BEGIN{
  srand()
  do {
    numb = 1 + int(rand() * range)
    if (!(numb in prev)) {
       pressure = 720 + int(rand() * 140)
       temperature = -20 + int(rand() * 60)
       print numb "," pressure "," temperature >> "logs.csv"
       prev[numb] = 1
       count++
    }
  } while (count<loop)
}'

if [ ! -z "$ORION_PORT_1026_TCP_ADDR" ]
then
 export ART_TARGET=http://$ORION_PORT_1026_TCP_ADDR:$ORION_PORT_1026_TCP_PORT
fi

envsubst < contextBroker.yml.template > contextBroker.yml

DEBUG=$ART_DEBUG

export DEBUG

npm start
