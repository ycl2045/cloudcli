#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_PRESER_DET.sh           #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查登陆日志大小                        #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0		
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_PRESER_RES.out
fi

