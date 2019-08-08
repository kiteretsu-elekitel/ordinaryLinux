#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <string.h>

static void pickupDir(char *path);

int main(int argc, char *argv[]) {

	if (argc < 2) {
		fprintf(stderr, "%s: no argument\n", argv[0]);
		exit(1);
	}

	for (int i = 1; i < argc; i++) {
		pickupDir(argv[i]);
	}
	exit(0);
}

static void pickupDir(char *path) {
	DIR *d;
	struct dirent *ent;
	struct stat st;

	d = opendir(path);
	if (!d) {
		perror(path);
		exit(1);
	}

	while (ent = readdir(d)) {
		char* filepath[4096];
		printf("%s\n", ent->d_name);
		snprintf(filepath, 4096, "%s%s%s", path, "/", ent->d_name);
		printf("%s", filepath);

	}

	closedir(d);
}
