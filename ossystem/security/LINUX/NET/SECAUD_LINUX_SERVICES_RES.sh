#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_SERVICES_RES.sh             
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                            
# 功  能：检查非必须的服务是否开启                                    
#************************************************

v_golbalpath=/home/ap/opscloud/security/LINUX
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/security/LINUX"
log_dir="/home/ap/opscloud/logs"
cd ${log_dir} >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir ${log_dir} 
  cd ${log_dir}
fi

if [ -f SECAUD_LINUX_SERVICES_RES.out ]; then
	rm -f SECAUD_LINUX_SERVICES_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f temp.out ]; then
	rm -f temp.out
fi

if [ -f temp2.out ]; then
	rm -f temp2.out
fi

echo 原始信息>SECAUD_LINUX_SERVICES_RES.out
echo ----->>SECAUD_LINUX_SERVICES_RES.out

#1、利用chkconfig --list输出所有的服务情况。
/sbin/chkconfig --list >temp.out

Services="lpd smb telnet routed sendmail Bluetooth identd xfs rlogin rwho rsh rexec daytime chargen echo"
for services in $Services ;do
	grep $services temp.out >temp2.out
	if [ $? -eq 1 ]; then
		echo $services服务在chkconfig中不存在>>SECAUD_LINUX_SERVICES_RES.out
	else
		echo $services服务在chkconfig中存在>>SECAUD_LINUX_SERVICES_RES.out
		grep on temp2.out>/dev/null
		if [ $? -eq 1 ]; then
			echo $services服务在chkconfig中已禁用，合规.>>SECAUD_LINUX_SERVICES_RES.out
		else
			echo $services服务在chkconfig中未禁用，不合规.>>SECAUD_LINUX_SERVICES_RES.out
			echo $services服务在chkconfig中未禁用，不合规.>>Conviction.out
		fi
	fi
done

#2、利用ps -ef检查正在运行的程序中是否有相应的服务
Services="lpd smb telnet routed sendmail Bluetooth identd xfs rlogin rwho rsh rexec daytime chargen echo"
for services in $Services ;do
	ps -ef|grep $services|grep -v grep>/dev/null
	if [ $? -eq 1 ]; then
		echo $services服务当前未运行>>SECAUD_LINUX_SERVICES_RES.out
	else
		echo $services服务当前正在运行，不合规>>SECAUD_LINUX_SERVICES_RES.out
		echo $services服务当前正在运行，不合规>>Conviction.out
	fi
done

echo ----->>SECAUD_LINUX_SERVICES_RES.out
echo 最终结论>>SECAUD_LINUX_SERVICES_RES.out
echo ----->>SECAUD_LINUX_SERVICES_RES.out

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规" >> SECAUD_LINUX_SERVICES_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_SERVICES_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_SERVICES_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f temp.out ]; then
	rm -f temp.out
fi

if [ -f temp2.out ]; then
	rm -f temp2.out
fi

exit 0;
