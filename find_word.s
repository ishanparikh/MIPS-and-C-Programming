#prints all words in a sentence
#Akshay Chandiramani s1558717 copyright
#-----------------------------------------
#Variable $s0 stores the string, 
#The function basically takes a string and prints every word on a newline. It thus prints a newline 
#Whenever it encounters a delimiting character. We assume that a string ends with a delimiting character.

        .data
prompt1:         .asciiz  "\ninput: "
prompt2:         .asciiz  "output:\n"
newline:         .asciiz  "\n"
max_chars:       .space 1001



                .globl main	
        
        .text 
        
main:
        li   $v0, 4                #print_string("\ninput: ");
        la   $a0, prompt1          
        syscall
        
        li   $v0, 8                #read_string(input_sentence, MAX_CHARS);
        la   $a0, max_chars        
        la   $a1, 1001
        syscall
        
        li   $v0, 4                #print_string(out);
        la   $a0, prompt2
        syscall
        
        
        la   $s0, max_chars
	
Loop: 	lb   $t0, ($s0)
        li   $t1, '\n'             
        beq  $t0, $t1, exit
        li   $t1, ' '
        beq  $t0, $t1, else
        li   $t1, ','
        beq  $t0, $t1, else 
        li   $t1, '.'
        beq  $t0, $t1, else
        li   $t1, '!'
        beq  $t0, $t1, else
        li   $t1, '?'
        beq  $t0, $t1, else
        li   $t1, '_'
        beq  $t0, $t1, else
        li   $t1, '-'
        beq  $t0, $t1, else
        li   $t1, '('
        beq  $t0, $t1, else
        li   $t1, ')'
        beq  $t0, $t1, else
	
        li   $v0, 11
        la   $a0, ($t0)
        syscall
	
        addi $s0, $s0, 1    
        lb   $t0, ($s0)
        li   $t1, ' '
        beq  $t0, $t1, new
        li   $t1, ','
        beq  $t0, $t1, new 
        li   $t1, '.'
        beq  $t0, $t1, new
        li   $t1, '?'
        beq  $t0, $t1, new
        li   $t1, '_'
        beq  $t0, $t1, new
        li   $t1, '-'
        beq  $t0, $t1, new
        li   $t1, '('
        beq  $t0, $t1, new
        li   $t1, ')'
        beq  $t0, $t1, new
	
        j Loop
	
else:   addi $s0, $s0, 1
        j Loop
        
new:    li   $v0, 4
        la   $a0, newline
        syscall
        j Loop

exit:   j main
 

	
        


	    

	    
	    
	    

	    
	    


		
