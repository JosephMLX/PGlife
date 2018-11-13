#!/usr/bin/python3
import sys
import os

for tmp_file in os.listdir(os.getcwd()):
	print("<a href=\""+tmp_file+"\">"+tmp_file+"</a>")
