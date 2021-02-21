.data
	buffer: .space 256 #buffer de espaço
	prompt_1: .asciiz "Digite o nome do produto: "
	prompt_2: .asciiz "Insira o valor unitário: "
	prompt_3: .asciiz "Insira a quantidade desejada desse produto: "
	prompt_4: .asciiz "Deseja comprar algo a mais?Se sim, digite 1. Caso contrário, digite 0. Resposta: "
	
	result_1: .asciiz "Pedido: "
	result_2: .asciiz "Valor unitário: R$"
	result_3: .asciiz "\nValor total do produto: R$"
	result_4: .asciiz "Valor total do pedido: R$"
	vezes: .asciiz "x "
	
	max_tam: .word 5
	
	nl: .asciiz "\n"

	value_float: .float  0.0
.text
	.globl inicio
	
	inicio:
		#i inicia em 0
		li $s1, 0
		
		#tamanho maximo array
		lw $s2, max_tam
		
		j loop_input
			
		#jal le_nome
		
		#move $t0, $a0   # Salva a string digitada em $t0
        	#syscall
		
		#jal le_preco_unitario
		#mov.s $f1, $f0
		
		#jal le_qte_unidades
		#la $t3, 0($v0)
		
		#jal cal_total_produto
		
		
		#jal imprime_valores
		#jal fim
	
#####################################################################################################################	
	#loop para a entrada
	loop_input:
		bge $s1, $s2, imprime_soma
		
		jal le_nome
		
		move $t0, $a0   # Salva a string digitada em $t0
        	syscall
		
		jal le_preco_unitario
		mov.s $f1, $f0
		
		jal le_qte_unidades
		la $t3, 0($v0)
		
		#resultado do preco do pedido...
		jal cal_total_produto
		
		#imprime os valores
		jal imprime_valores
		
		#calcula o valor final...
		add.s $f5, $f5, $f1
		
		#verifica se é para parar ou não...
		jal verifica_opcao
		la $t7, 0($v0)
		
		#Deseja comprar algo a mais?Se sim, digite 1. Caso contrário, digite 0. Resposta: 
		beq $t7, 0, imprime_soma 	
		addi $s1, $s1,1
	
		j loop_input
	
	
	imprime_soma:
		la $a0, result_4
		li $v0, 4
		syscall
		
		
		li $v0, 2
		mov.s $f12, $f5
		syscall
		
		j fim
		
	
	verifica_opcao:
		la $a0, prompt_4
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		jr $ra
	
	
#############################################################################################



	#Lê o nome
	le_nome:
		la $a0, prompt_1
		li $v0, 4
		syscall
		
		li $v0, 8
		
		la $a0, buffer
		li $a1, 256
		
		jr $ra
	
	#arrumar para ler float
	le_preco_unitario:
		la $a0, prompt_2
		li $v0, 4
		syscall
		
		li $v0, 6
		syscall
		
		s.s $f0, value_float
		
		jr $ra
		
	le_qte_unidades:
		la $a0, prompt_3
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		#li $v0, 5
		
		
		jr $ra
		
	cal_total_produto:
		#converte inteiro para float
		mtc1 $t3, $f3
		cvt.s.w $f3, $f3

		mul.s $f1, $f1, $f3
		
		jr $ra

	imprime_valores:
	
		la $a0, result_1
		li $v0, 4
		syscall
		
		la $a0, nl
		li $v0, 4
		syscall
	
		#primeira frase
		move $a0, $t3
		li $v0, 1
		syscall
		
		la $a0, vezes
		li $v0, 4
		syscall
		
		la $a0, 0($t0)
		li $v0,4
		syscall
		
		#segunda frase
		la $a0, result_2
		li $v0, 4
		syscall
		
		li $v0, 2
		l.s $f12, value_float
		syscall
		

		#terceira frase
		la $a0, result_3
		li $v0, 4
		syscall
		
		
		li $v0, 2
		mov.s $f12, $f1
		syscall
		
		#pula linha
		la $a0, nl
		li $v0, 4
		syscall	
			
		jr $ra
	
	fim:
		li $v0, 10
		syscall	
