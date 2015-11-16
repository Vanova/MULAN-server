#!/bin/bash

file_id=$1
ext=$2 
file_dir=$3
out_dir=$4

if [ -f path.sh ]; then . ./path.sh; fi

# directory for wav lists
mkdir -p $out_dir || exit 1;

# prepare kaldi scp: [wavID] [file full path]
scp=$out_dir/$file_id.scp
echo $file_id $file_dir/$file_id.$ext > $scp