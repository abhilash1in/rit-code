## RIT CODE

Esoteric Programming language for dummies

### Dependencies
Lex/Flex

YACC/Bison

### Input

Write your code in `input.txt`


### Execution - Linux

```
chmod 777 exec.sh
./exec.sh
```
### Execution - Windows (Untested)

```
lex lex.l
yacc -d yacc.y
gcc -w lex.yy.c y.tab.c -ll
system("a.exe input.txt")
g++ out.cpp functions.cpp -o myprog
system("myprog.exe")

```