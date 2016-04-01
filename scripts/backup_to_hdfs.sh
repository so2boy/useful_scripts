#!/bin/sh

if [ "$1" == "" ]; then
    echo "Usage: $0 <backup_dir>"
    exit 1
fi

cd $1

HOSTNAME=`hostname`
IP=`host $HOSTNAME | awk '{print $4}'`
export JAVA_HOME="/usr/jdk_home/"
export HADOOP_USER_NAME=yumeng
HDFS="/serving/hadoop/hadoop-2.6.0/bin/hdfs dfs"

TAR_NAME=$IP`pwd | sed 's/\//_/g'`".tgz"

find -L . -maxdepth 2 -name bin > dirs.txt
find -L . -maxdepth 2 -name conf >> dirs.txt

DIRS=`cat dirs.txt`
echo "Tar to $TAR_NAME"
tar zcf $TAR_NAME $DIRS

TIMESTAMP=`date +"%Y%m%d_%H%M%S"`
HDFS_PATH="/user/yumeng/backup/disk/"$TAR_NAME"_"$TIMESTAMP
echo "Upload $TAR_NAME to hdfs $HDFS_PATH"
$HDFS -copyFromLocal $TAR_NAME $HDFS_PATH
rm -vf $TAR_NAME
rm -vf dirs.txt

$HDFS -ls "/user/yumeng/backup/disk/${TAR_NAME}_*" | awk '{print $8}' | sort > old_backups.txt
BACKUP_CNT=`cat old_backups.txt | wc -l`
if [ $BACKUP_CNT -gt 2 ]; then
    echo "Clean old backup"
    let CLEAN_CNT=$BACKUP_CNT-2
    for old_backup in `head -n $CLEAN_CNT old_backups.txt`; do
        $HDFS -rm $old_backup
    done
fi
rm -vf old_backups.txt
