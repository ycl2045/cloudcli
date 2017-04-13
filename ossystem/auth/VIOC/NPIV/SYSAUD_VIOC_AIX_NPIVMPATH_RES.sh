#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_NPIVMPATH_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:npiv存储磁盘多路径状态检查
# 复核人:
#************************************************#
abc=0
#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1


#npiv存储磁盘多路径状态检查
logfile=SYSAUD_VIOC_AIX_NPIVMPATH_RES.out
>${logfile}
for disk_name in `lspv|awk '/power/{print $1}'`
	do
	fcs_c=`powermt display dev=${disk_name}|awk 'NR>8 {print $2}'|sed '/^$/d'|sort|uniq|wc -l`
	alive_c=`powermt display dev=${disk_name}|awk 'NR>8 {print $7}'|sed '/^$/d'|sort|uniq|grep -v alive|wc -l`
		if [ ${fcs_c} -eq 4 ]&&[ ${alive_c} -eq 0 ]
			then
				:
			else
				let abc=${abc}+1
				echo "${disk_name}磁盘的多路径状态异常,请检查">> ${logfile}
				fi
				done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,存在dead状态的路径或powerdisk磁盘路径数小于4,请检查" >>${logfile}
	fi
