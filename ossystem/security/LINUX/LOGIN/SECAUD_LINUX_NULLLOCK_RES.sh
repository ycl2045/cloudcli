#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_NULLLOCK_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                             
# 功  能：检查是否禁用空密码用户                                                  
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

if [ -f SECAUD_LINUX_NULLLOCK_RES.out ]; then
	rm -f SECAUD_LINUX_NULLLOCK_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

#1.检查是否禁用空密码用户.
echo 原始信息>SECAUD_LINUX_NULLLOCK_RES.out
echo ----->>SECAUD_LINUX_NULLLOCK_RES.out
awk -F " " '$1~/auth/ && $2~/sufficient/ {print $0}' /etc/pam.d/system-auth>>SECAUD_LINUX_NULLLOCK_RES.out

echo ----->>SECAUD_LINUX_NULLLOCK_RES.out
echo 中间信息>>SECAUD_LINUX_NULLLOCK_RES.out
echo ----->>SECAUD_LINUX_NULLLOCK_RES.out

grep "nullok" SECAUD_LINUX_NULLLOCK_RES.out >/dev/null 2>&1
result=`echo $?`
if [ "$result" -eq 0 ];then
	echo nullok参数未删除，不合规。>>SECAUD_LINUX_NULLLOCK_RES.out
	echo nullok参数未删除，不合规。>>Conviction.out
else
	echo nullok参数已删除，合规。>>SECAUD_LINUX_NULLLOCK_RES.out
fi

echo ----->>SECAUD_LINUX_NULLLOCK_RES.out
echo 最终结论>>SECAUD_LINUX_NULLLOCK_RES.out
echo ----->>SECAUD_LINUX_NULLLOCK_RES.out

#2.得到最终结果.

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#2.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规">> SECAUD_LINUX_NULLLOCK_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_NULLLOCK_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_NULLLOCK_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

exit 0;