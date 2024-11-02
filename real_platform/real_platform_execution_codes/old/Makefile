main: main.o function.o
	cc -o main main.o function.o -lpthread -lrt

main.o: main.c function.h
	cc -c main.c

function.o: function.c function.h


clean:
	rm main.o function.o