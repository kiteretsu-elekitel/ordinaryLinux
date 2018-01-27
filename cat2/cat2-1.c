#include <stdio.h>
#include <stdlib.h>
/*タブ文字を「\t」という2文字、改行を「\ + 改行」の2文字に置き換え
 * ながら出力するcatコマンドを書きなさい*/

int main(int argc, char *argv[]) {
	int i;

	for (i = 1; i < argc; i++){
		FILE *f;
		int c;

		f = fopen(argv[i], "r");
		if (!f) {
			perror(argv[i]);
			exit(1);
		}
		while ((c = fgetc(f)) != EOF) {
			switch (c) {
				case '\t':
					if (putchar('\\') < 0) exit(1);
					if (putchar('t') < 0) exit(1);
					break;
				case '\n':
					if (putchar('\\') < 0) exit(1);
					if (putchar('\n') < 0) exit(1);
					break;
				default:
					if (putchar(c) < 0) exit(1);
			}
		}
		fclose(f);
	}
	exit(0);
}
