#include <pthread.h>
#include <sys/stat.h>
#include <assert.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

#define OUTERDIR "_test_dir_"
#define INNERDIR "_test_dir_/sub"

int res_rm, err_rm;

void * remover(void * arg) {
  assert(arg == NULL);

  res_rm = rmdir(OUTERDIR);
  err_rm = errno;

  assert(res_rm != -1 || err_rm == ENOTEMPTY);

  return NULL;
}

int res_mk, err_mk;
int res_st, err_st;
struct stat st;

void * maker_stater(void * arg) {
  assert(arg == NULL);

  res_mk = mkdir(INNERDIR, 0755);
  err_mk = errno;

  res_st = stat(OUTERDIR, &st);
  err_st = errno;

  assert(res_mk != -1 || err_mk == ENOENT);

  return NULL;
}

#define DEBUG 0

int test(int it) {
  pthread_t one, two;
  int res_inner, err_inner, res_outer, err_outer;

  assert(mkdir(OUTERDIR, 0755) == 0);

  assert(pthread_create(&one, NULL, remover, NULL) == 0);
  assert(pthread_create(&two, NULL, maker_stater, NULL) == 0);
  assert(pthread_join(one, NULL) == 0);
  assert(pthread_join(two, NULL) == 0);

  res_inner = rmdir(INNERDIR);
  err_inner = errno;
  res_outer = rmdir(OUTERDIR);
  err_outer = errno;
  if(DEBUG)
    printf("Inner: %d, %d; Outer: %d, %d\n", res_inner, err_inner, res_outer, err_outer);

  int consistent = (res_mk == -1 && res_st == -1) || (res_mk != -1 && res_st != -1);
  if(!consistent) {
    printf("Inconsistency found at iteration %d\n", it);
    fflush(stdout);
    assert(0);
  }

  return 0;
}

int main() {
  int i;

  for (i = 0; i < 1000000; i++) {
    if(i % 10000 == 0) printf("%d\n", i);
    test(i);
  }

  return 0;
}
