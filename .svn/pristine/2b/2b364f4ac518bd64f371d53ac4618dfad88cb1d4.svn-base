#!/usr/bin/python

import sys, os, re, commands, pprint
from string import Template

def checkInput(source):
    fname = os.path.basename(source)
    if (fname == ''):
        print "ERROR - No file name specified!"
        return 1
    else:
        if(os.path.exists(source) == 1):
            print "... Compiling '"+source+"'...\n"
            return 0
        else:
            print "ERROR - '"+source+"' is not a valid filename!"
            return 1

def smart_into_file(tmpname, lines, tag):
	tmpw = open('tmpw', 'w')
	file = open(tmpname,'r')
	tmplines = file.readlines()
	for tmpline in tmplines:
		if tag in tmpline:
			tmpw.write(lines)
		else:
			tmpw.write(tmpline)
	file.close()
	tmpw.close()
	commands.getstatusoutput('rm ' + tmpname)
	commands.getstatusoutput('mv ' + 'tmpw ' + tmpname)

def smart_replace_file(tmpname, nline, line):
	tmpw = open('tmpw', 'w')
	file = open(tmpname,'r')
	tmplines = file.readlines()
	index = 0
	for tmpline in tmplines:
		if index == nline:
			tmpw.write(line)
		else:
			tmpw.write(tmpline)
		index = index + 1
	file.close()
	tmpw.close()
	commands.getstatusoutput('rm ' + tmpname)
	commands.getstatusoutput('mv ' + 'tmpw ' + tmpname)

def smart_insert_file(tmpname, nline, line):
	tmpw = open('tmpw', 'w')
	file = open(tmpname,'r')
	tmplines = file.readlines()
	index = 0
	for tmpline in tmplines:
		if index == nline:
			tmpw.write(line)
		tmpw.write(tmpline)
		index = index + 1
	file.close()
	tmpw.close()
	commands.getstatusoutput('rm ' + tmpname)
	commands.getstatusoutput('mv ' + 'tmpw ' + tmpname)


def file_insert(tmpname, position, content, Type=0):
	tmpw = open('tmpw', 'w')
	file = open(tmpname,'r')
	tmplines = file.readlines()
	index = 0
	for tmpline in tmplines:
		if index == position:
			tmpw.write(content)
			if Type == 0:
				tmpw.write(tmpline)
		else:
			tmpw.write(tmpline)
		index = index + 1
	file.close()
	tmpw.close()
	commands.getstatusoutput('rm ' + tmpname)
	commands.getstatusoutput('mv ' + 'tmpw ' + tmpname)

def File_Search(tmpname_src, KeyStr):
	file = open(tmpname_src,'r')
	lines = file.readlines()
	ret = []
	flag = 0
	nline = 0
	for line in lines:
		if KeyStr in line:
			flag = 1
			ret.append([nline,line])
		nline = nline + 1
	file.close()
	if flag ==1:
		return ret
	else:
		return 0

def SETTINGS(PNAME, FNAME, PPATH, FPATH, EPATH):
	# Settings
	print "-> Settings"
	#print os.getcwd();
	os.chdir('config');
	#print os.getcwd();
	tmpline = 'PLATFORM_BOARD = ' + PNAME + ' ;\n';
	#print tmpline
	smart_into_file('settings', tmpline, 'PLATFORM_BOARD');
	os.chdir('../');

def JAM(PNAME, FNAME, PPATH, FPATH, EPATH):
	# jam
	print "-> jam"
	#print os.getcwd();
	cmd = 'jam clobber && jam -q'
	#print cmd
	commands.getstatusoutput(cmd);

def IMPACT(PNAME, FNAME, PPATH, FPATH, EPATH):
	# download
	print "-> impact"
	os.chdir(PPATH+'/design/');
	#print os.getcwd();
	cmd = 'impact -batch etc/download.cmd'
	#print cmd
	commands.getstatusoutput(cmd);
	os.chdir('../../../../../');

def COMPILE(PNAME, FNAME, PPATH, FPATH, EPATH):
	# compile
	print "-> Compile";
	#print os.getcwd();
	cmd = './hcompile.py ' + FPATH;
	#print cmd
	commands.getstatusoutput(cmd);

