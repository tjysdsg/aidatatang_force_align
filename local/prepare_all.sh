#!/bin/bash

stage=1

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

if [ $# -ne 1 ]; then
  echo "prepare_all.sh  <corpus-test-dir>"
  exit 1;
fi

if [ ! -d data  ];then
  mkdir data
fi

if [ -d data/local/offline_test ];then
  rm -r data/local/offline_test
fi

if [ -d data/offline_test ];then
  rm -r data/offline_test
fi

tst_set=$1

# genarate wav.scp, text(word-segmented), utt2spk, spk2utt
if [ $stage -le 1 ]; then
  local/prepare_data.sh ${tst_set} data/local/offline_test  data/offline_test  || exit 1;
fi

echo "local/prepare_all.sh succeeded"
exit 0;
