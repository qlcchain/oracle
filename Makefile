.PHONY: all clean
.PHONY: goracle_linux  goracle-linux-amd64 goracle-darwin-amd64
.PHONY: goracle-darwin goracle-darwin-amd64
.PHONY: goracle-windows goracle-windows-386 goracle-windows-amd64
.PHONY: goraclec_linux  goraclec-linux-amd64 goraclec-darwin-amd64
.PHONY: goraclec-darwin goraclec-darwin-amd64
.PHONY: goraclec-windows goraclec-windows-386 goraclec-windows-amd64

# Check for required command tools to build or stop immediately
EXECUTABLES = git go find pwd
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH)))

GO ?= latest

SERVERBINARY = goracle
SERVERMAIN = $(shell pwd)/cmd/server/main.go

BUILDDIR = $(shell pwd)/build
VERSION = 0.0.1
GITREV = $(shell git rev-parse --short HEAD)
BUILDTIME = $(shell date +'%Y-%m-%d_%T')
LDFLAGS=-ldflags "-X main.version=${VERSION} -X main.sha1ver=${GITREV} -X main.buildTime=${BUILDTIME}"

build: update-version
	go build -v -i -o $(BUILDDIR)/$(SERVERBINARY) $(SERVERMAIN)
	@echo "Build server done."
	@echo "Run \"$(BUILDDIR)/$(SERVERBINARY)\" to start qlc oracle server."

all: goracle-windows goracle-darwin goracle-linux

update-version:
	@echo "package qlcchain" > $(shell pwd)/version.go
	@echo  "">> $(shell pwd)/version.go
	@echo "const GITREV = \""$(GITREV)"\"" >> $(shell pwd)/version.go
	@echo "const VERSION = \""$(VERSION)"\"" >> $(shell pwd)/version.go
	@echo "const BUILDTIME = \""$(BUILDTIME)"\"" >> $(shell pwd)/version.go

clean:
	rm -rf $(BUILDDIR)/

# qlc oracle server

goracle-linux: goracle-linux-amd64
	@echo "Linux cross compilation done."

goracle-linux-amd64: update-version
	env GOOS=linux GOARCH=amd64 go build -i -o $(BUILDDIR)/$(SERVERBINARY)-linux-amd64-v$(VERSION)-$(GITREV) $(SERVERMAIN)
	@echo "Build linux server done."
	@ls -ld $(BUILDDIR)/$(SERVERBINARY)-linux-amd64-v$(VERSION)-$(GITREV)

goracle-darwin: update-version
	env GOOS=darwin GOARCH=amd64 go build -i -o $(BUILDDIR)/$(SERVERBINARY)-darwin-amd64-v$(VERSION)-$(GITREV) $(SERVERMAIN)
	@echo "Build darwin server done."
	@ls -ld $(BUILDDIR)/$(SERVERBINARY)-darwin-amd64-v$(VERSION)-$(GITREV)

goracle-windows: goracle-windows-amd64 goracle-windows-386
	@echo "Windows cross compilation done:"
	@ls -ld $(BUILDDIR)/$(SERVERBINARY)-windows-*

goracle-windows-386: update-version
	env GOOS=windows GOARCH=386 go build -i -o $(BUILDDIR)/$(SERVERBINARY)-windows-386-v$(VERSION)-$(GITREV).exe $(SERVERMAIN)
	@echo "Build windows x86 server done."
	@ls -ld $(BUILDDIR)/$(SERVERBINARY)-windows-386-v$(VERSION)-$(GITREV).exe

goracle-windows-amd64: update-version
	env GOOS=windows GOARCH=amd64 go build -i -o $(BUILDDIR)/$(SERVERBINARY)-windows-amd64-v$(VERSION)-$(GITREV).exe $(SERVERMAIN)
	@echo "Build windows server done."
	@ls -ld $(BUILDDIR)/$(SERVERBINARY)-windows-amd64-v$(VERSION)-$(GITREV).exe
