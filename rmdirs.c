#include <pthread.h>
#include <sys/stat.h>
#include <assert.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

#define TESTDIR "_test_dir_"

struct args_s {
  int r;
  int err;
};

void * remover(void * arg) {
#define ARG ((struct args_s *) arg)

  ARG->r = rmdir(TESTDIR);
  ARG->err = errno;

  return NULL;
}

struct args_s aone, atwo;

int main(int argc, char *argv[]) {
  pthread_t one, two;

  assert(mkdir(TESTDIR, 0755) == 0);

  assert(pthread_create(&one, NULL, remover, &aone) == 0);
  assert(pthread_create(&two, NULL, remover, &atwo) == 0);
  assert(pthread_join(one, NULL) == 0);
  assert(pthread_join(two, NULL) == 0);

  if(argc > 1 && strcmp(argv[1], "-v") == 0) {
    if(aone.r != 0)
      printf("1 failed with error %d: %s\n", aone.err, strerror(aone.err));
    if(atwo.r != 0)
      printf("1 failed with error %d: %s\n", atwo.err, strerror(atwo.err));
    fflush(stdout);
  }

  assert(aone.r != 0 || atwo.r != 0);

  return 0;
}
