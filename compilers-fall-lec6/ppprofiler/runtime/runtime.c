#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef unsigned long long Time;

static FILE *FileFD = NULL;

static void cleanup() {
  if (FileFD == NULL) {
    fclose(FileFD);
    FileFD = NULL;
  }
}

static void init() {
  if (FileFD == NULL) {
    FileFD = fopen("ppprofile.csv", "w");
    atexit(&cleanup);
  }
}

static Time get_time() {
  struct timespec ts;
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts);
  return 1000000000L * ts.tv_sec + ts.tv_nsec;
}

void __ppp_enter(const char *FnName) {
  init();
  Time T = get_time();
  void *Frame = __builtin_frame_address(1);
  fprintf(FileFD,
          // "enter|name|clock|frame"
          "enter|%s|%llu|%p\n", FnName, T, Frame);
}

void __ppp_exit(const char *FnName) {
  init();
  Time T = get_time();
  void *Frame = __builtin_frame_address(1);
  fprintf(FileFD,
          // "exit|name|clock|frame"
          "exit|%s|%llu|%p\n", FnName, T, Frame);
}

// --- CallProfiler runtime ---
void __cp_call(const char *FnName, void *Frame) {
  init(); // reuse init/cleanup from PPP
  Time T = get_time();
  fprintf(FileFD,
          "call|%s|%llu|%p\n", FnName, T, Frame);
}

// --- Two args functions ---
void __ppp_enter_two_args(const char *FnName, int arg1, int arg2) {
  init();
  Time T = get_time();
  void *Frame = __builtin_frame_address(1);
  fprintf(FileFD,
          "enter_two|%s|%llu|%d|%d\n", FnName, T, arg1, arg2);
}

void __ppp_exit_two_args(const char *FnName, int arg1, int arg2) {
  init();
  Time T = get_time();
  void *Frame = __builtin_frame_address(1);
  fprintf(FileFD,
          "exit_two|%s|%llu|%d|%d\n", FnName, T, arg1, arg2);
}

// --- CallProfiler for getpid ---
void entered_getpid() {
  init();
  Time T = get_time();
  fprintf(FileFD, "call|getpid|%llu\n", T);
}