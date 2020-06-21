#include <stdio.h>
#include <stdlib.h>
#include "structures.h"

#define MAX_LEN 256
#define MAX_NAME_LEN 20

// Reads a text file to the freq array, which stores number of occurences of
// each character in the file
void read_file(char name[], int freq[]) {
  FILE *input;

	input = fopen(name, "r");
	if (input == NULL) {
		printf("Error opening the input file.");
		exit(EXIT_FAILURE);
	}

	char current;
	while ((current = fgetc(input)) != EOF) {
    freq[current]++;
	}

  fclose(input);
}

// Creates and inserts a new element of type struct Data at the end of an array
void insert_new_element(struct Data array[], char data, char num, int len) {
  struct Data tmp;
  tmp.data = data;
  tmp.num = num;
  array[len] = tmp;
}

// Sorts given array in ascending order, by number of occurences
void sort_array(struct Data array[], int len) {
  struct Data tmp;
  for (int i=0; i<len; i++) {
    for (int j=i; j<len; j++) {
      if (array[j].num < array[i].num) {
        tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
      }
    }
  }
}

// Stores an array of struct Data into array passed in the argument. The array
// is ascending oreder sorted. Length of the array is stored in len. Number of
// occurences of characters is stored in freq
void make_array(struct Data array[], int *len, int freq[]) {
  int tmp_len = 0;
  for (int i=0; i < MAX_LEN; i++) {
      if (freq[i] != 0) {
        insert_new_element(array, i, freq[i], tmp_len);
        tmp_len++;
      }
  }
  sort_array(array, tmp_len);
  *len = tmp_len;
}


int main(int argc, char* argv[]){

  int freq[MAX_LEN] = {0};
  struct Data array[MAX_LEN];
  char name[MAX_NAME_LEN];

  printf("Enter text file name: ");
  scanf("%s", name);

  read_file(name, freq);
  int len = 0;
  make_array(array, &len, freq);

  printf("Result:\n");
  for (int i=0; i<len; i++) {
    printf("%c - %d\n", array[i].data, array[i].num);
  }

	return 0;
}
