#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
	int i;

	for (i = 1; i < argc; i++){
		FILE *f;
		int c;
		int lineNum = 0;
		char clineNum[128];

		f = fopen(argv[i], "r");
		if (!f) {
			perror(argv[i]);
			exit(1);
		}
		while ((c = fgetc(f)) != EOF) {
			if (c == '\n') lineNum++;
		}
		if (printf("%d\n", lineNum) < 0) exit(1);
		fclose(f);
	}
	exit(0);
}
