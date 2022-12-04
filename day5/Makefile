CC=gcc
CFLAGS=-W -Wall -Wunused-parameter -ansi -pedantic -std=c99 -g 
SRC=src/
BUILD=build/
EXEC1=day5-1
EXEC2=day5-2

all: $(EXEC1) $(EXEC2)

day5-1: $(SRC)day5-1.c
	mkdir -p $(BUILD)
	$(CC) -o $(BUILD)$@ $^ $(CFLAGS) 

day5-2: $(SRC)day5-2.c
	mkdir -p $(BUILD)
	$(CC) -o $(BUILD)$@ $^ $(CFLAGS) 

$(BUILD)%.o : $(SRC)%.c
	$(CC) -o $(BUILD)$@ -c $< $(CFLAGS) 

clean:
	rm -rf $(BUILD)