#!/bin/bash
task=Social
copenum=1
rm -rf L3_PPI_input${task}_${copenum}.txt
for subj in `cat Subject_Numbers.txt`; do
	echo /data/projects/ppi-effect-sizes/fsl/${subj}/MNINonLinear/Results/L2_${task}_PPI_vmpfc.gfeat/cope${copenum}.feat/stats/cope1.nii.gz  >>  L3_PPI_input${task}_${copenum}.txt
	if [ ! -e /data/projects/ppi-effect-sizes/fsl/${subj}/MNINonLinear/Results/L2_${task}_PPI_vmpfc.gfeat/cope${copenum}.feat/stats/cope1.nii.gz ]; then
		echo "MISSING: /data/projects/ppi-effect-sizes/fsl/${subj}/MNINonLinear/Results/L2_${task}_PPI_vmpfc.gfeat/cope${copenum}.feat/stats/cope1.nii.gz"
	fi
done
