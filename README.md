jbossmachine
============

1. Download this whole repo (Dockerfile is not enough!)
2. Download jdk-6u45-linux-x64.bin - JDK 1.6 from Oracle site http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-javase6-419409.html#jdk-6u45-oth-JPR
3. Download linux.x64_11gR2_client.zip -  Oracle Database 11g Release 2 Client (11.2.0.1.0) for Linux x86-64 from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/112010-linx8664soft-100572.html
4. Run
docker build -t damovsky/jbossmachine .


Run Docker container:

docker run -i -t --privileged --name jboss damovsky/jbossmachine