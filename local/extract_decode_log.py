#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re

logfile=sys.argv[1]
outfile=sys.argv[2]
f = open(logfile,'r')
for line in f:
	#print(line)
	pattern = re.compile(u"[\u4e00-\u9fa5]")
	match = re.search(pattern,line.decode('utf8'))
	#print(match)
	if match:
		#print(line)
		with open(outfile, 'a') as w:
			w.write(line)
