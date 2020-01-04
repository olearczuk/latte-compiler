#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printInt(int n) {
    printf("%d\n", n);
}

void printString(const char *s) {
    printf("%s\n", s);
}

void error() {
    fprintf(stderr, "runtime error\n");
    exit(1);
}

char* readString() {
    char *result = (char*)malloc(sizeof(char));
    size_t length;
    getline(&result, &length, stdin);
    length = strlen(result);
    result[length - 1] = '\0';
    return result;
}

int readInt() {
    int n;
    scanf("%d", &n);
    // getchar() is a hack for situation
    // readInt(); readString();
    // without it readString() would read '\n' only
    getchar();
    return n;
}



char* addStrings(const char *s1, const char *s2) {
    char *result = malloc(strlen(s1) + strlen(s2) + 1);
    strcpy (result, s1);
    strcat (result, s2);
    return result;
}

int compareStrings(const char *s1, const char *s2) {
    return strcmp(s1, s2);
}