kl#Finds the most occuring words in the program
#Akshay Chandiramani s1558717
#The basic logic remains that each word is followed by a delimiting character
#and we can ignore the rest of the delimiting characters 
#----------- ------------------------------------


        .data
prompt1:        .asciiz "\ninput: "
prompt2:        .asciiz "\n"
prompt3:        .asciiz "output:\n"
word:           .space 51
input_sentence: .space 1001
proc_sentence:  .space 1001          #The processed sentence
frq_array:      .word 500

        .globl main
        
        .text 
        
main: 
   
        li   $s1, 0                  #unique_words
        li   $s2, 0                  #max_freq
        subi $s2, $s2, 1             #max_freq
        li   $s3, 0                  #num_words_w_max_freq
        li   $s6, 0                  #variable used for output
      
        jal read_input               #read_input(input_sentence);
        jal process_input            #process_input(input_sentence);
        jal print_output             #output(num_unique_words, max_frequency, num_words_with_max_frequency, word);
        j read_input
        
read_input:   

        li   $v0, 4                  #print_string("\ninput: ");
        la   $a0, prompt1
        syscall
        
        li   $v0, 8                  #read_string(input_sentence, MAX_CHARS);
        la   $a0, input_sentence 
        la   $a1, 1001
        syscall
        
        jr   $ra
        
print_output:

        li   $v0, 4                  #print_string("output:\n");
        la   $a0, prompt3
        syscall
        
        li   $v0, 1                  #print_int(unique_words);
        la   $a0, ($s1)
        syscall
        
        li   $v0, 4                  #print_string("\n");
        la   $a0, prompt2 
        syscall
        
        li   $v0, 1                  #print_int(max_freq);
        la   $a0, ($s2)
        syscall
        
        li   $v0, 4                  #print_string("\n");
        la   $a0, prompt2 
        syscall
        
        li   $v0, 1                  #print_int(num_words_w_max_freq);
        la   $a0, ($s3)
        syscall
        
        li   $v0, 4                  #print_string("\n");
        la   $a0, prompt2 
        syscall
        
        li   $v0, 4                  #print_string(out);
        la   $a0, word
        syscall
        
        li   $v0, 4                  #print_string("\n");
        la   $a0, prompt2 
        syscall
        
        jr   $ra
        
process_input:

        li   $t0, '\0'               #cur_char
        li   $t1, 0                  #word_found
        li   $t2, 0                  #end_of_sentence
        li   $t3, 0                  #number_of_words   
        li   $s4, 0                  #char_index
        li   $t5, 0                  #loop_variable
     
Loop1:  beqz $t2, word_input
        
word_input: 
      
        lb   $t0, input_sentence($t5)#checks if delimiting character in input
        li   $t4, ' '                #cur_char == ' '
        beq  $t0, $t4, cond1
        li   $t4, '.'                #cur_char == '.'
        beq  $t0, $t4, cond1
        li   $t4, '!'                #cur_char == '!'
        beq  $t0, $t4, cond1
        li   $t4, '?'                #cur_char == '?' 
        beq  $t0, $t4, cond1
        li   $t4, '_'                #cur_char == '_'
        beq  $t0, $t4, cond1
        li   $t4, '-'                #cur_char == '-'
        beq  $t0, $t4, cond1
        li   $t4, '('                #cur_char == '('
        beq  $t0, $t4, cond1
        li   $t4, ')'                #cur_char == ')'
        beq  $t0, $t4, cond1
        li   $t4, '\0'               #cur_char == '\0'
        beq  $t0, $t4, cond1
        li   $t4, '\n'               #cur_char == '\n'
        beq  $t0, $t4, cond1
        sb   $t0, proc_sentence($s4) #words[pos][char_index] = cur_char;
        addi $s4, $s4, 1             #char_index++;
        li   $t4, 1 
        beq  $t1, $t4, cond2         #word_found = 1
        addi $t5, $t5, 1             #Increments to loop variable
        j Loop1

