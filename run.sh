#!/bin/bash
# set your testing data path
wav_dir=data/test_2k
nj=8
stage=1
vdate=`date +%Y%m%d`

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

# prepare test data
if [ $stage -le 1 ]; then
  utils/subset_data_dir.sh --first data/test 2000 data/test_2k
  local/prepare_all.sh ${wav_dir} || exit 1;
fi

# decoding
if [ $stage -le 2 ]; then
  local/decode.sh exp/chain/tdnn_1a_sp exp/chain/tdnn_1a_sp/decode_offline_test_$vdate $nj
fi
#get recognition result from decode log
if [ $stage -le 3 ]; then
   cat exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/log/decode.*.log > exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/decode_$vdate.log
   local/extract_decode_log.py exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/decode_$vdate.log exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/rec_$vdate.txt
fi

echo "recognition result in exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/rec_$vdate.txt"
exit 0;
