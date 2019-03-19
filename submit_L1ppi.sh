#!/bin/bash


for task in Gam Emo Soc WM; do
  for subj in `cat EuniceSubs.txt`; do
  	for RUN in LR RL; do
  		#Manages the number of jobs and cores
  		SCRIPTNAME=L1_${task}_PPI.sh
  		NCORES=32
  		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
  	  		sleep 1m
  		done
  		bash $SCRIPTNAME $RUN $subj &
  		sleep 1s

  	done
  done
done
