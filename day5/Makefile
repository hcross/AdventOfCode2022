CC=gcc
CFLAGS=-W -Wall -Wunused-parameter -ansi -pedantic -std=c99 -g 
SRC=src/
BUILD=build/
EXEC=day5

all: $(EXEC)

day5: $(SRC)day5.c
	mkdir -p $(BUILD)
	$(CC) -o $(BUILD)$@ $^ $(CFLAGS) 

$(BUILD)%.o : $(SRC)%.c
	$(CC) -o $(BUILD)$@ -c $< $(CFLAGS) 

clean:
	rm -rf $(BUILD)