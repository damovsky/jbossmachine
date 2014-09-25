# Pull base image.
FROM wscherphof/oracle-linux-7

RUN yum -y install binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 gcc gcc-c++ glibc.i686 glibc glibc-devel glibc-devel.i686 ksh libgcc.i686 libgcc libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libaio libaio.i686 libaio-devel libaio-devel.i686 libXext libXext.i686 libXtst libXtst.i686 libX11 libX11.i686 libXau libXau.i686 libxcb libxcb.i686 libXi libXi.i686 make sysstat vte3 smartmontools unzip sudo wget

ADD sysctl.conf /etc/sysctl.conf
RUN echo "oracle soft stack 10240" >> /etc/security/limits.conf
RUN echo "session     required    pam_limits.so" >> /etc/pam.d/login

# create user and group for oracle
RUN groupadd -g 54321 oinstall && groupadd -g 54322 dba
RUN userdel oracle && rm -rf /home/oracle && rm /var/spool/mail/oracle
RUN useradd -m -u 54321 -g oinstall -G dba oracle
RUN echo "oracle:oracle" | chpasswd

RUN mkdir -p /opt/oracle /oracle && \
	chown oracle.oinstall /opt/oracle /oracle


ADD oracleClient/linux.x64_11gR2_client.zip /tmp/install/linux.x64_11gR2_client.zip
ADD oracleClient/client_install.rsp /tmp/install/client_install.rsp
ADD oracleClient/install.sh /tmp/install/install.sh
RUN chmod +x /tmp/install/install.sh
RUN cd /tmp/install && unzip /tmp/install/linux.x64_11gR2_client.zip
RUN chown -R oracle:oinstall /tmp/install/
RUN su -s /bin/bash oracle -c "/tmp/install/install.sh"


RUN /oracle/oinventory/orainstRoot.sh
RUN /oracle/app/ohome/root.sh


#install jdk
ADD jdk-6u45-linux-x64.bin /tmp/install/jdk-6u45-linux-x64.bin
RUN chmod +x /tmp/install/jdk-6u45-linux-x64.bin
RUN /tmp/install/jdk-6u45-linux-x64.bin 
RUN mkdir /usr/lib/jvm
RUN mv ./jdk1.6.0_45 /usr/lib/jvm/
ENV JAVA_HOME /usr/lib/jvm/jdk1.6.0_45
ENV PATH $JAVA_HOME/bin:$PATH
RUN javac -version

RUN wget http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip/download /tmp/install/
RUN unzip /tmp/install/jboss-5.1.0.GA.zip /opt/jboss/
#RUN rm -Rf /tmp/install

# Define working directory.
WORKDIR /tmp

# Define default command.
CMD ["/bin/bash"]