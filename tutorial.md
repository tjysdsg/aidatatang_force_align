## About

This is a Mandarin language ASR system trained on 1505 hours Chinese Mandarin corpus released by DataTang (aidatatang_1505zh). The language model was trained from a large number of colloquial texts.

The aidatatang_1505zh corpus can be free download from [here](<https://www.datatang.com/webfront/opensource.html>). 

## Turorial

1. Install Kaldi, refer to the steps [here](<https://github.com/datatang-ailab/aidatatang_200zh/blob/master/README.md>).

2. Download and untar [DataTang TDNN Chain Model](<http://kaldi-asr.org/models/m10>).

3. Move the untarred directory to kaldi/egs.

4. Go to kaldi/egs/aidatatang_asr, create symlinks to /steps/ and /utils/ like this:

   ```shell
   ln -s ../wsj/s5/steps/ steps
   ln -s ../wsj/s5/utils/ utils
   ```

5. Download the aidatatang_1505zh or set your own corpus to WAVpath.

6. Run the model like this:

   ```shell
   ./run.sh WAVpath
   ```

7. Check the recognition results like this:

   ```shell
   vi exp/chain/tdnn_1a_sp/decode_offline_test_*/rec_*.txt
   ```

   There are samples of the recognition results:

   ```
   T0055G0036S0005 来 一部 好看 的 电影
   T0055G0036S0006 我要 拍摄 二维码 啊
   T0055G0036S0007 播放 原来 你 什么 都 不 想要
   T0055G0036S0008 一月 十一日 上午 十八点 提醒 我
   T0055G0036S0009 你 不是 要 给 我 讲个 笑话 吗
   T0055G0036S0010 家 里面 有 一个 小白兔
   ```

   