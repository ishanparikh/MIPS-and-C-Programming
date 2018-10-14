// =========================================================================
//
// Find most occuring word in a sentence
//
// Inf2C-CS Coursework 1. Task B
// OUTLINE code, to be completed as part of coursework.
//
// Boris Grot, Priyank Faldu
// October 11, 2016
//
// =========================================================================


// C Header files
#include <stdio.h>

#include <stdio.h>

void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(char c)    { printf("%c", c); }   
void print_int(int num)    { printf("%d", num); }
void print_string(char* s) { printf("%s", s); }


// Maximum characters in an input sentence including terminating null character
#define MAX_CHARS 1001

// Maximum characters in a word including terminating null character
#define MAX_WORD_LENGTH 51

char input_sentence[MAX_CHARS];
char word[MAX_WORD_LENGTH];
int num_unique_words = 0;
int max_frequency = -1;
int num_words_with_max_frequency = 0;

int read_input(char* inp) {
    print_string("\ninput: ");
    read_string(input_sentence, MAX_CHARS);
}

void output(int unique_words, int max_freq, int num_words_w_max_freq, char* out) {
    print_string("output:\n");
    print_int(unique_words);
    print_string("\n");
    print_int(max_freq);
    print_string("\n");
    print_int(num_words_w_max_freq);
    print_string("\n");
    print_string(out);
    print_string("\n");
}

///////////////////////////////////////////////////////////////////////////////
//
// DO NOT MODIFY CODE ABOVE
//
///////////////////////////////////////////////////////////////////////////////

// ADD CUSTOM FUNCTIONS AND OTHER GLOBAL VARIABLES AS NEEDED

void process_input(char* inp) {
    // Populate following global variables
    // num_unique_words
    // max_frequency,
    // num_words_with_max_frequency
    // word
    
    // You may define more local variables here
    // and call custom functions from here
    
    char words[500][MAX_WORD_LENGTH];
    
    int char_index = 0;
    int pos = 0;
    char cur_char = '\0';
    int word_found = 0;
    int input_index = 0;
    int end_of_sentence = 0;

    
    while (end_of_sentence == 0)
    {
        cur_char = inp[input_index];
        
        if (cur_char == ' ' || cur_char == '.' || cur_char == '!' || cur_char == '?' || cur_char == '_' || cur_char == '-' || cur_char == '(' || cur_char == ')' || cur_char == '\0' || cur_char == '\n')
        {
            if (cur_char == '\n')
                end_of_sentence = 1;
            if(char_index > 0)
                word_found = 1;
        }
    
        else
        {
            words[pos][char_index] = cur_char;
            char_index++;
        }
        
        if (word_found == 1)
        {
            word_found = 0;
            words[pos][char_index] = '\0';
            pos++;
            char_index = 0;
        }
        
        input_index++;
    }
    
    
    int freq_word[pos];
    
    int i=0;   //loop variables
    int j=0;
    int k=0;
    
    for (i=0; i<pos; i++)
    {
        freq_word[i] = 1;
    }
    
    
    for (i=0; i<pos-1; i++)
    {
        if (words[i][0] != '\0')
        {
            int comp_index = i+1;
            for(j=comp_index; j<pos; j++)              //loops across the entire set of words
            {
                if (words[j][0] != '\0')
                {
                    int l = 0;
                    for(k=0; k<MAX_WORD_LENGTH; k++)
                    {
                        if(words[i][k] != '\0' && words[j][k] != '\0')
                        {
                            if(words[i][k] != words[j][k])
                                l++;
                        }
                    }
                    if (l==0)
                    {
                        words[j][0] = '\0';
                        freq_word[j] = 0;
                        freq_word[i]++;          //Number of occurences of the word at that index
                    }
                }
                comp_index++;
            }
        }
    }
    
    for(i=0; i<pos; i++)
    {
        if(freq_word[i] > 0)
        {
            num_unique_words++;
        }
    }
    
    for(i=0; i<MAX_WORD_LENGTH; i++)
    {
        word[i] = '\0';
    }
    
    for(i=0; i<pos; i++)
    {
        if(max_frequency < freq_word [i])
        {
            max_frequency = freq_word[i];
            for (j=0; j<MAX_WORD_LENGTH; j++)
            {
                if(words[i][j] != '\0')
                    word[j] = words[i][j];
            }
        }
    }
    
    for(i=0; i<pos; i++)
    {
        if(max_frequency == freq_word[i])
        {
            num_words_with_max_frequency++;
        }
    }
    
}

///////////////////////////////////////////////////////////////////////////////
//
// DO NOT MODIFY CODE BELOW
//
///////////////////////////////////////////////////////////////////////////////

int main() {

    while(1) {

        num_unique_words = 0;
        max_frequency = -1;
        num_words_with_max_frequency = 0;
        word[0] = '\0';

        read_input(input_sentence);

        process_input(input_sentence);

        output(num_unique_words, max_frequency, num_words_with_max_frequency, word);
    }
}