def DOWNLOAD(PNAME, FNAME, PPATH, FPATH, EPATH):
	# download program
	print "-> Download";
	cmd = './microblaze_download.sh ' + EPATH + ' 0';
	#print cmd
	commands.getstatusoutput(cmd);

# --- main --- #
def main():
	# --- Read number of arguments --- #
	num_args = len(sys.argv)
	if num_args >= 3:
		# --- Save the source file name --- #
		PNAME = sys.argv[1]
		FNAME = sys.argv[2]
	else:
		# --- Insufficient number of args, exit with error --- #
		print "Incorrect argument usage!! Aborting..."
		sys.exit(1)
	# --- Your Own Code is Here --- #
	
	PPATH = 'src/platforms/xilinx/'+PNAME;
	FPATH = 'src/test/heterogeneous/' + FNAME + '.c';
	EPATH = 'test/system/' + FNAME;
	
	#ARRAY_SIZE	= ["4080", "4080", "4080", "4080", "4080", "4080"];
	#ARRAY_SIZE	= ["4080", "2040", "1360", "1020", "816 ", "680 "];
	#ARRAY_SIZE	= ["4096", "2048", "1024", "512 ", "256 ", "128 ", "64 ", "32 "];
	#ARRAY_SIZE	= ["4096", "4096", "4096", "4096", "4096", "4096"];

	#ARRAY_SIZE	= ["7140", "3570", "2380", "1785", "1428", "1190"];
	#CPUS		= ["1   ", "2   ", "3   ", "4   ", "5   ", "6   "];

	#ARRAY_SIZE	= ["7140", "3570", "2380", "1785", "1428", "1190", "6120", "3060", "2040", "1530", "1224", "1020", "5100", "2550", "1700", "1275", "1020", "850 ", "4080", "2040", "1360", "1020", "816  ", "680 ", "3060", "1530", "1020", "765 ", "612 ", "510 ", "2040", "1020", "680 ", "510 ", "408 ", "340 ", "1020", "510 ", "340 ", "255 ", "204 ", "170 "];
	#CPUS		= ["1   ", "2   ", "3   ", "4   ", "5   ", "6   ", "1   ", "2   ", "3   ", "4   ", "5   ", "6   ", "1   ", "2   ", "3   ", "4   ", "5   ", "6   ", "1   ", "2   ", "3   ", "4   ", "5    ", "6   ", "1   ", "2   ", "3   ", "4   ", "5   ", "6   ", "1   ", "2   ", "3   ", "4   ", "5   ", "6   ", "1   ", "2   ", "3   ", "4   ", "5   ", "6   "];

	#ARRAY_SIZE	= ["64  ", "128 ", "512 ", "1024", "2048", "3072", "4096"];
	#CPUS		= ["1   ", "1   ", "1   ", "1   ", "1   ", "1   ", "1   "];
	ARRAY_SIZE	= ["64  ", "128 "];
	CPUS		= ["1   ", "1   "];
	nn		= 3;

	#SETTINGS(PNAME, FNAME, PPATH, FPATH, EPATH);
	#JAM(PNAME, FNAME, PPATH, FPATH, EPATH);
	#IMPACT(PNAME, FNAME, PPATH, FPATH, EPATH);

	for k in range(len(ARRAY_SIZE)):
		print "-> ",str(k)
		# Modify *.c
		print "->-> Modify *.c"
		tmpline = '#define ARRAY_SIZE ' + ARRAY_SIZE[k] + '\n';
		smart_into_file(FPATH, tmpline, '#define ARRAY_SIZE');
		tmpline = '#define CPUS ' + CPUS[k] + '\n';
		smart_into_file(FPATH, tmpline, '#define CPUS');

		for j in range(nn):
			tmpline = '#define nn ' + str(j+1) + '\n';
			smart_into_file(FPATH, tmpline, '#define nn');
			# Run
			print "->->-> Run: ARRAY_SIZE:" + ARRAY_SIZE[k] + " CPUs:" + CPUS[k] + " nn:" + str(j)
			cmd = './t.py ' + PNAME + ' ' + FNAME + ' 3'
			commands.getstatusoutput(cmd);
	
	print "Done!\n"
	# --- End --- #
if __name__ == "__main__":
	main()
