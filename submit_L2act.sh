#!/bin/bash


for task in Emo Gam WM Soc; do
  for subj in `cat EuniceSubs.txt`; do

    #Manages the number of jobs and cores
    SCRIPTNAME=L2_${task}_Act.sh
    NCORES=40
    while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
      sleep 1m
    done
    bash $SCRIPTNAME $subj &
    sleep 1s

  done
done

