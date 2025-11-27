#include <stdio.h>
#include <unistd.h>

int main() {
    printf("Start\n");
    
    pid_t pid1 = getpid();
    printf("PID1: %d\n", pid1);
    
    pid_t pid2 = getpid(); 
    printf("PID2: %d\n", pid2);
    
    return 0;
}