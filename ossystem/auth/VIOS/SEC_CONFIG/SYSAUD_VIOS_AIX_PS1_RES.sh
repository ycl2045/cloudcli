#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_PS1_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查系统提示符PS1设置
# 复核人：
#************************************************#
export LANG=ZH_CN.UTF-8
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
	:
	else
	exit 0
fi
#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_PS1_RES.out
if grep -w "PS1=\`whoami\`\@\`hostname\`\:\'\$PWD\>\'" /etc/profile >/dev/null 2>&1
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
	echo "Non-Compliant"
	echo "异常,该主机PS1参数设置不合规,请检查" >${logfile}
fi