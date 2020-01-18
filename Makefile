# Copyright 2020 James Grant
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
BINARY_NAME=prometheus-loopstats-exporter

TAG_COMMIT := $(shell git rev-list --abbrev-commit --tags --max-count=1)
TAG := $(shell git describe --abbrev=0 --tags ${TAG_COMMIT} 2>/dev/null || true)
COMMIT := $(shell git rev-parse --short HEAD)
DATE := $(shell git log -1 --format=%cd --date=format:"%Y%m%d")
VERSION := $(TAG:v%=%)
ifneq ($(COMMIT), $(TAG_COMMIT))
	VERSION := $(VERSION)-next-$(COMMIT)-$(DATE)
endif
ifeq ($(VERSION),)
	VERSION := $(COMMIT)-$(DATA)
endif
ifneq ($(shell git status --porcelain),)
	VERSION := $(VERSION)-dirty
endif

FLAGS := -ldflags "-X main.version=$(VERSION)"

all: test build

test:
	$(GOTEST) -v ./...

build:
	GOOS=linux GOARCH=amd64       $(GOBUILD) $(FLAGS) -o bin/$(BINARY_NAME)-$(VERSION)-linux-amd64
	GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) $(FLAGS) -o bin/$(BINARY_NAME)-$(VERSION)-linux-armhf
	GOOS=linux GOARCH=arm64       $(GOBUILD) $(FLAGS) -o bin/$(BINARY_NAME)-$(VERSION)-linux-arm64

clean:
	$(GOCLEAN)
	rm -r bin/*
