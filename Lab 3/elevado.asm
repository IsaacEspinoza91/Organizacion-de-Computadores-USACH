.data
	msj1: .asciiz "^"
	msj2: .asciiz " = "
	msj3: .asciiz "."
	msj4: .asciiz " cos "
	salto: .asciiz "\n"
.text

	addi $t0, $zero, 0	# var   $t0 = primer numero
	addi $t1, $zero, 0
	
	# Determinar argumentos y llamada a la funcion (subrutina) de multiplicacion
	add $a0, $zero, $t0		# arg1 = x
	add $a1, $zero, $t1
	jal multiplicacion
	add $s0, $zero, $v0	# Guardamos la parte entera en $s0
	#add $s1, $zero, $v1	# Guardamos la parte decimal en $s1
	

	
	# ---- PROCESO DE IMPRIMIR EN PANTALLA EL RESULTADO ----
	li $v0, 1		# Imprimir valor N1
	add $a0, $zero, $t0
	syscall
	
	li $v0, 4		# Imprimir en pantalla "  elevado "
	la $a0, msj1
	syscall
	
	li $v0, 1		# Imprimir valor N2
	add $a0, $zero, $t1
	syscall
	
	li $v0, 4		# Imprimir en pantalla " = "
	la $a0, msj2
	syscall
	
	li $v0, 1		# Imprimir valor parte entera
	add $a0, $zero, $s0
	syscall

		
	
	
	
	
	
	
	j exit			# Salto al termino del programa
	
		
			
					
elevado:		#necesita en $a0 la base, y en $a1 el exponente >= 0
	addi $sp, $sp, -32
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $a0, 20($sp)
	sw $a1, 24($sp)
	sw $ra, 28($sp)
	
	# Inicializacion valores
	add $t0, $zero, $zero	# i = $t0 = 0
	add $t1, $zero, $a1	# exponente = $t1
	add $t2, $zero, $a0	# base = $t2
	addi $t3, $zero, 1	# res = $t1 = 1
	
	bucle_elevado:
		slt $t4, $t0, $t1	# en $t3 = signo de i - exponente
		beqz $t4, salida_bucle_elevado
		#proceso de multiplicacion
		add $a0, $zero, $t3	# arg1 es $t3 = res
		add $a1, $zero, $t2	# arg2 es $t2 = base
		jal multiplicacion		#ejecutamos funcion
		add $t3, $zero, $v0	# guardamos en resultado la mult parcial
		addi $t0, $t0, 1	# actualizar iterador, i++
		j bucle_elevado

	salida_bucle_elevado:
		add $v0, $zero, $t3	#retorno de resulado en $v0
		lw $t0, 0($sp)		# Guardo valores del stack en donde estaban
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $a0, 20($sp)
		lw $a1, 24($sp)
		lw $ra, 28($sp)
		addi $sp, $sp, 32
		jr $ra
	
	
	
	
multiplicacion:		# Necesita argumentos en $a0 y $a1, entrega resultado en $v0
	addi $sp, $sp, -32	# Determino espacio a usar en el stack
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)		# Guardo el $ra actual para subrutinas anidadas
	sw $a0, 24($sp)
	sw $a1, 28($sp)

	add $t0, $zero, $a0	# Guardamos en t0 el valor N1
	add $t1, $zero, $a1	# Guardamos en t1 el valor N2
	add $t2, $zero, $zero	# Guardamos en t2 un 0 para luego obtener el resultado
	
	
	# ---- Proceso de conversion de los numeros en positivos si es que son negativos ---- 
	# vamos a usar t4 y t5 para las copias positivas de los numeros
	slti $t3, $t0, 0		# Analizo signo de N1
	beqz $t3, caso_n1_positivo	# Si $t3 es 0, entonces el N1 es positivo o cero, voy a caso_n1_positivo
		# CASO N1 negativo  --> cambio signo de N1
		sub $t4, $zero, $t0		# notar 0 - (N1) = -N1, $t4 = 0 - $t0 = -N1
		j analisis_signo_n2		# voy a analisis_signo_n2 y no entro a caso_n1_positivo
	caso_n1_positivo:   		# Caso N1 postivo, no cambio el signo
		add $t4, $zero, $t0		# $t4 = $t0 = N1
	
	analisis_signo_n2:
	slti $t3, $t1, 0		# Analizo signo de N2
	beqz $t3, caso_n2_positivo
		# CASO N2 negativo --> cambio de signo de N2
		sub $t5, $zero, $t1	# Guardo en $t5 el valor de 0 - N2
		j while_mult		# Ambos numeros son positivos voy a la iteracion de mult
	caso_n2_positivo:
		add $t5, $zero, $t1	# Ambos numeros son positivos, continuo en la iteracion
	
	
	
	# --- Proceso iterativo para calcular la multiplicacion mediante sumas ----
	# Itero hasta que el N2 sea 0 y en cada iteracion sumo el valor de N1
	while_mult:
		beqz $t5, exit_while_mult	# Caso Base, Si N2 es cero, salgo del while
		add $t2, $t2, $t4		# Var $t2 = res, luego, res = res + N1
		addi $t5, $t5, -1		# N2 = N2 - 1
		j while_mult			# vuelvo a iterar
		
	exit_while_mult:	# SALIDA del ciclo while
		# En este punto el resultado de la operacion esta en $t2, pero no considera el signo
		
		# ---- Proceso de agregar signo al resultado multiplicado ----
		# Analizo los signos de los valores originales $t0 = N1, $t1 = N2
		slt $t3, $t0, $zero		# $t3 guarda signo de N1
		beqz $t3, n1_positivo		# Si $t3 es 0, N1 es positivo y voy a n1_positivo
			#CASO N1<0
			slt $t3, $t1, $zero		# Analizo signo de N2
			beqz $t3, n2_positivo_n1_negativo	# Si $t3 es 0, N2>0 y N1<0, salto a label
				# CASO N1<0 y N2<0 ---> resultado > 0
				j termino_funcion_mult	# No cambio de signo el resultado, es positivo
			n2_positivo_n1_negativo:
				# CASO N1<0 y N2>0 ---> resultado < 0
				sub $t2, $zero, $t2	# Cambio de signo el resultado, es negativo
				j termino_funcion_mult
		
		n1_positivo:	#CASO N1>0
			slt $t3, $t1, $zero
			beqz $t3, termino_funcion_mult	# Caso N1>0 y N2>0 ---> resultado > 0, no cambia y salto
				sub $t2, $zero, $t2	# Caso N1>0 y N2<0 ---> resultado < 0, cambia
		
	termino_funcion_mult:	# Termino de la funcion multiplicacion, 
		add $v0, $zero, $t2	# Guardo el resultado como salida en $v0
		lw $t0, 0($sp)		# Guardo valores del stack en donde estaban
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $ra, 20($sp)
		lw $a0, 24($sp)
		lw $a1, 28($sp)
		addi $sp, $sp, 32	# Recupero el espacio en el stack
		jr $ra			# Termina la funcion y retorno a la instruccion guardada en $ra
		
		
		
exit:	# Termino del programa
	li $v0 10
	syscall
