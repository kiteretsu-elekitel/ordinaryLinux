#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	if (argc < 2) {
		fprintf(stderr, "%s: noarguments\n", argv[0]);
		exit(1);
	}

	for (int i = 1; i < argc; i++) {
		if (rmdir(argv[i]) < 0) {
			perror(argv[i]);
			exit(1);
		}
	}
}

