#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_PVSTAT_RES.sh
# 作  者:CCSD_YOUTONGLI
# 日  期:2010年 1月4 日
# 功  能:检查系统pv的状态
# 复核人:
#************************************************#

#判断该台主机是不是VIOS
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		:
	else
exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opscloud/logs
  cd /home/ap/opscloud/logs
fi

lspv | awk '( $4 != "active" ) && ( $4 != "Available" ) && ( $3 != "None" ) && ( $4 != "" ) && ( $4 != "concurrent" ) { print $0; }'  > SYSCHK_VIOS_AIX_PVSTAT_RES.out
lsvg -p rootvg |awk '{if ($2 != "active") print $0}' |grep -vE "PV_NAME|rootvg" >> SYSCHK_VIOS_AIX_PVSTAT_RES.out
if [ -s SYSCHK_VIOS_AIX_PVSTAT_RES.out ]; then
   echo "Non-Compliant"
   echo "异常,以上PV状态异常" >> SYSCHK_VIOS_AIX_PVSTAT_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOS_AIX_PVSTAT_RES.out

fi



exit 0;