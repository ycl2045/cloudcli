#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20121122
###AUDIT CHECK
###设置了SGA_TARGET该参数使数据库自行调整各部件内存分配，
###容易触发bug
#############################################################

#检查临时脚本输出目录是否存在
export LANG=C
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi
#设置oracle 临时输出文件
cd $log_dir/oracle >/dev/null 2>&1
if [ $? -ne 0 ]; then
    mkdir $log_dir/oracle
fi
#log_dir=$log_dir/oracle
#sh_dir=$sh_dir;


#清空历史数据
> $log_dir/DBAUD_ORA_SGATARGET_RES.out

#设置标记值
resulta=0

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
	if [ -f $log_dir/oracle/DBAUD_ORA_SGATARGET_RES2.out ];then
       rm $log_dir/oracle/DBAUD_ORA_SGATARGET_RES2.out
    fi
  #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_sgatarget.sql " > $log_dir/out.log;
  rm $log_dir/out.log
    v_sgamaxsize=`cat $log_dir/oracle/DBAUD_ORA_SGATARGET_RES2.out|grep -Ev 'SQL|no|^$'|head -1|tail -1|sed 's/ //g'`
	v_sgatarget=`cat $log_dir/oracle/DBAUD_ORA_SGATARGET_RES2.out|grep -Ev 'SQL|no|^$'|head -2|tail -1|sed 's/ //g'`
	#判断是否有大于阀值的记录输出
	#获取数据库版本
  db_v=`su - oracle -c "sqlplus -v"|grep -Ev "NEW|MAIL"|awk '{print $3}'|awk -F. '{print $1}'`
  if [ $db_v -eq '11' ];then
      if [[ $v_sgatarget -eq $v_sgamaxsize ]];then
	    	echo "数据库实例"$sid": 合规 " >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
	    else 
	    	resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不合规" >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
        echo "SGA_TARGET参数为"$v_sgatarget,"11g规范推荐与SGA_MAX_SIZE["$v_sgamaxsize"]设置相同" >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
      fi
  else
      if [[ $v_sgatarget -eq '0' ]];then
	    	echo "数据库实例"$sid": 合规 " >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
	    else 
	    	resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不合规" >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
        echo "SGA_TARGET参数为"$v_sgatarget,"10g规范推荐设置为0" >>$log_dir/DBAUD_ORA_SGATARGET_RES.out
      fi
  fi
   
done


#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
