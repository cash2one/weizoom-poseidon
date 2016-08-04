import os

def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)

if __name__ == '__main__':
	touch('./index.js')