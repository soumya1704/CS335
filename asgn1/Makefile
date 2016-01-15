all: bin/lexer
bin/lexer: lex.yy.c 
	mkdir bin
	gcc -Isrc/ lex.yy.c src/lexforpy.c -o bin/lexer
	rm lex.yy.c
lex.yy.c: src/lexforpy.l
	lex src/lexforpy.l
clean:
	rm -r bin/	