.PHONY: build build-test with-docker with-docker-test builder-img pathcheck certificate-arg-check certificate certificate-with-docker help
.DEFAULT_GOAL=help

build: ## NNDD.air をビルドします
	@cd src && make build

build-test: ## NNDD-test.air をビルドします（テスト用）
	@cd src && make build-test

with-docker: ## Dockerコンテナを使って NNDD.air をビルドします
	@cd src && make with-docker

with-docker-test: ## Dockerコンテナを使って NNDD-test.air をビルドします（テスト用）
	@docker run --rm -it -v $$(pwd):/root/NNDD nndd-builder /bin/sh -c 'cd /root/NNDD/src && make build-test'

builder-img: ## NNDDビルド用のDockerイメージをビルドします
	@cd containers/builder && make build

pathcheck:
	@if [ -z "$$AIR_HOME" ]; then \
		echo 'AIR_HOMEが設定されてないよ。'; \
		echo '末尾に"/"が付かないように指定してね。'; \
		echo; \
		exit 1; \
	fi

certificate-arg-check:
	@if [ -z "$$name" ] || [ -z "$$pass" ]; then \
		echo 'ファイル名とパスワードを指定してね。'; \
		echo 'Usage: make certificate name=[ファイル名] pass=[パスワード]'; \
		echo; \
		exit 1; \
	fi

certificate: pathcheck certificate-arg-check ## ビルドに必要な証明書を作成します
	@java -jar $$AIR_HOME/lib/adt.jar -certificate -cn SelfSigned 2048-RSA "$$name" "$$pass"

certificate-with-docker: certificate-arg-check ## Dockerコンテナを使ってビルドに必要な証明書を作成します
	@docker run --rm -it -v $$(pwd):/root/NNDD nndd-builder /bin/sh -c "cd /root/NNDD && make certificate name='$$name' pass='$$pass'"

help: ## このヘルプを表示します
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
