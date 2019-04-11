#!/bin/bash


for task in Gam Soc; do
  for subj in `cat Subject_Numbers.txt`; do
  	for RUN in LR RL; do
  		#Manages the number of jobs and cores
  		SCRIPTNAME=L1_${task}_PPI.sh
  		NCORES=22
  		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
  	  		sleep 1m
  		done
  		bash $SCRIPTNAME $RUN $subj &
  		sleep 1s

  	done
  done
done
