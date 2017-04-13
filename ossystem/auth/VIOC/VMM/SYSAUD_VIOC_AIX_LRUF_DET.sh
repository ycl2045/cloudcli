 #!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_LRUF_DET.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能：检查参数lru_file_repage设置
# 复核人：
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
	else
		cat ${log_dir}/SYSAUD_VIOC_AIX_LRUF_RES.out
fi
