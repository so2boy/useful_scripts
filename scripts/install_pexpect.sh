#!/bin/sh

TMP_DIR=`mktemp -d /tmp/install_pexpect.XXXXX`

cd $TMP_DIR

wget https://bootstrap.pypa.io/ez_setup.py -O - --no-check-certificate | python - --user

wget https://pypi.python.org/packages/source/p/pexpect/pexpect-3.3.tar.gz --no-check-certificate

tar zxf pexpect-3.3.tar.gz

cd pexpect-3.3

python setup.py install --user

cd /

rm -rf $TMP_DIR
