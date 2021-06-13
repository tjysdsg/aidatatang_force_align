#!/bin/bash
# set your testing data path
wav_dir=data/test
nj=10
stage=1
output_ctm=false

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

# prepare test data
if [ $stage -le 1 ]; then
  # utils/subset_data_dir.sh --first data/test 10000 data/test_subset
  local/prepare_all.sh ${wav_dir} || exit 1;
fi

# decoding
if [ $stage -le 2 ]; then
  local/decode.sh exp/chain/tdnn_1a_sp exp/chain/tdnn_1a_sp/decode_offline_test $nj
fi

model_dir=exp/chain/tdnn_1a_sp
output_dir=$model_dir/decode_offline_test

if [ $stage -le 3 ]; then
  for i in $(seq 1 $nj); do
    zcat $output_dir/lat.$i.gz  > $output_dir/lat.$i
    lattice-1best --acoustic-scale=1 ark:$output_dir/lat.$i ark:$output_dir/1best.$i.lats || exit 1
    nbest-to-linear ark:$output_dir/1best.$i.lats ark,t:$output_dir/$i.ali || exit 1
    
    ctm_opts=
    if [ "$output_ctm" = true ]; then
        ctm_opts="--ctm-output"
    fi
    ali-to-phones ${ctm_opts} $model_dir/final.mdl ark:$output_dir/$i.ali ark,t:$output_dir/text.$i || exit 1
  done
fi

if [ $stage -le 4 ]; then
  if [ "$output_ctm" = true ]; then
    cat $output_dir/phone.*.ctm > phone.ctm
    python ali_to_phone.py $model_dir/phones.txt phone.ctm phone_ctm.txt || exit 1
    echo "Find phone alignments and timestamps in phone_ctm.txt"
  else
    cat $output_dir/text.* > exp/trans.int
    utils/int2sym.pl -f 2- $model_dir/phones.txt exp/trans.int > exp/trans.txt
    echo "Find predicted phone transcripts in exp/trans.txt"
  fi
fi

if [ $stage -le 5 ]; then
  steps/scoring/score_kaldi_cer.sh data/test $model_dir/graph $output_dir
fi

grep WER $output_dir/cer_*| utils/best_wer.sh 2>/dev/null

exit 0