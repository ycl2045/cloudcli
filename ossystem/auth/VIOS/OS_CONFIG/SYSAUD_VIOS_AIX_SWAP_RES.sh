#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_SWAP_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查swap设置
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
logfile=SYSAUD_VIOS_AIX_SWAP_RES.out
hd6_size=$(lsps -a 2>/dev/null|awk '/hd6/ {print $4}')
if [ ${hd6_size} = 16384MB ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前系统swap是${hd6_size} ,不合规,标准值是16384 " >${logfile}
fi