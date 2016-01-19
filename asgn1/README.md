# Lexical analysis assignment

**How to build**

-To test, run 'make' from /asgn1

-To clean, run 'make clean' from /asgn1

**How to test**

-cd asgn1

-./bin/lexer test/<filename>.py

**Issues**

-We have not handled INDENT and DEDENT as tokens(yet).

-Strings are assumed to use double quotes, in reality, Python uses single quotes, double quotes, and a combination of these.

-Python defines 'print' as a function in Python 3, while it is a keyword in Python 2.7. We stick to the former, thus making it an identifier. Issue arises if using 'print "Hello"' instead of 'print("Hello")'.

-And so on.
