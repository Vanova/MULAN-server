#!/bin/bash

#set -x
#trap read debug
# test run: ./run.sh test-data/wav/GEcall-109-G.story-bt.wav
#inputfile=test-data/wav/GEcall-109-G.story-bt.wav

. ./path.sh

inputfile=$1
proc_dir=tmp-data
proc_list=$proc_dir/lists
fbank_dir=$proc_dir/data-fbank

# 0. prepare data
ext=wav
file_dir=$(dirname $inputfile)
file_id=$(basename $inputfile ".$ext")

steps/data_prep.sh $file_id $ext $file_dir $proc_list

# 1. extract log mel-filter bank features
steps/make_fbank_pitch.sh  $proc_list/$file_id.scp $file_id $fbank_dir/log $fbank_dir
steps/compute_cmvn_stats.sh $fbank_dir/$file_id.scp $file_id $fbank_dir/log $fbank_dir

# 2. forward data through the Neural Network and producing scores
# for manner
outfile=$file_dir/$file_id.manner
trans=model/manner/fbank_to_splice_cnn4c_4_128.trans
nnet=model/manner/cnn4c_4_128.nnet
steps/forward_cnn.sh $fbank_dir/$file_id.scp $fbank_dir/${file_id}_cmvn.scp $trans $nnet $outfile
# for place
outfile=$file_dir/$file_id.place
trans=model/place/fbank_to_splice_cnn4c_3_128.trans
nnet=model/place/cnn4c_3_128.nnet
steps/forward_cnn.sh $fbank_dir/$file_id.scp $fbank_dir/${file_id}_cmvn.scp $trans $nnet $outfile

echo "[info] attributes scores successfully extracted...";
