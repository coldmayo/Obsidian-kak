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

void open(char * path, char * name) {
	char command[PATH_MAX] = "xdg-open 'obsidian://vault/";

	char vaultName[PATH_MAX];
	int i = strlen(path)-1;
	int j = 0;
	while (path[i] != '/') {
		vaultName[j] = path[i];
		//printf("%c", path[i]);
		i--;
		j++;
	}

	// reverse the string lol
	i = strlen(vaultName)-1;
	j = 0;
	char temp;
	while (i > j) {
		temp = vaultName[j];
		vaultName[j] = vaultName[i];
		vaultName[i] = temp;
		//printf("%c %d", vaultName[i], i);
		i--;
		j++;
	}

	char * vName = vaultName;
	strcat(command, vName);
	strcat(command, "/");
	strcat(command, name);
	strcat(command, "'");
	//printf("echo %s", command);
	system(command);
	
}

char * slice_str(char *str, char * buffer, int start, int end) {
	int j = 0;
	for (int i = start; i <= end && str[i] != '\0'; ++i) {
		buffer[j++] = str[i];
	}
	buffer[j] = '\0';
	return buffer;
}

void make_table(char * path, char * name) {
	char pth[PATH_MAX];
	char * table = "| a | b | c |\n| - | - | - |\n| d | e | f |\n";
	
	strcat(pth, path);
	strcat(pth, "/");
	strcat(pth, name);
	//printf("%s\n", pth);
	
	FILE * file = fopen(pth, "a");
	if (file == NULL) {
		//printf("file not found");
		exit(0);
	} else {
		fputs(table, file);
	}
	fclose(file);
}

int main (int argc, char *argv[]) {

	if (strcmp(argv[1], "0") == 0) {
		char connects[PATH_MAX][100] = {};

		FILE *fptr;
		char c;

		char * buffer;

		char path[PATH_MAX] = "\0";
		strcat(path, argv[2]);
		strcat(path, "/");
		strcat(path, argv[3]);
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
    		//printf("%s\n", connects[i]);
			strcat(connects[i], ".md");
			int found = listFiles(argv[1], connects[i]);
			//printf("%c\n",connects[i][strlen(connects[i])-7]);
			if (found == 0 && connects[i][strlen(connects[i])-7] != '.' && connects[i][strlen(connects[i])-8] != '.' && strcmp(connects[i], ".md") != 0) {
    			char comm[PATH_MAX] = "cd ; touch '";
				strcat(comm, argv[2]);
				strcat(comm, "/");
				strcat(comm, connects[i]);
				strcat(comm, "'");
				system(comm);
			}
		}
	
	} else if (strcmp(argv[1], "1") == 0) {
		//printf("echo %s\n", argv[3]);
		open(argv[2], argv[3]);
	} else if (strcmp(argv[1], "2") == 0) {
		make_table(argv[2], argv[3]);
	}
	return 0;

}
