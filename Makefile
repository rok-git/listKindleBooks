#CC = cc -framework Foundation
CC = cc 
LDFLAGS = -framework Foundation
#CFLAGS = -fobjc-arc -g
CFLAGS = -fobjc-arc -arch x86_64

OBJ = BookEntry.o listKindleBooks.o
PROG = listKindleBooks

$(PROG): $(OBJ)

.PHONY: clean
clean :
	rm $(PROG) $(OBJ)
