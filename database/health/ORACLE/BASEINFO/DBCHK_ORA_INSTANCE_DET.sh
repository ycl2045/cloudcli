#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 2012/8/14
###This script is a health check script of oracle database
###排除用户指定的instance，不对其检查
#############################################################


cat $log_dir/DBCHK_ORA_INSTANCE_RES.out
