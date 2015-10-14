#!/bin/sh

OLD_DIR=`pwd`

TMP_DIR=`mktemp -d /tmp/install_pip.XXXXX`

cd $TMP_DIR

wget https://bootstrap.pypa.io/ez_setup.py -O - --no-check-certificate | python - --user

wget https://pypi.python.org/packages/source/p/pip/pip-7.1.0.tar.gz#md5=d935ee9146074b1d3f26c5f0acfd120e --no-check-certificate

tar zxf pip-7.1.0.tar.gz

cd pip-7.1.0

python setup.py install --user

cd /

rm -rf $TMP_DIR

echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc

source ~/.bashrc

pip install --user pexpect

pip install --user requests

cd $OLD_DIR