cond1:  li   $t4, '\n'               
        beq  $t0, $t4, assg1         #cur_char == '\n'
        slt  $t1, $zero, $t3         #word_found = 1 if char_index (number of words) > 1
        addi $t5, $t5, 1             #increment to next byte
        j Loop1

assg1:  li   $t2, 1                  #end_of_sentence = 1;
        j further_process

cond2:  li   $t1, 0                  #word_found = 0;
        li   $t4, '\0'
        sb   $t4, proc_sentence($s4) #Appending the null character
        addi $s4, $s4, 1             #Increasing the character index in the 1D array
        addi $t3, $t3, 1             #Counting the number of words
        addi $t5, $t5, 1             #Increments the loop variable
        j Loop1

further_process:

        li   $s5, 0                  #Counter variable for storing values in frequency array
        li   $t4, 0                  #Loop variable 
        la   $t4, ($t3)              #Number of words/loop variable 
        li   $t5, 1                  #For storing 1 initially into the frequency array
        
cond3:  bne  $t4, $zero, assg2       #If we haven't covered all indexes for words 
        j m_code

assg2:  sw   $t5, frq_array ($s5)    #freq_word[i] = 1
        addi $s5, $s5, 4             #We increment the counter variable here
        subi $t4, $t4, 1             #We decrement the loop variable here 
        j cond3
        
m_code: li   $s6, 0                  #offset for outer loop
        la   $t5, ($s6)              #temporary variable incremented during comparison
        li   $s4, 0                  #Outer loop variable
        li   $s5, 0                  #inner loop variable
        
L_once: la   $t4, proc_sentence($t5)     #Load address of corresponding string input
        li   $t6, '\0'               
        li   $t8, '\n'
        lb   $t7, ($t4)
        beq  $t7, $t8, further_process2  #We exit the loop if we have reached end of the string
        addi $t5, $t5, 1                 #Keep incrementing the temporary variable until we reach the next word
        bne  $t7, $t6, L_once
        addi $s5, $s5, 1                 #increment the inner loop variable             
        li   $s7, 0                      #offset for the string without the first word
        addi $s7, $t5, 1                 #offset for getting the words after this respective word
                                
C_Loop: li   $t4, 0                      #loop variable l

Compare_Loop:

        li   $t6, '\0'
        li   $t7, '\n'             
        lb   $t8, proc_sentence ($t5)    
        lb   $t9, proc_sentence ($s7)    
        beq  $t9, $t7, OLoop3        #We exit the loop if we have reached the end of the string
        beq  $t8, $t6, ILoop3        #If either words are terminated first, go to the Inner loop
        beq  $t9, $t6, ILoop3 
        addi $s7, $s7, 1             #i.e all words after the word have been compared with the respective word here
        addi $t5, $t5, 1             #incrementing both offsets for comparision
        bne  $t8, $t6, cond4         #words[i][k] != '\0' && words[j][k] != '\0';
        j ILoop3
cond4:  bne  $t9, $t6, cond5          
        j ILoop3
cond5:  bne  $t8, $t9, assg3         #words[i][k] != words[j][k];
        j ILoop3
assg3:  addi $t4, $t4, 1             #l++;
        j comp
        
comp:   beq  $t4, $zero, assg4       #if (l==0)
        j ILoop3
        
assg4:  la   $t6, ($s4)              #freq_word[i]++; 
        li   $t7, 4                  #Here, since frq_array is an integer array, we have to create the right offset
        mul  $t6, $t6, $t7           #We therefore multiply the byte offset of the outer loop by 4 
        lw   $t8, frq_array ($t6)    #Then we load the value, increment it by 1, and store it back
        addi $t8, $t8, 1
        sw   $t8, frq_array ($t6)   
        
        la   $t7, ($s5)              #freq_word[j] = 0;
        li   $t6, 4                  #We follow a similar process to that in the previous, except for we store 0 directly
        mul  $t7, $t7, $t6           
        li   $t8, 0
        sw   $t8, frq_array ($t7)
        j C_Loop
        
