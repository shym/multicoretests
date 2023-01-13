#include <pthread.h>
#include <sys/stat.h>
#include <assert.h>
#include <semaphore.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>

#define TESTDIR "_test_dir_"

struct args_s {
  sem_t *p;
  sem_t *w;
  int r;
  int err;
};

void * remover(void * arg) {
#define ARG ((struct args_s *) arg)

  /* Make sure both threads are running to increase the chance of two
   * parallel calls to rmdir */
  assert(sem_post(ARG->p) == 0);
  assert(sem_wait(ARG->w) == 0);

  ARG->r = rmdir(TESTDIR);
  ARG->err = errno;

  return NULL;
}

struct args_s aone, atwo;
sem_t alpha, beta;

int main(int argc, char *argv[]) {
  pthread_t one, two;

  assert(sem_init(&alpha, 0, 0) == 0);
  assert(sem_init(&beta, 0, 0) == 0);

  assert(mkdir(TESTDIR, 0755) == 0);

  aone.p = &alpha;
  aone.w = &beta;
  atwo.p = &beta;
  atwo.w = &alpha;

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
