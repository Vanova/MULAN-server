#!/bin/bash

wavdir=$1

if [ -f path.sh ]; then . ./path.sh; fi

# directory for wav lists
listdir=data/lists
mkdir -p $listdir || exit 1;

wavlist=$listdir/waves.list
scp=$listdir/waves.scp

# read wav file names in data folder
ls -1 $wavdir > $wavlist

if [ ! -f $wavlist ]; then
  echo "[error] there are no waves in $wavdir" && exit 1;  
fi

# iterate waves list and prepare kaldi scp: [wavID] [file full path]
while read line; do
	fn=$wavdir/$line  
  [ ! -f "$fn" ] && echo "[error] no such wav file..." && exit 1;
  echo ${line%.*} $fn
done < $wavlist > $scp;

cat $scp | sort -u -k1,1 -o $scp

echo "$0: data prepared successfully"
