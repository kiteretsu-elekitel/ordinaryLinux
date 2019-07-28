#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>
#include <unistd.h>
#include <stdbool.h>

#define BUFSIZE 1024;

static void do_grep(regex_t *pat, FILE *f);

int main(int argc, char *argv[]) {

	int opt;
	bool ignoreCase = false;

	while ((opt = getopt(argc, argv, "iv")) != -1 ) {
		switch(opt) {
			case 'i':
				ignoreCase = true;
				break;
			case 'v':
				break;
			case '?':
				fputs("invalid argument given", stderr);
				exit(1);
		}
	}

	regex_t pat;
	int err;
	int i;

	if (argc < 2) {
		fputs("no pattern\n", stderr);
		exit(1);
	}

	err = regcomp(&pat, argv[1], REG_EXTENDED | REG_NOSUB | REG_NEWLINE);
	if (err != 0) {
		char buf[BUFSIZ];

		regerror(err, &pat, buf, sizeof buf);
		puts(buf);
		exit(1);
	}
	if (argc == 2) {
		do_grep(&pat, stdin);
	} else {
		for(i = 2; i < argc; i++) {
			FILE *f;

			f = fopen(argv[i], "r");
			if (!f) {
				perror(argv[i]);
				exit(1);
			}
			do_grep(&pat, f);
			fclose(f);
		}
	}
	regfree(&pat);
	exit(0);

}

static void do_grep(regex_t *pat, FILE *src) {
	char buf[4096];

	while (fgets(buf, sizeof buf, src)) {
		if (regexec(pat, buf, 0, NULL, 0) == 0) {
			fputs(buf, stdout);
		}
	}
}

static char *toLowerCase(char *targetBuf) {
	for(int i; i <= strlen(targetBuf); i++) {
		if(targetBuf[i] >= 65 && targetBuf[i] <= 90)
      		targetBuf[i] = targetBuf[i] + 32;
	}

	return targetBuf;
}
