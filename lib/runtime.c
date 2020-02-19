typedef unsigned int size_t;
extern int printf(const char *format, ...);
extern int scanf(const char *format, ...);
extern void exit(int status);
extern size_t strlen(const char *s);
extern void *malloc(size_t size);
extern char *strcpy (char* strTo, const char* strFrom);
extern int strcmp(const char *s1, const char *s2);

struct __sFile
{
    int unused;
};
typedef struct __sFile FILE;

size_t getline(char **lineptr, size_t *n, FILE *stream);


extern FILE *stdin;
extern FILE *stderr;

#define stdin stdin
#define stderr stderr

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
    scanf("\n");
    char *result = (char*)malloc(sizeof(char));
    size_t length;
    getline(&result, &length, stdin);
    length = strlen(result);
    result[length - 1] = '\0';
    return result;
}

int readInt() {
    scanf("\n");
    int n;
    scanf("%d", &n);
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

char* emptyString() {
    char *result = malloc(sizeof(char));
    strcpy (result, "");
    return result;
}

void* allocateMemory(int bytes) {
    return (void*)malloc(bytes);
}