#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <regex.h>

static void do_slice(regex_t *pat, FILE *f);

int main(int argc, char *argv[]) {
	regex_t pat;
	int err;
	int i;

	if (argc < 2) {
		fputs("no pattern\n", stderr);
		exit(1);
	}

	err = regcomp(&pat, argv[1], REG_EXTENDED | REG_NEWLINE);
	if (err != 0) {
		char buf[1024];

		regerror(err, &pat, buf, sizeof buf);
		puts(buf);
		exit(1);
	}
	if (argc == 2) {
		do_slice(&pat, stdin);
	} else {
		for(i = 2; i < argc; i++) {
			FILE *f;

			f = fopen(argv[i], "r");
			if (!f) {
				perror(argv[i]);
				exit(1);
			}
			do_slice(&pat, f);
			fclose(f);
		}
	}
	regfree(&pat);
	exit(0);

}

static void do_slice(regex_t *pat, FILE *src) {
	char buf[4096];

	size_t nmatch = 5;
	regmatch_t match[nmatch];

	while (fgets(buf, sizeof buf, src)) {
		if (regexec(pat, buf, nmatch, match, 0) == 0) {
			for (int i = 0; i < nmatch; i++) {
				if (match[i].rm_so >= 0 && match[i].rm_eo >=0) {
					for (int j = match[i].rm_so; j < match[i].rm_eo; j++) {
						putchar(buf[j]);
					}
					putchar('\n');
				}
			}
		}
	}
}
