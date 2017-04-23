#!/bin/bash
lex lex.l
yacc -d yacc.y --verbose
gcc -w lex.yy.c y.tab.c -ll
if [ $? -ne 0 ]
then
    echo "Compile failed!"
    exit 1
fi
# tput reset
./a.out input.txt
if [ $? -ne 0 ]
then
    echo "Execution failed!"
    exit 1
fi
rm -rf ./a.out ./lex.yy.c ./y.tab.c ./y.tab.h
# echo -e "\n\nGenerated program is:\n"
# cat out.cpp
g++ out.cpp functions.cpp -o myprog
echo -e "\n\nExecuting program....\n"
./myprog
rm -rf ./myprog