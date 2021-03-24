#!/bin/bash
# set your testing data path
wav_dir=data/test
nj=8
stage=1
vdate=`date +%Y%m%d`

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
  local/decode.sh exp/chain/tdnn_1a_sp exp/chain/tdnn_1a_sp/decode_offline_test_$vdate $nj
fi
# get recognition result from decode log
if [ $stage -le 3 ]; then
   cat exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/log/decode.*.log > exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/decode_$vdate.log
   # local/extract_decode_log.py exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/decode_$vdate.log exp/chain/tdnn_1a_sp/decode_offline_test_$vdate/rec_$vdate.txt
fi

model_dir=exp/chain/tdnn_1a_sp
output_dir=$model_dir/decode_offline_test_$vdate

for i in $(seq 1 $nj); do
  zcat $output_dir/lat.$i.gz  > $output_dir/lat.$i
  lattice-1best --acoustic-scale=1 ark:$output_dir/lat.$i ark:$output_dir/1best.$i.lats
  nbest-to-linear ark:$output_dir/1best.$i.lats ark,t:$output_dir/$i.ali 
  ali-to-phones --ctm-output $model_dir/final.mdl ark:$output_dir/$i.ali $output_dir/phone.$i.ctm
done

cat $output_dir/phone.*.ctm > phone.ctm
python ali_to_phone.py $model_dir/phones.txt phone.ctm phone_ctm.txt

exit 0