#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_STALEPP_RES.sh          #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查系统pv的状态                        #
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

#查找rootvg当中状态为stale的pp
v_st1=`lsvg rootvg |grep "STALE" |awk '{print $3,$6}'`
logfile=SYSCHK_VIOC_AIX_STALEPP_RES.out

if [ "$v_st1" = "0 0" ]; then
    echo "Compliant"
    echo "正常" > ${logfile}

else
    echo "Non-Compliant"
    echo "异常,rootvg卷组中存在STALE状态的PV或PPS" > ${logfile}
fi

exit 0;