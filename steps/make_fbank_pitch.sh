#!/bin/bash

# Begin config
fbank_config=conf/fbank_cnn.conf
pitch_config=conf/pitch_cnn.conf
paste_length_tolerance=2
compress=true
# End config

echo "$0 $@"  # Print the command line for logging

if [ -f path.sh ]; then . ./path.sh; fi

scp=$1
arkfile=$2
logdir=$3
fbankdir=$4

mkdir -p $fbankdir || exit 1;
mkdir -p $logdir || exit 1;

# check wav lists and configuration exists
required="$scp $fbank_config $pitch_config"
for f in $required; do
  if [ ! -f $f ]; then
    echo "make_fbank_pitch.sh: no such file $f" && exit 1;
  fi
done

fbank_feats="ark:compute-fbank-feats --verbose=2 --config=$fbank_config scp,p:$scp ark:- |"
pitch_feats="ark,s,cs:compute-kaldi-pitch-feats --verbose=2 --config=$pitch_config scp,p:$scp ark:- | process-kaldi-pitch-feats ark:- ark:- |"

! paste-feats --length-tolerance=$paste_length_tolerance "$fbank_feats" "$pitch_feats" ark:- | \
  copy-feats --compress=$compress ark:- \
  ark,scp,t:$fbankdir/$arkfile.ark,$fbankdir/$arkfile.scp 2> $logdir/$arkfile.log \
  && echo "Error computing fbank features" && exit 1;

echo "Succeeded creating filterbank & pitch features for $scp"
