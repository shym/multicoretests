all: rmdirs rmmkdir

%: %.c
	gcc -Wall -Wextra -g $< -o $@ -lpthread

.PHONY: all
