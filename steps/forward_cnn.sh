#!/bin/bash

if [ -f path.sh ]; then . ./path.sh; fi

fscp=$1
cmvn=$2
trans=$3
nnet=$4
outfile=$5

feats="ark:copy-feats scp:$fscp ark:- | apply-cmvn --print-args=false --norm-vars=true scp:$cmvn ark:- ark:- | add-deltas --delta-order=2 ark:- ark:- |"

# check files exist
required="$trans $nnet $fscp $cmvn"
for f in $required; do
  if [ ! -f $f ]; then
    echo "[error] forward_cnn.sh: no such file $f"
    exit 1;
  fi
done

# extract scores using trained CNN model
nnet-forward --feature-transform=$trans $nnet "$feats" ark,t:- > $outfile

[ ! -f $outfile ] && echo "[error] something went wrong..." && exit 1;
echo "[info] attribute scores are successfully extracted: $outfile";
