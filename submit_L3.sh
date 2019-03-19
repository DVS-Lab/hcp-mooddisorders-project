#!/bin/bash


NCORES=12
#for LIST in "Social_Act 2" "Social_PPI 7" "Social_nPPI_DMN 7" "Social_nPPI_ECN 7" "Emotion_Act 2" "Emotion_PPI 7" "WM_Act 2" "WM_PPI 7"; do
for LIST in "Emotion_PPI 7" "Social_Act 2" "Social_PPI 7"; do

  set -- $LIST
  TYPE=$1
  NCOPES=$2

  for COPENUM in `seq $NCOPES`; do
    echo $TYPE $COPENUM
    #Manages the number of jobs and cores
    while [ $(ps -ef | grep -v grep | grep L3.sh | wc -l) -ge $NCORES ]; do
        sleep 1m
    done
    bash L3.sh $TYPE $COPENUM &
	sleep 1
  done
done
