#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "hello.h"

static int tests_passed = 0;
static int tests_failed = 0;

static void run_test(const char *test_name, const char *input, const char *expected)
{
    char    buf[256];
    FILE   *tmp;
    int     saved_stdout;

    tmp = tmpfile();
    if (!tmp)
    {
        fprintf(stderr, "FAIL [%s]: could not create tmpfile\n", test_name);
        tests_failed++;
        return;
    }

    /* Flush any pending output before redirecting stdout */
    fflush(stdout);

    /* Save original stdout and redirect to temp file */
    saved_stdout = dup(STDOUT_FILENO);
    if (saved_stdout < 0)
    {
        fprintf(stderr, "FAIL [%s]: dup failed\n", test_name);
        fclose(tmp);
        tests_failed++;
        return;
    }
    if (dup2(fileno(tmp), STDOUT_FILENO) < 0)
    {
        fprintf(stderr, "FAIL [%s]: dup2 failed\n", test_name);
        close(saved_stdout);
        fclose(tmp);
        tests_failed++;
        return;
    }

    say_hello(input);
    fflush(stdout);

    /* Restore stdout */
    dup2(saved_stdout, STDOUT_FILENO);
    close(saved_stdout);

    rewind(tmp);
    memset(buf, 0, sizeof(buf));
    fread(buf, 1, sizeof(buf) - 1, tmp);
    fclose(tmp);

    if (strcmp(buf, expected) == 0)
    {
        printf("PASS [%s]\n", test_name);
        tests_passed++;
    }
    else
    {
        printf("FAIL [%s]: expected \"%s\", got \"%s\"\n", test_name, expected, buf);
        tests_failed++;
    }
}

int main(void)
{
    run_test("say_hello World",  "World",  "Hello, World!\n");
    run_test("say_hello Alice",  "Alice",  "Hello, Alice!\n");
    run_test("say_hello 42",     "42",     "Hello, 42!\n");
    run_test("say_hello empty",  "",       "Hello, !\n");

    printf("\nResults: %d passed, %d failed\n", tests_passed, tests_failed);
    return (tests_failed > 0) ? 1 : 0;
}
