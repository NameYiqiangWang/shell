#!/bin/sh

tomcat="tomcat_"

eval ${tomcat}url="http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.33/bin/apache-tomcat-8.5.33.tar.gz"


# 下载文件
function Ver()
{
  wget ${1}
  _name=${1##*/}
  if [[ ${_name} == *.tar.gz ]]
  then
    tar zxf ${_name} -C /usr/local
    echo ${_name%.tar.gz}
  elif [[ ${_name} == *.tgz ]]
  then
    mv ${_name} ${_name%.tgz}.tar.gz
    tar zxf ${_name} -C /usr/local
    echo ${_name%.tar.gz}
  elif [[ ${_name} == *.tar.bz2 ]]
  then
    tar jxf ${_name} -C /usr/local
    echo ${_name%.tar.bz2}
  else
    echo "wrong"
    exit
  fi
}



Install_Software()
{
	#安装 JAVA
	cd /usr/local
	mkdir java
	cp /media/sdzb/ubutu/jdk-7u79-linux-x64.tar.gz /usr/local
	tar -zxvf jdk-7u79-linux-x64.tar.gz /usr/local/java
	
	echo 'JAVA_HOME=/usr/local/java' >> /etc/profile
	echo 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
	echo 'CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH' >> /etc/profile
	echo 'PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> /etc/profile
	
	source /etc/profile
	
	java -version

	# 安装 Tomcat8.5
	eval ${tomcat}ver=`Ver ${tomcat_url}`
	cd /usr/local/${tomcat_ver}/bin
	tar xvfz commons-daemon-native.tar.gz
	cd commons-daemon-1.1.x-native-src/unix
	./configure && make
	cp jsvc ../..
	cd /usr/local/${tomcat_ver}/
	./bin/jsvc \
    -classpath $CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar \
    -outfile $CATALINA_BASE/logs/catalina.out \
    -errfile $CATALINA_BASE/logs/catalina.err \
    -Dcatalina.home=$CATALINA_HOME \
    -Dcatalina.base=$CATALINA_BASE \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
    -Djava.util.logging.config.file=$CATALINA_BASE/conf/logging.properties \
    org.apache.catalina.startup.Bootstrap
	
	echo "Tomcat8.5 安装成功"
	
	# 设置tomcat开机自启动
	
	# 数据本地化应用部署
	
	# 县级服务部署
	
	# 启动tomcat
	
}

Install_Software
