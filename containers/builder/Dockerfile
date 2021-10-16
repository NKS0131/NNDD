FROM alpine:latest

RUN apk update && apk add openjdk11-jre-headless make

ADD apache-flex-sdk-4.16.1-bin.tar.gz /root/
RUN mv /root/apache-flex-sdk-4.16.1-bin /opt/airsdk

COPY AdobeAIRSDK.zip /root/
RUN unzip /root/AdobeAIRSDK.zip -d /opt/airsdk
RUN rm /root/AdobeAIRSDK.zip

COPY OSMF2_0.swc /opt/airsdk/frameworks/libs/osmf.swc

ENV AIR_HOME=/opt/airsdk PATH=/opt/airsdk/bin:$PATH
