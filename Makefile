#CC = cc -framework Foundation
CC = cc 
LDFLAGS = -framework Foundation
#CFLAGS = -fobjc-arc -g
CFLAGS = -fobjc-arc

OBJ = BookEntry.o listKindleBooks.o

listKindleBooks: $(OBJ)

