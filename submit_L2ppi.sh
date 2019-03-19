#!/bin/bash



for task in Gam WM Emo Soc; do
  for subj in `cat EuniceSubs.txt`; do

    #Manages the number of jobs and cores
    SCRIPTNAME=L2_${task}_PPI.sh
    NCORES=42
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
      sleep 1m
    done
    bash $SCRIPTNAME $subj &
    sleep 1s

  done
done

