#!/bin/bash

basedir=`pwd`
MAINDATADIR=/data/projects/ppi-effect-sizes/data
MAINOUTPUTDIR=/data/projects/ppi-effect-sizes/fsl

task=GAMBLING
run=$1
subj=$2

OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act
DATA=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/smoothing.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
NVOLUMES=`fslnvols ${DATA}`

# checking L1 output
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
  #echo "output exists, skipping...."
  exit
else
	echo "re-running $subj $run $task" >> re-runL1.log 
  rm -rf ${OUTPUT}.feat
fi

#EV files
EVDIR=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/EVs


#find and replace: run feat for smoothing
ITEMPLATE=${basedir}/templates/L1_Gam_Act.fsf
OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}/L1_Gam_Act.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
<$ITEMPLATE> $OTEMPLATE
feat $OTEMPLATE

# fix registration
rm -rf ${OUTPUT}.feat/reg
mkdir -p ${OUTPUT}.feat/reg
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
ln -s $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz

#delete unused files
#rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
