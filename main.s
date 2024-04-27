.data

	mlines: .space 4
	ncols:   .space 4
	mlines_b: .space 4
	ncols_b: .space 4
	p: .space 4
	x: .space 4
	y: .space 4
	k: .space 4
	o: .space 4
	m: .space 10
	matrix: .zero 1600  
	new_matrix: .zero 1600 
	formatscanf: .asciz "%d"
	formatscanfstring: .asciz "%s"
	formatprintf: .asciz "%d "
	endl: .asciz "\n"
	lineIndex: .space 4
	colIndex: .space 4
	counter_0: .long 0
	termen_curent: .long 0
	index_curent: .long 0
	nr_vecini: .long 0
	lungime: .long 0
	vector: .space 500
    len: .space 4
    lungime_mesaj_biti: .space 4
	lungime_cheie: .space 4
	cript: .space 500
	contor: .space 4
	printfhexa: .asciz "%0X"
	printf0x: .asciz "0x"
	printfstring: .asciz "%c"
	vector_decimal: .space 500

.text

.global main

main:

#Citim m
	push $mlines
	push $formatscanf
	call scanf
	add $8, %esp

#Cream m bordat
	mov mlines, %eax
	addl $2, %eax
	mov %eax, mlines_b


#Citim n
	push $ncols
	push $formatscanf
	call scanf
	add $8, %esp

#Cream n bordat
	mov ncols, %eax
	addl $2, %eax
	mov %eax, ncols_b


#Citim p
	push $p
	push $formatscanf
	call scanf
	add $8, %esp

#Citim perechile si cream matrix bordata
	mov $matrix, %edi
	mov $0, %ecx

et_p:
	cmp p, %ecx
	je et_k
	push %ecx
	push $x
	push $formatscanf
	call scanf
	add $8, %esp
	
	push $y
	push $formatscanf
	call scanf
	add $8, %esp
	
	pop %ecx
	
	mov x, %eax
	incl %eax
	mov %eax, x

	mov y, %eax
	incl %eax
	mov %eax,y

	mov x, %eax
	mull ncols_b
	addl y, %eax  
	movl $1, (%edi, %eax, 4)
	
	inc %ecx
	jmp et_p

#Citim k
et_k:
	push $k
	push $formatscanf
	call scanf
	add $8, %esp


#Copiem matrix in new_matrix
	mov ncols_b, %eax
	mull mlines_b
	movl %eax, lungime

	mov $0, %eax
	mov $0, %ecx
copie:
	cmp lungime, %ecx
	je evolutii

	lea matrix, %edi
	movl (%edi, %eax, 4), %ebx
	lea new_matrix, %edi
	movl %ebx, (%edi, %eax,4)

	incl %eax
	incl %ecx
	jmp copie

#Repetam procesul asta de k ori
evolutii:
	mov k, %ecx
	cmp $0, %ecx
	je citire_o


	movl $1, lineIndex
lines:
	mov lineIndex, %ecx
	cmp mlines, %ecx
	jg continue


	movl $1, colIndex
cols:
	mov colIndex, %ecx
	cmp ncols, %ecx
	jg next_line

	mov lineIndex, %eax
	mull ncols_b
	add colIndex, %eax

	lea matrix, %edi
#Termenul curent si indexul
	movl (%edi, %eax, 4), %ebx
	movl %ebx, termen_curent
	movl %eax, index_curent

#Calculam nr de vecini in viata
nr_vecini_in_viata:
	mov $0, %ecx
	

vecin_1:
	movl index_curent, %eax
	decl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_2

	incl %ecx

vecin_2:
	movl index_curent, %eax
	incl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_3

	incl %ecx

vecin_3:
	movl index_curent, %eax
	addl ncols_b, %eax
	decl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_4

	incl %ecx

vecin_4:
	movl index_curent, %eax
	addl ncols_b, %eax
	incl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_5

	incl %ecx

vecin_5:
	movl index_curent, %eax
	addl ncols_b, %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_6

	incl %ecx

vecin_6:
	movl index_curent, %eax
	subl ncols_b, %eax
	decl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_7

	incl %ecx

vecin_7:
	movl index_curent, %eax
	subl ncols_b, %eax
	incl %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je vecin_8

	incl %ecx

