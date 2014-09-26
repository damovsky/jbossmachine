# Pull base image.
FROM damovsky/oracleclient:11gR2Client

RUN yum -y install binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 gcc gcc-c++ glibc.i686 glibc glibc-devel glibc-devel.i686 ksh libgcc.i686 libgcc libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libaio libaio.i686 libaio-devel libaio-devel.i686 libXext libXext.i686 libXtst libXtst.i686 libX11 libX11.i686 libXau libXau.i686 libxcb libxcb.i686 libXi libXi.i686 make sysstat vte3 smartmontools unzip sudo wget dos2unix perl


#install jdk
RUN mkdir /tmp/install && \
 	cd /tmp/install && \
 	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin && \
 	chmod +x /tmp/install/jdk-6u45-linux-x64.bin && \
 	/tmp/install/jdk-6u45-linux-x64.bin && \
 	mkdir /usr/lib/jvm && \
 	mv ./jdk1.6.0_45 /usr/lib/jvm/ && \
 	rm -Rf /tmp/install/jdk-6u45-linux-x64.bin

ENV JAVA_HOME /usr/lib/jvm/jdk1.6.0_45
ENV PATH $JAVA_HOME/bin:$PATH
RUN javac -version

RUN cd /tmp/install && \
 wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip/download --output-document=jboss-5.1.0.GA.zip && \
 mkdir /opt/jboss && \
 unzip /tmp/install/jboss-5.1.0.GA.zip -d /opt/jboss/ && \
 rm -Rf /tmp/install


ENV ORACLE_HOME /oracle/app/ohome/
ENV PATH $PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH $ORACLE_HOME/lib
ENV TNS_ADMIN $ORACLE_HOME/network/admin

# Define working directory.
WORKDIR /tmp

# Define default command.
CMD ["/bin/bash"]