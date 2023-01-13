rmdirs: rmdirs.c
	gcc -Wall -Wextra -g $< -o $@ -lpthread
