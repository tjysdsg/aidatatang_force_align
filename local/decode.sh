#!/bin/bash

set -e
model_dir=$1
decode_dir=$2
stage=2
nj=$3

# End configuration section.
echo "$0 $@"  # Print the command line for logging

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

# we use 40-dim high-resolution mfcc feature for test wav
test_sets="offline_test"

#step1 make mfcc feature
if [ $stage -le 1 ]; then
  mfccdir=mfcc_hires
  for datadir in ${test_sets}; do
  	utils/copy_data_dir.sh data/${datadir} data/${datadir}_hires
	steps/make_mfcc.sh --write-utt2dur false --mfcc-config conf/mfcc_hires.conf --nj $nj --cmd "$train_cmd" data/${datadir}_hires exp/make_mfcc/ ${mfccdir}
  done
fi

#step2 decode with mfcc feature
graph_dir=$model_dir/graph
if [ $stage -le 2 ]; then
  for test_set in $test_sets; do
    steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 \
      --nj $nj --cmd "$decode_cmd" \
      --skip-scoring true --num-threads 10 \
      $graph_dir data/${test_set}_hires $decode_dir || exit 1;
  done
fi

echo "local/chain/run_tdnn.sh succeeded"
exit 0;
