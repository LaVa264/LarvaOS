OS_DIR=$(shell cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR=$(OS_DIR)/build

export OS_DIR
export BUILD_DIR

help:
	@echo "Makefile for Building Larva Operating System."
	@echo "Usage: make [ all | clean | help | build | run] " 
	@echo ""

all:
	make -C ./src/kernel/libc all
	make -C ./src/kernel all
	make -C ./src/userland all

clean:
	make -C ./src/kernel/libc clean
	make -C ./src/kernel clean
	make -C ./src/userland clean
