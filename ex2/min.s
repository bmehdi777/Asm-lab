# Planning : -The name of the addresse where th elist of numbers starts as
#						 data_item.
#						 -The last number in the list will be a 0
#						 -%edi will hold the current position in the list
#						 -%ebx will hold the current highest value in the list
#						 -%eax will hold he current element being examined
#
# Steps: - Check the current list element (%eax) to see if it's zero 
#						(terminating element)
#				 - if it is zero, exit
#				 - Increase the current position (%edi)
#				 - Load the next value in the list into the current value register
#						(%eax). What addressing mode might we use here ? Why ? (I think
#						indirect memory addressing, because we deal with arrays)
#				 - Compare the current value register (%eax) with the current highest
#						vluae (%ebx)
#				 - If the current value is greater thant the current highest value,
#						replace the current highest value with the current value
#				 - Repeat

.section .data
data_items:
	.long 3,67,34,222,45,75,54,34,44,33,22,11,66,254,256 
# even if it's long type (4bytes storages), the max number can't be more than
# 255 (otherwise we get weird number on exit status)
# Actually, process can't have more than 255 as a code status


.section .text
.global _start

_start:
	movl $0, %edi			# move 0 into the index register
	movl data_items(,%edi,4), %eax		# load the first byte of data
	movl %eax, %ebx		# since this is the first item, %eax is the biggest

start_loop:	# start loop
	cmpl $256, %eax			#check to see if we've hit the end
# The result of the cmpl (comparison) is stored in a particular registers :
# %eflags also known as the status register
	je loop_exit
# je means jump equal : it checks the status of the previous statements (
# in reality it checks that in %eflags )
# je needs to be preceeded by a comparison
	incl %edi			# load the next value
	movl data_items(,%edi, 4), %eax
	cmpl %ebx, %eax		# compare values
	jge start_loop		# jump to loop beginning if the new one isn't bigger

	movl %eax, %ebx		# move the value as the largest
	jmp start_loop

loop_exit:
	# %ebx is the status code for the exit system call and it already
	# has the maximum number
	mov $1, %eax
	int $0x80
		
