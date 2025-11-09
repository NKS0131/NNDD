.PHONY: build build-test pathcheck with-docker help
.DEFAULT_GOAL=help

build: NNDD.air ## NNDD.air をビルドします

build-test: NNDD-test.air ## NNDD-test.air をビルドします（テスト用）

pathcheck:
	@if [ -z "$$AIR_HOME" ]; then \
		echo 'AIR_HOMEが設定されてないよ。'; \
		echo '末尾に"/"が付かないように指定してね。'; \
		echo; \
		exit 1; \
	fi

NNDD.air: pathcheck NNDD.swf
	@java -jar $$AIR_HOME/lib/adt.jar -certificate -cn SelfSigned 2048-RSA certificate_no_password.pfx ''
	@java -jar $$AIR_HOME/lib/adt.jar -package -storetype pkcs12 -keystore certificate_no_password.pfx -storepass '' NNDD.air NNDD-app.xml NNDD.swf icon32.png icon128.png icon48.png icon16.png CategoryList.json

NNDD-test.air: pathcheck NNDD.swf
	@java -jar $$AIR_HOME/lib/adt.jar -certificate -cn SelfSigned 2048-RSA certificate_no_password_test.pfx ''
	@java -jar $$AIR_HOME/lib/adt.jar -package -storetype pkcs12 -keystore certificate_no_password_test.pfx -storepass '' NNDD-test.air NNDD-app-test.xml NNDD.swf icon32.png icon128.png icon48.png icon16.png CategoryList.json

NNDD.swf: pathcheck
	@$$AIR_HOME/bin/amxmlc NNDD.mxml -compiler.include-libraries ../libs/* -warnings=false

with-docker: ## Dockerコンテナを使って NNDD.air をビルドします
	@docker run --rm -it -v $$(cd ../ && pwd):/root/NNDD nndd-builder /bin/sh -c 'cd /root/NNDD/src && make build'

help: ## このヘルプを表示します
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
