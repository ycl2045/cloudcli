#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_CPU_RES.sh              #
# 作  者:iomp_zcw		                         #
# 日  期:2014年 2月18日                          #
# 功  能:保留CPU资源使用情况检查                 #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

#检查虚拟机保留CPU资源使用情况
logfile=SYSCHK_VIOC_AIX_CPU_RES.out
if [ `lparstat 1 10|awk 'NR>5 {size+=$6} END {print size/10}'` -le 80 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
	echo "Non-Compliant"
	echo "异常,CPU使用率超过80%,请检查" >${logfile}

fi
