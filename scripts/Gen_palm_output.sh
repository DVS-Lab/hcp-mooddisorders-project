#!/bin/bash

ls PALM*nii > palm_output_roi.txt

rm -f palm_output_roi_STATS.txt || true

for item in `cat palm_output_roi.txt` ; do
	fslstats $item -R >> palm_output_roi_STATS.txt
done

filenames=palm_output_roi.txt
tstats=palm_output_roi_STATS.txt

paste $filenames $tstats > final_results_roi.csv

#here is my first iteration of this script

#contrast=9

#ls PALM*c${contrast}* > palm_output_c${contrast}.txt

#rm -f palm_output_c${contrast}_STATS.txt || true

#for item in `cat palm_output_c${contrast}.txt` ; do
#	fslstats $item -R >> palm_output_c${contrast}_STATS.txt
#done

#filenames=palm_output_c${contrast}.txt
#tstats=palm_output_c${contrast}_STATS.txt

#paste $filenames $tstats > both_contrast${contrast}.csv