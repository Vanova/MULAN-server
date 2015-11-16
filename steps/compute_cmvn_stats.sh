#!/bin/bash

if [ -f path.sh ]; then . ./path.sh; fi

fbankscp=$1
fname=$2
logdir=$3
cmvndir=$4

! compute-cmvn-stats scp:$fbankscp ark,scp,t:$cmvndir/${fname}_cmvn.ark,$cmvndir/${fname}_cmvn.scp \
    2> $logdir/${fname}_cmvn.log && echo "Error computing CMVN stats" && exit 1;

echo "Succeeded creating CMVN stats for $fbankscp"
