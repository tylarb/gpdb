#!/bin/bash

# Because many utilities lack a .py extension, 2to3 has to be patched to work on all files
# Then we need to remove non-python files so it doesn't have issues there
# To do so, edit /usr/lib64/python2.7/lib2to3/refactor.py, line 316-317, to the following:
#
# if (not name.startswith(".")):# and
# 	  #os.path.splitext(name)[1] == py_ext:
#

set -ex

# Set up working directories
rm -rf /tmp/workdir
mkdir /tmp/workdir

cp -R ./bin /tmp/workdir
cp -R ./sbin /tmp/workdir
cp -R ./test /tmp/workdir

cd /tmp/workdir

# Convert gpMgmt/bin
pushd bin/

rm -f generate-greenplum-path.sh 
rm -f gpinitsystem 
rm -f unittest.log 
rm -rf ext/
rm -rf gpload gpload_test/
rm -rf pythonSrc/
rm -f gpcheckcatc  gpcheckresgroupimplc  gpconfigc  gpdeletesystemc  gpexpandc  gpload.pyc  gpsshc  gpstartc  gpstopc
find . -name "*.ans" -delete
find . -name "*.log" -delete
find . -name "*.out" -delete
find . -name "*.pyc" -delete
find . -name "*.sql" -delete
find . -name "*.yml" -delete
find . -name "*sh" -delete
find . -name "Makefile*" -delete
find . -name "README*" -delete

pushd lib/
rm -f crashreport.gdb *.sh*
rm -rf multidd pexpect/ stream 
popd

pushd src/
rm -rf stream/
popd

popd

# Convert gpMgmt/sbin
pushd sbin/
rm -f Makefile
rm -f *.pyc
popd

# Convert gpMgmt/test
pushd test/

rm -rf ../converted_tests/
rm -f README 
rm -f run_behave.sh 
rm -f run_parse_behave.sh 

pushd behave/mgmt_utils/
rm -f *feature

pushd steps/data/
rm -f data1 global_init_file hybrid_part.data no.txt yes.txt sample.gppkg 
rm -rf gpcheckcat/
popd

popd

pushd behave_utils/
rm -rf configs/
popd

popd

# Run conversion
2to3 --no-diffs -n -o converted -W .

set +ex
echo "Conversion complete.  Please copy files back to gpMgmt with the following command:"
echo "cp -R /tmp/workdir/* ."