ILoop3: la   $t5, ($s6)              #We load back the respective word value of the outer loop i for comparison with all
        addi $s5, $s5, 1             #words ahead. We also increment the other words ahead value by 1
        addi $s7, $s7, 1
        j C_Loop
        
OLoop3: la   $t4, frq_array ($s6)    #We increment the offset of the outer loop here, so that o
        li   $t6, '\0'               #we go on to the next word for comparison
        li   $t8, '\n'
        lb   $t7, ($t4)
        beq  $t7, $t8, further_process2  #We terminate comparison if the newline is reached 
        addi $s6, $s6, 1
        bne  $t7, $t6, OLoop3
        addi $s4, $s4, 1             #Increment the outer loop variable 
        addi $s5, $s4, 1             #Inner is set to outer + 1 to give us the index of the next word 
        la   $t5, ($s6)
        j C_Loop
        
further_process2:
        
        li   $s5, 0
Loop4:  la   $t4, ($t3)              #loop variable on number of words (t3 is global containing number)
        lw   $t5, frq_array($s5)     #load individual values from the frequency array to compare
        bne  $t4, $zero, cond6
        j further_process3
        
cond6:  slt  $t6, $zero, $t5         #freq_word[i] > 0
        bne  $t6, $zero, assg5
        subi $t4, $t4, 1             #increment the pointer variable, decrement the loop variable
        addi $s5, $s5, 4
        j Loop4
                                      
assg5:  addi $s1, $s1, 1             #num_unique_words++
        subi $t4, $t4, 1
        addi $s5, $s5, 4
        j Loop4
  
further_process3:       

        
        li   $s5, 0                  #frq_array variable used in the following blocks
        la   $t4, ($t3)              #pointer variable
  
Loop_b: li   $t7, 0                  #position or index of word
        li   $s6, 0         
Loop5:  lw   $t5, frq_array ($s5)    
        addi $t7, $t7, 1             #number of words 
        subi $t4, $t4, 1             #decrimenting loop variable
        addi $s5, $s5, 1        
        bne  $t4, $zero, cond7
        j final_loop
        
cond7:  slt  $t6, $s2, $t5           #max_frequency < freq_word [i]
        bne  $t6, $zero, assg6
        j Loop5   
        
assg6:  sw   $t5, ($s2)              #max_frequency = freq_word[i]
              
OLoop7: li   $s0, 0
        la   $a0, ($t7)              #position of word. Runs outer loop * inner loop 
        subi $a0, $a0, 1             #to take us to starting letter of that specific word beginning
        bne  $a0, $zero, ILoop7
        j store
          
ILoop7: lb   $t8, proc_sentence ($s0)
        li   $t9, '\0'
        addi $s0, $s0, 1
        bne  $t8, $t9, ILoop7
        addi $s0, $s0, 1
        j OLoop7
        
store:  lb   $t8, proc_sentence ($s0)    #Rechecking if our string is not empty
        li   $t9, '\0'
        bne  $t8, $t9, actual_store
        j Loop5
        
actual_store:
       
        sb   $t8, word ($s6)             #word[j] = words[i][j];
        addi $s0, $s0, 1 
        addi $s6, $s6, 1
        j store
        
final_loop: 
 
        li   $s5, 0     
Loop8:  la   $t4, ($t3)                  #loop variable again
        lw   $t5, frq_array ($s5)
        bne  $t4, $zero, cond8           #If we haven't parsed all words 
        j final
           
cond8:  beq  $s2, $t5, assg8             #if(max_frequency == freq_word[i])
        subi $t4, $t4, 1                 #decrementing loop variable
        addi $s5, $s5, 4                 #incrementing pointer variablee
        j Loop8     
                 
assg8:  addi $s3, $s3, 1                 #num_words_with_max_frequency++;
        subi $t4, $t4, 1
        addi $s5, $s5, 4
        j Loop8
        
final:  jr   $ra
        
        
           
        
