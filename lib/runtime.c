#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printInt(int n) {
    printf("%d\n", n);
}

void printString(const char* s) {
    printf("%s\n", s);
}

void error() {
    fprintf(stderr, "runtime error\n");
    exit(1);
}

int readInt() {
    int n;
    scanf("%d", &n);
    return n;
}

char* readString() {
	char* result = (char*)malloc(1);
    size_t length;
    getline(&result, &length, stdin);
    length = strlen(result);
    result[length - 1] = '\0';
    return result;
}