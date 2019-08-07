#!/bin/bash

for item in `cat significant_list.txt` ; do
	fslmaths $item -thr 1.3010 thresh_$item >> palm_output_roi_thresholded.txt
done