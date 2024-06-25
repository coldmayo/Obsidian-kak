#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <limits.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <unistd.h>

int listFiles(char * pth, char *fToFind) {
	DIR *d;
	struct dirent *dir;
	struct stat statbuf;
	char path[PATH_MAX] = "\0";
	strcat(path, pth);
	strcat(path, "/");
	//printf("%s\n", path);
	d = opendir(path);
	chdir(path);
	int found = 0;
	if (d) {
		while ((dir = readdir(d)) != NULL) {
			lstat(dir->d_name, &statbuf);
			if (S_ISDIR(statbuf.st_mode)) {
				if (strcmp(dir->d_name, ".") == 0 || strcmp(dir->d_name, "..") == 0) {
					continue;
				}
				char path2[PATH_MAX] = "\0";
				strcat(path2, pth);
				strcat(path2, "/");
				strcat(path2, dir->d_name);
				found = listFiles(path2, fToFind);
				if (found == 1) {
					break;
				}
			} else {
				if (strcmp(fToFind, dir->d_name) == 0) {
					found = 1;
					break;
				} 
			}
		}
	} else {
		//printf("%s Path not available\n", pth);
	}
	closedir(d);
	return found;
}

int main (int argc, char *argv[]) {

	char connects[20][20] = {};

	FILE *fptr;
	char c;

	char path[PATH_MAX] = "\0";
	strcat(path, argv[1]);
	strcat(path, "/");
	strcat(path, argv[2]);
	fptr = fopen(path, "r");

	c = fgetc(fptr);

	int num = 0;
	bool isSaved = false;
	char last;
	while (c != EOF) {
		if (c == '[' && last == '[') {
			isSaved = true;
		} else if (isSaved && c == ']') {
			num++;
			isSaved = false;
		} else if (isSaved) {
			strncat(connects[num], &c, 1);
		}
		last = c;
		c = fgetc(fptr);
	}

	int i;
	
	for (i = 0; num >= i; i++) {
		strcat(connects[i], ".md");
		int found = listFiles(argv[1], connects[i]);
		if (found == 0) {
			char comm[PATH_MAX] = "cd ; touch ";
			strcat(comm, argv[1]);
			strcat(comm, "/");
			strcat(comm, connects[i]);
			system(comm);
		}
	}

	//printf("%s\n", connects[0]);
	
	

	return 0;

}
