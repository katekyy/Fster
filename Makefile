NAME=fster
MAIN=Fster.lua

build:
	luac -o bin/$(NAME)_lib $(MAIN)

clean:
	rm bin/*.lua
