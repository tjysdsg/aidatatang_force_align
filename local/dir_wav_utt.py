#!/usr/bin/env python
# encoding=utf-8


import sys
import os
import re
indir = sys.argv[1]
outdir = sys.argv[2]

#get wav list
def get_all_file(rawdir):
	allfile = []
	for root,dirs,files in os.walk(rawdir):
		for f in files:
			if(re.search('wav$',f)):
				allfile.append(os.path.join(root,f))
		for dirname in dirs:
			get_all_file(os.path.join(root,dirname))
	return allfile

files = get_all_file(indir)
for wavfile in files:
	itt = os.path.splitext(os.path.basename(wavfile))[0]
	with open(os.path.join(outdir,"wav.scp"),"a") as w1:
		w1.write(str(itt)+" "+str(wavfile)+"\n")

	with open(os.path.join(outdir,"utt2spk"),"a") as w2:
		w2.write(str(itt)+" "+str(itt)+"\n")
