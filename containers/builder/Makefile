.PHONY: all build download build-with-squash

all: build

build: download
	@echo 'コンテナをビルドします'
	@docker build . -t nndd-builder:latest

build-with-squash: download
	@echo 'コンテナをビルドします'
	@docker build . -t nndd-builder:latest --squash

download: apache-flex-sdk-4.16.1-bin.tar.gz AdobeAIRSDK.zip OSMF2_0.swc

apache-flex-sdk-4.16.1-bin.tar.gz:
	@echo 'Apache Flex SDKをダウンロードします'
	@curl https://dlcdn.apache.org/flex/4.16.1/binaries/apache-flex-sdk-4.16.1-bin.tar.gz -O
	@echo

AdobeAIRSDK.zip:
	@echo 'Adobe AIR SDKをダウンロードします'
	@curl http://fpdownload.macromedia.com/air/win/download/32.0/AdobeAIRSDK.zip -O
	@echo

OSMF2_0.swc:
	@echo 'osmfライブラリをダウンロードします'
	@curl https://sourceforge.net/adobe/flexsdk/code/HEAD/tree/trunk/frameworks/libs/OSMF2_0.swc?format=raw -o OSMF2_0.swc
	@echo
