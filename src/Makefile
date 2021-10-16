.PHONY: all build pathcheck with-docker

all: build

build: NNDD.air

pathcheck:
	@if [ -z "$$AIR_HOME" ]; then \
		echo 'AIR_HOMEが設定されてないよ。'; \
		echo '末尾に"/"が付かないように指定してね。'; \
		exit 1; \
	fi

NNDD.air: pathcheck NNDD.swf
	@java -jar $$AIR_HOME/lib/adt.jar -package -storetype pkcs12 -keystore ../nndd-5ch_certificate.pfx NNDD.air NNDD-app.xml NNDD.swf icon32.png icon128.png icon48.png icon16.png CategoryList.json

NNDD.swf: pathcheck
	@$$AIR_HOME/bin/amxmlc NNDD.mxml -compiler.include-libraries ../libs/* -warnings=false

with-docker:
	@docker run --rm -it -v $$(cd ../ && pwd):/root/NNDD nndd-builder /bin/sh -c 'cd /root/NNDD && make'
