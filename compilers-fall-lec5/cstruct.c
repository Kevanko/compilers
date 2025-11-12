
#include <stdint.h>
struct C {
  uint8_t visible;
  uint64_t x, y;
};
int main() { struct C c; c.visible = 1; c.x = 2; return 0; }

