#!/bin/sh

#定义U盘名称
upan="BUNTU"

tomcat="tomcat_"


eval ${tomcat}url="http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.33/bin/apache-tomcat-8.5.33.tar.gz"


Install_Software()
{
	#依赖升级
	sudo apt -f install
	sudo apt-get update
	#安装gcc
	apt-get install gcc-4.8 && Y
	apt-get install g++-4.8 && Y
	
	#安装 JAVA
	cp -f /media/sdzb/${upan}/jdk-7u79-linux-x64.tar.gz /usr/local
	tar -zxf jdk-7u79-linux-x64.tar.gz -C /usr/local/
	cd /usr/local
	mv jdk1.7.0_79 java 
	
	if ! grep "JAVA_HOME=/usr/local/java" /etc/profile
	then
		echo 'JAVA_HOME=/usr/local/java' >> /etc/profile
		echo 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
		echo 'CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH' >> /etc/profile
		echo 'PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> /etc/profile
	fi	
	
	source /etc/profile
	
	export JAVA_HOME="/usr/local/java"
	
	java -version

	# 安装 Tomcat8.5
	cd /usr/local
	wget -O tomcat.tar.gz ${tomcat_url} 
	tar zxf tomcat.tar.gz
	mv apache-tomcat-8.5.33 tomcat
	cd tomcat/bin
	tar xfz commons-daemon-native.tar.gz
	cd commons-daemon-1.1.0-native-src/unix
	./configure && make
	cp jsvc ../..
	cd /usr/local/tomcat
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
	sudo bash /usr/local/tomcat/bin/startup.sh
}

Install_Software
