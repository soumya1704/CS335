all: bin/parser
bin/parser: lex.yy.c yaccforpy.tab.c 
	mkdir bin
	g++ lex.yy.c yaccforpy.tab.c -lfl -o bin/parser
	rm lex.yy.c yaccforpy.tab.c yaccforpy.tab.h
lex.yy.c: src/lexforpy.l yaccforpy.tab.h
	lex src/lexforpy.l
yaccforpy.tab.h: src/yaccforpy.y
	bison -d src/yaccforpy.y
clean:
	rm -r bin/	