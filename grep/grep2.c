#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>
#include <unistd.h>
#include <stdbool.h>

#define BUFSIZE 1024;

static void do_grep(regex_t *pat, FILE *f, bool ignoreCase, bool invert);
static void do_grep_ignore(regex_t *pat, FILE *f);
static void toLowerCase(char *targetBuf);

int main(int argc, char *argv[]) {

	int opt;
	int optNum = 0;
	bool ignoreCase = false;
	bool invert = false;

	while ((opt = getopt(argc, argv, "iv")) != -1 ) {
		switch(opt) {
			case 'i':
				ignoreCase = true;
				optNum += 1;
				break;
			case 'v':
				invert = true;
				optNum += 1;
				break;
			case '?':
				fputs("invalid argument given", stderr);
				exit(1);
		}
	}

	regex_t pat;
	int err;
	int i;
	int patind = optind;

	if ((argc - optNum) < 2) {
		fputs("no pattern\n", stderr);
		exit(1);
	}

	if (ignoreCase) {
		toLowerCase(argv[patind]);
	}
	err = regcomp(&pat, argv[patind], REG_EXTENDED | REG_NOSUB | REG_NEWLINE);
	if (err != 0) {
		char buf[BUFSIZ];

		regerror(err, &pat, buf, sizeof buf);
		puts(buf);
		exit(1);
	}
	if ((argc - optNum) == 2) {
		do_grep(&pat, stdin, ignoreCase, invert);
	} else {
		for(i = optind + 1; i < argc; i++) {
			FILE *f;

			f = fopen(argv[i], "r");
			if (!f) {
				perror(argv[i]);
				exit(1);
			}
			do_grep(&pat, f, ignoreCase, invert);
			fclose(f);
		}
	}
	regfree(&pat);
	exit(0);

}

static void do_grep(regex_t *pat, FILE *src, bool ignoreCase, bool invert) {
	char buf[4096];
	char orgBuf[4096];

	while (fgets(buf, sizeof buf, src)) {
		if (ignoreCase) {
			memccpy(orgBuf, buf, '\0', sizeof(buf));
			toLowerCase(buf);
		}

		int result = regexec(pat, buf, 0, NULL, 0);
		if (!invert && result == 0) {
			if (ignoreCase) {
				fputs(orgBuf, stdout);
			} else {
				fputs(buf, stdout);
			}
		} else if (invert && result != 0) {
			if (ignoreCase) {
				fputs(orgBuf, stdout);
			} else {
				fputs(buf, stdout);
			}
		}

	}
}

static void toLowerCase(char *targetBuf) {
	for(int i = 0; i <= strlen(targetBuf); i++) {
		if(targetBuf[i] >= 65 && targetBuf[i] <= 90) {
      		targetBuf[i] = targetBuf[i] + 32;
		}

	}
}

static void do_grep_ignore(regex_t *pat, FILE *src) {
	char buf[4096];
	char orgBuf[4096];
	char* lowerCaseBuf;


	while (fgets(buf, sizeof buf, src)) {
		memccpy(orgBuf, buf, '\0', sizeof(buf));
	    toLowerCase(buf);
		//printf("%s", buf);
		if (regexec(pat, buf, 0, NULL, 0) == 0) {
			fputs(orgBuf, stdout);
		}
	}
}
