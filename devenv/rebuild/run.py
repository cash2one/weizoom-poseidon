# -*- coding: utf-8 -*-

import subprocess
import os

def invoke(command):
	print '***** start output for `%s` *****' % command
	p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
	while True:
		line = p.stdout.readline()
		if not line:
			break
		print '\t', line
	print '***** finish output for %s *****' % command

def run():
	print '[rebuild] start...'
	cmd = "bash devenv/rebuild/rebuild.sh"
	invoke(cmd)

if __name__ == '__main__':
	if '_IS_WEIZOOM_DEV_VM' in os.environ:
		run()
		print '[rebuild] done.'
	else:
		print 'not in weizoom dev vm, do nothing'
