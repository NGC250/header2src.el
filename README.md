This function is useful to create a source file from a header with extern declarations.

For example, consider the following globals header located at "/path/globals.h" relative to the current file:
 ```c
#ifndef GLOBALS_H
#define GLOBALS_H

#include <stdint.h>
#include <stdbool.h>

extern uint64_t Jonathan , Joseph;

typedef struct
{
  double *platinum;
}
 Jotaro;

extern Jotaro ORA;

extern double* Josuke; //this is a comment

const uint64_t Giorno;
extern uint8_t Jolyne;

//reboot variables
uint8_t Johnny , Josuke_8; // for whatever reason you have a static declaration inside a header
extern bool Jodio;

#endif
```

Becomes:

```c
#include "/path/globals.h"

uint64_t Jonathan , Joseph;
Jotaro ORA;
double* Josuke; //this is a comment
uint8_t Jolyne;
bool Jodio;
```
The function adds include directive automatically.
