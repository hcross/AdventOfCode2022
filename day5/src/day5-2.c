// ===================
// Advent of Code 2022
// Day 5 with C
// ===================

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef unsigned int bool;
#define false 0u;
#define true 1u;

static const unsigned int STACK_CAPACITY = 'Z'-'A';
static const char FILENAME[] = "input";
static const int BUFFER_SIZE = 36;
static const int HEADER_BUFFER_SIZE = STACK_CAPACITY + 1;
static const char HEADER_STARTING_CHAR = '[';
static const char HEADER_NO_VALUE = ' ';
static const int EMPTY_STACK = -1;
static const int NB_STACKS = 9;
static const int REAL_NB_STACKS = NB_STACKS+1;
static const char SEPARATOR[] = " ";

int *stacks_indexes;
char **stacks;

void init() {
    stacks_indexes = (int *) malloc(REAL_NB_STACKS * sizeof(int));             // eq. int[REAL_NB_STACKS]
    stacks = (char **) malloc(REAL_NB_STACKS * sizeof(char *));                // ep. char[REAL_NB_STACKS][STACK_CAPACITY]
    for (int i=0; i< REAL_NB_STACKS; i++)
        stacks[i] = (char *) malloc(STACK_CAPACITY * sizeof(char));
    
    for (int i=0; i<REAL_NB_STACKS; i++)
        stacks_indexes[i] = EMPTY_STACK;
}

void push(unsigned int stack_index, char c) {
    printf("\npush(%i,'%c') - stack size: %i", stack_index, c, stacks_indexes[stack_index]);
    stacks_indexes[stack_index] = stacks_indexes[stack_index]+1;
    stacks[stack_index][stacks_indexes[stack_index]] = c;
}

char pop(unsigned int stack_index) {
    printf("\npop(%i) - stack size: %i", stack_index, stacks_indexes[stack_index]);
    if (stacks_indexes[stack_index] == EMPTY_STACK) {
        sprintf(stderr, "Trying to pop en empty stack");
        return -1;
    }

    char c = stacks[stack_index][stacks_indexes[stack_index]];
    stacks_indexes[stack_index] = stacks_indexes[stack_index]-1;
    return c;
}

void reverse(unsigned int stack_index) {
    if (stack_index == NB_STACKS) {
        sprintf(stderr, "Trying to reverse the temp stack");
        return -1;
    }

    char c;
    int stack_size = stacks_indexes[stack_index];
    for (int i=0; i<=stack_size; i++) {
        c = pop(stack_index);
        push(NB_STACKS, c);
    }

    for (int i=0; i<=stack_size; i++) {
        stacks[stack_index][i] = stacks[NB_STACKS][i];
    }
    stacks_indexes[stack_index] = stack_size;
    stacks_indexes[NB_STACKS] = EMPTY_STACK;
}

void print_tops() {
    printf("\n");
    for (int i=0; i<NB_STACKS; i++) {
        if (stacks_indexes[i] >= 0)
            printf("%c", stacks[i][stacks_indexes[i]]);
    }
}

int main(int argc, char *argv[])
{
    init();

    FILE *file;
    file = fopen((char *)FILENAME, "r");
    if (file == NULL) {
        fprintf(stderr, "File %s\n cannot be opened", FILENAME);
        return -1;
    }

    printf("Fichier '%s' ouvert\n", FILENAME);
    bool header_done = false;
    char line[BUFFER_SIZE];
    while(fgets(line, BUFFER_SIZE, file) != NULL) {
        if (strlen(line) > 1) printf("(%i) %s", strlen(line), line);
        if (!header_done) {
            if (line[0] == ' ') {
                printf("Found end of header");
                for (int i=0; i<NB_STACKS; i++) reverse(i);
                header_done = true;
            } else if (line[0] == HEADER_STARTING_CHAR) {
                char c;
                for (int i=0; i<NB_STACKS; i++) {
                    c = line[i*4+1];
                    if (c != HEADER_NO_VALUE) push(i, c);
                }
            }
        } else {
            if (strlen(line) > 1) {
                strtok(line, SEPARATOR);
                int nb = atoi(strtok(NULL, SEPARATOR));
                strtok(NULL, SEPARATOR);
                int from = atoi(strtok(NULL, SEPARATOR))-1;
                strtok(NULL, SEPARATOR);
                int to = atoi(strtok(NULL, SEPARATOR))-1;
                char c;
                for (int i=0; i<nb; i++) {
                    c = pop(from);
                    push(NB_STACKS, c);
                }
                for (int i=0; i<nb; i++) {
                    c = pop(NB_STACKS);
                    push(to, c);
                }
            }
        }
    }

    print_tops();

    fclose(file);

    return 0;
}
