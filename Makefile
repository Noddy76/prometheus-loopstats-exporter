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
    
all: test build

test: 
	$(GOTEST) -v ./...

build:
	GOOS=linux GOARCH=amd64       $(GOBUILD) -o bin/amd64/$(BINARY_NAME)
	GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) -o bin/armhf/$(BINARY_NAME)
	GOOS=linux GOARCH=arm64       $(GOBUILD) -o bin/arm64/$(BINARY_NAME)

clean:
	$(GOCLEAN)
	rm -r bin/*