vecin_8:
	movl index_curent, %eax
	subl ncols_b, %eax
	movl  (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je conditii

	incl %ecx



#Conditii de moarte/nastere a celulelor
conditii:
	movl %ecx, nr_vecini


	movl termen_curent, %ebx
	cmp $0, %ebx
	je conditii_pt_0
	jmp conditii_pt_1

conditii_pt_0:
	movl nr_vecini, %eax
	cmp $3, %eax
	je celula_vie


conditii_pt_1:
	movl nr_vecini, %eax
	cmp $2, %eax
	jl celula_moarta

	cmp $3, %eax
	jg celula_moarta
	jmp next_element

celula_vie:
	lea new_matrix, %edi
	movl index_curent, %eax
	movl $1, (%edi, %eax, 4)
	jmp next_element

celula_moarta:
	lea new_matrix, %edi
	movl index_curent, %eax
	movl $0, (%edi, %eax, 4)

next_element:
	incl colIndex
	jmp cols

next_line:
	incl lineIndex
	jmp lines

continue:
#Copiem new_matrix in matrix
	mov ncols_b, %eax
	mull mlines_b
	movl %eax, lungime

	mov $0, %eax
	mov $0, %ecx
copie_reverse:
	cmp lungime, %ecx
	je next_evolutie

	lea new_matrix, %edi
	movl (%edi, %eax, 4), %ebx
	lea matrix, %edi
	movl %ebx, (%edi, %eax,4)

	incl %eax
	incl %ecx
	jmp copie_reverse

next_evolutie:
	decl k
	jmp evolutii

#Citim o (0 - criptare, 1 - decriptare)
citire_o:
	push $o
	push $formatscanf
	call scanf
	add $8, %esp

#Citim mesaj
mesaj:
	push $m
	push $formatscanfstring
	call scanf
	add $8, %esp	


	movl o, %eax
	cmp $0, %eax
	je criptare
	jmp decriptare


criptare:
		
	pushl $m
	call strlen
	addl $8, %esp
	mov %eax, len
	
	movl $0, %eax
	movl $0, %edx
	mov $m, %edi

next_litera:
	cmp len, %eax
	je for
	movl $7, %ecx
	
loop_bits:
	cmp $-1, %ecx
	je creste_eax_pt_next_litera
	movb (%edi, %eax, 1), %bl
	shr %ecx, %bl 
	and $1, %bl 
	
pune_biti_in_vector:
	lea vector, %esi
	
	
	cmp $1, %bl
	je pune_1_in_vector
	movl $0, (%esi, %edx, 4)
	jmp continuam_treaba
	
pune_1_in_vector:
	movl $1, (%esi, %edx, 4)

continuam_treaba:	
	incl %edx
	decl %ecx
	jmp loop_bits
	

creste_eax_pt_next_litera:
	incl %eax
	jmp next_litera
	

for:
	movl len, %eax
	movl $8, %ecx
	mull %ecx
	movl %eax, lungime_mesaj_biti
	

compar_lungimi:
	movl ncols_b, %eax
	movl mlines_b, %ecx
	mull %ecx
	movl %eax, lungime_cheie

	movl lungime_cheie, %eax
	movl lungime_mesaj_biti, %ebx
	cmp %eax, %ebx
	je facem_xor_pe_egale

	cmp %eax, %ebx
	jg concatenam_cheia

concatenam_cheia:

	movl lungime_cheie, %ecx
	lea new_matrix, %edi

loop_concat:
	cmp lungime_mesaj_biti, %ecx
	jge cheia_destul_de_mare
	movl $0, %eax

	movl $0, %eax
loop_c:
	cmp lungime_cheie, %eax
	je loop_concat

	movl (%edi, %eax, 4), %ebx
	movl %ebx, (%edi, %ecx, 4)

	incl %eax
	incl %ecx
	jmp loop_c


cheia_destul_de_mare:
	movl %ecx, lungime_cheie
	jmp facem_xor_pe_egale


facem_xor_pe_egale:
	movl $0, %ecx
	lea vector, %esi
	lea new_matrix, %edi

loop_xor:
	cmp lungime_mesaj_biti, %ecx
	je continuez

	lea new_matrix, %edi
	movl (%esi, %ecx, 4), %eax
	movl (%edi, %ecx, 4), %ebx
	xor %ebx, %eax

	lea cript, %edi
	movl %eax, (%edi, %ecx, 4)

	incl %ecx
	jmp loop_xor
	

continuez:


printez_0x:
	push $printf0x
	call printf
	addl $4, %esp

	lea cript, %esi

	movl $0, contor

loop_hexa:
	movl contor, %eax
	cmp lungime_mesaj_biti, %eax
	jg am_terminat

	movl $0, %edx
	movl $4, %ecx
	divl %ecx

	cmp $0, %edx
	jne nu_m4

	cmp $0, %eax
	je nu_m4

	push %ebx
	push $printfhexa
	call printf
	addl $8, %esp

	pushl $0
	call fflush
	addl $4, %esp

	movl $0, %ebx
nu_m4:
	movl contor, %eax
	movl (%esi, %eax, 4), %ecx
	shl $1, %ebx
	cmp $0, %ecx
	je adaug_0


adaug_1:
	or $1, %ebx

adaug_0:

	incl contor
	jmp loop_hexa


am_terminat:

	push %ebx
	push $printfhexa
	call printf
	addl $8, %esp

	jmp et_exit


decriptare:
	pushl $m
	call strlen
	addl $8, %esp
	mov %eax, len
	
	lea m, %esi
	lea vector_decimal, %edi
	movl $2, %ecx
	movl $0, %ebx


loop_conversie:

	movl $0, %eax

	cmp len, %ecx
	je gata_conversia
	movb (%esi, %ecx, 1), %al 

	cmp $65, %al 
	jge litera

cifra:
	subb $48, %al
	jmp treci_peste

litera:
	subb $55, %al


treci_peste:

	movl %eax, (%edi, %ebx, 4)
	incl %ebx
	incl %ecx
	jmp loop_conversie

gata_conversia:
	movl len, %eax
	subl $2, %eax
	movl %eax, len

	movl $0, %eax
	movl $0, %edx
next_dec:

	cmp len, %eax
	je mai_departe
	movl $3, %ecx


loop_pe_biti:
	cmp $-1, %ecx
	je creste_eax
	
	movl (%edi, %eax, 4), %ebx
	shr %ecx, %bl 
	and $1, %bl

	
pune_biti_in_v:
	lea vector, %esi
	
	
	cmp $1, %bl
	je pune_1_in_v
	movl $0, (%esi, %edx, 4)
	jmp continuam_trb
	
pune_1_in_v:
	movl $1, (%esi, %edx, 4)

continuam_trb:	
	incl %edx
	decl %ecx
	jmp loop_pe_biti
	

creste_eax:
	incl %eax
	jmp next_dec


mai_departe:
	movl %edx, lungime_mesaj_biti

	lea vector, %esi

compar_lungimi_chei:
	movl ncols_b, %eax
	movl mlines_b, %ecx
	mull %ecx
	movl %eax, lungime_cheie

	movl lungime_cheie, %eax
	movl lungime_mesaj_biti, %ebx
	cmp %eax, %ebx
	je facem_xor

	cmp %eax, %ebx
	jg concatenam_cheia2

concatenam_cheia2:

	movl lungime_cheie, %ecx
	lea new_matrix, %edi

loop_de_concat:
	cmp lungime_mesaj_biti, %ecx
	jge cheia_e_destul_de_mare
	movl $0, %eax

	movl $0, %eax
loop_c2:
	cmp lungime_cheie, %eax
	je loop_de_concat

	movl (%edi, %eax, 4), %ebx
	movl %ebx, (%edi, %ecx, 4)

	incl %eax
	incl %ecx
	jmp loop_c2


cheia_e_destul_de_mare:
	movl %ecx, lungime_cheie
	jmp facem_xor


facem_xor:
	movl $0, %ecx
	lea vector, %esi
	lea new_matrix, %edi

loop_pt_xor:
	cmp lungime_mesaj_biti, %ecx
	je in_continuare

	lea new_matrix, %edi
	movl (%esi, %ecx, 4), %eax
	movl (%edi, %ecx, 4), %ebx
	xor %ebx, %eax

	lea cript, %edi
	movl %eax, (%edi, %ecx, 4)

	incl %ecx
	jmp loop_pt_xor
	

in_continuare:

	lea cript, %esi
	movl $0, contor

loop_string:
	movl contor, %eax
	cmp lungime_mesaj_biti, %eax
	jg am_terminat_tot

	movl $0, %edx
	movl $8, %ecx
	divl %ecx

	cmp $0, %edx
	jne nu_m8

	cmp $0, %eax
	je nu_m8

	push %ebx
	push $printfstring
	call printf
	addl $8, %esp

	pushl $0
	call fflush
	addl $4, %esp

	movl $0, %ebx
nu_m8:
	movl contor, %eax
	movl (%esi, %eax, 4), %ecx
	shl $1, %ebx
	cmp $0, %ecx
	je adaug_0_iar


adaug_1_iar:
	or $1, %ebx

adaug_0_iar:

	incl contor
	jmp loop_string


am_terminat_tot:

	push %ebx
	push $printfhexa
	call printf
	addl $8, %esp


et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

