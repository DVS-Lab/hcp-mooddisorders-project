#!/bin/bash

basedir=`pwd`
MAINDATADIR=/data/projects/ppi-effect-sizes/data
MAINOUTPUTDIR=/data/projects/ppi-effect-sizes/fsl

task=SOCIAL
run=$1
subj=$2

OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Social_PPI_vmpfc
DATA=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Social_Act.feat/filtered_func_data.nii.gz
NVOLUMES=`fslnvols ${DATA}`

# checking L1 output
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
  echo "output exists, skipping...."
  exit
else
  echo "missing output for $subj $task " >> re-runL1_ppi.log
  rm -rf ${OUTPUT}.feat
fi

#EV files
EVMENTAL=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/mental.txt
EVRND=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs/rnd.txt

#generate mask's timecourse
MASK=${basedir}/masks/vmPFC_ROI_social_reward.nii.gz
TIMECOURSE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/my_timecourse.txt
fslmeants -i $DATA -o $TIMECOURSE -m $MASK

#find and replace: run feat for smoothing
ITEMPLATE=${basedir}/templates/L1_SOC_PPI.fsf
OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Social_PPI.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@EVMENTAL@'$EVMENTAL'@g' \
-e 's@EVRND@'$EVRND'@g' \
-e 's@TIMECOURSE@'$TIMECOURSE'@g' \
<$ITEMPLATE> $OTEMPLATE
feat $OTEMPLATE

#delete unused files
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
