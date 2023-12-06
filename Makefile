APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=public.ecr.aws/m4r1g5r3
VERSION=$(shell git describe --tags --abbrev=0)$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=all
format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v 
get:
	go get
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/staskuznetsov/kbot/cmd.appVersion=${VERSION}
image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${shell dpkg --print-architecture}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${shell dpkg --print-architecture}
clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${shell dpkg --print-architecture}
