.data
     $prompt_horas:.asciiz "\nEntre com as horas: "
     $prompt_erro_horas:.asciiz "\nValor inválido para as horas. Esperado número entre 0 e 23."
     
     $prompt_minutos:.asciiz "\nEntre com os minutos: "
     $prompt_erro_minutos:.asciiz "\nValor inválido para os minutos. Esperado número entre 0 e 59."
     
     $prompt_segundos:.asciiz "\nEntre com os segundos: "
     $prompt_erro_segundos:.asciiz "\nValor inválido para os segundos. Esperado número entre 0 e 59."
     
     $final:.asciiz "\nHorário digitado: "
     $ponto:.asciiz ":"
     n1: .float 0.082

.text
	.globl inicio
	
	inicio: 
		#lendo a quantiadde de horas
		jal le_quant_horas
		la $t7, 0($v0)
		
		#lendo a quantidade de minutos
		jal le_quant_minutos
		la $t8, 0($v0)
		#lendo a quantidade de segundos
		jal le_quant_segundos
		la $t9, 0($v0)
						
		jal finaliza_programa			
		
########################################################################
# 	HORAS	
				
	erro_horas:
		la $a0, $prompt_erro_horas
		li $v0, 4
		syscall
		
		j le_quant_horas
		#jr $ra		

		
	le_quant_horas:
	        #le o valor maximo digitado pelo usuario...
	        la $a0, $prompt_horas #imprime mensagem para auxiliar usuario
		li $v0, 4	#código para imprimir string
		syscall 
		li $v0, 5	# código para ler um inteiro
		syscall		# executa a chamada do SO para ler
	
		#verifica se é menor que 0
		slti $t1, $v0, 0
		bne $t1, 0, erro_horas
		bne $t1, 0, le_quant_horas	
		
		#verifica se é maior que 23
		slti $t1, $v0, 24
		bne $t1, 1, erro_horas
		bne $t1, 1, le_quant_horas
		
	        jr $ra	# volta para o lugar de onde foi chamado


##################################################################################
#	MINUTOS
		
	erro_minutos:
		la $a0, $prompt_erro_minutos
		li $v0, 4
		syscall
		
		j le_quant_minutos
				
				
	le_quant_minutos:
	        #le o valor maximo digitado pelo usuario...
	        la $a0, $prompt_minutos #imprime mensagem para auxiliar usuario
		li $v0, 4	#código para imprimir string
		syscall 
		li $v0, 5	# código para ler um inteiro
		syscall		# executa a chamada do SO para ler
		
		#verifica se é menor que 0
		slti $t1, $v0, 0
		bne $t1, 0, erro_minutos
		bne $t1, 0, le_quant_minutos	
		
		#verifica se é maior que 59
		slti $t1, $v0, 60
		bne $t1, 1, erro_minutos
		bne $t1, 1, le_quant_minutos
				
	        jr $ra		# volta para o lugar de onde foi chamado


##################################################################################
#	SEGUNDOS
				
	erro_segundos:
		la $a0, $prompt_erro_segundos
		li $v0, 4
		syscall
		
		j le_quant_segundos
				
				
	le_quant_segundos:
	        #le o valor maximo digitado pelo usuario...
	        la $a0, $prompt_segundos #imprime mensagem para auxiliar usuario
		li $v0, 4	#código para imprimir string
		syscall 
		li $v0, 5	# código para ler um inteiro
		syscall		# executa a chamada do SO para ler
		
		#verifica se é menor que 0
		slti $t1, $v0, 0
		bne $t1, 0, erro_segundos
		bne $t1, 0, le_quant_segundos	
		
		#verifica se é maior que 59
		slti $t1, $v0, 60
		bne $t1, 1, erro_segundos
		bne $t1, 1, le_quant_segundos
		
	        jr $ra		# volta para o lugar de onde foi chamado


#################################################################################

	monta_mensagem:
		la $a0, $final
	       	li $v0, 4 #codigo para imprimir string...
	       	syscall
			
		#formato: HH:MM:SS
		li $v0, 1
 		move $a0, $t7
 		syscall
		
	       	la $a0, $ponto
	       	li $v0, 4 #codigo para imprimir string...
	       	syscall		
	       
	       	li $v0, 1
 		move $a0, $t8
 		syscall
		
	       	la $a0, $ponto
	       	li $v0, 4 #codigo para imprimir string...
	       	syscall		
		
		li $v0, 1
 		move $a0, $t9
 		syscall
	

		jr $ra


	finaliza_programa:
	
		jal monta_mensagem

	       li $v0, 10# codigo para finalizar programa...
	       syscall
	
	
	