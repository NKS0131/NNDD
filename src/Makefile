.PHONY: build pathcheck with-docker help
.DEFAULT_GOAL=help

build: NNDD.air ## NNDD.air をビルドします

pathcheck:
	@if [ -z "$$AIR_HOME" ]; then \
		echo 'AIR_HOMEが設定されてないよ。'; \
		echo '末尾に"/"が付かないように指定してね。'; \
		echo; \
		exit 1; \
	fi

NNDD.air: pathcheck NNDD.swf
	@java -jar $$AIR_HOME/lib/adt.jar -package -storetype pkcs12 -keystore ../nndd-5ch_certificate.pfx NNDD.air NNDD-app.xml NNDD.swf icon32.png icon128.png icon48.png icon16.png CategoryList.json

NNDD.swf: pathcheck
	@$$AIR_HOME/bin/amxmlc NNDD.mxml -compiler.include-libraries ../libs/* -warnings=false

with-docker: ## Dockerコンテナを使って NNDD.air をビルドします
	@docker run --rm -it -v $$(cd ../ && pwd):/root/NNDD nndd-builder /bin/sh -c 'cd /root/NNDD && make'

help: ## このヘルプを表示します
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
