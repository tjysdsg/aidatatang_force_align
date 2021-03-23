#!/bin/bash

. ./path.sh || exit 1;

tmp=
dir=

if [ $# != 3 ]; then
  echo "Usage: $0 <corpus-data-dir> <dict-dir> <tmp-dir> <output-dir>"
  echo " $0 /export/aidatatang/corpus/train data/local/dict data/local/train data/train"
  exit 1;
fi

corpus=$1
tmp=$2
dir=$3

echo "prepare_data.sh: Preparing data in $corpus"

mkdir -p $tmp
mkdir -p $dir

wav_scp=$tmp/wav.scp; [[ -f "$wav_scp" ]] && rm $wav_scp
utt2spk=$tmp/utt2spk; [[ -f "$utt2spk" ]] && rm $utt2spk
spk2utt=$tmp/spk2utt; [[ -f "$spk2utt" ]] && rm $spk2utt

#get wavlist and utt2spk
local/dir_wav_utt.py $corpus $tmp
sort $wav_scp -o $wav_scp
sort $utt2spk -o $utt2spk

#get spk2utt from utt2spk
utils/utt2spk_to_spk2utt.pl $tmp/utt2spk | sort -k 1 | uniq > $tmp/spk2utt

# copy prepared resources from tmp_dir to target dir
mkdir -p $dir
for f in wav.scp spk2utt utt2spk; do
  cp -rf $tmp/$f $dir/$f || exit 1;
done

echo "local/prepare_data.sh succeeded"
exit 0;
