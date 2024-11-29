.data
	msj_coma: .asciiz "."
	msj_signo: .asciiz "-"
.text
	# Notar:    $s0 = resultado division
	addi $t0, $zero, -25	# var   $t0 = primer numero, numerador
	addi $t1, $zero, -2	# var   $t1 = segundo numer, denominador
		
		

	add $a0, $zero, $t0
	add $a1, $zero, $t1
	jal division
	add $s0, $zero, $v0 	# Guardo en $s0 la parte entera 
	add $s1, $zero, $v1	# Guardo en #s1 la parte decimal

	

	imprimir_numero_resultado:
	li $v0, 1		# Imprimir valor de la parte entera
	add $a0, $zero, $s0
	syscall
	
	li $v0, 4		# Imprimir "."
	la $a0, msj_coma
	syscall
	
	li $v0, 1		# Imprimir parte decimal
	add $a0, $zero, $s1
	syscall
	
	j exit			# Salto al termino del programa



# --- Subrituna para obtener la division, $a1 (numerador) y $a2 (divisor) como argumentos, y retorno en $v0 ----
division:
	addi $sp, $sp, -40	# Almacenamos valores en el stack
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)
	sw $s0, 24($sp)
	sw $s1, 28($sp)
	sw $s2, 32($sp)
	sw $t5, 36($sp)
	add $t0, $zero, $a0	# $t0 = Numerador, lo llamamos var I
	add $t1, $zero, $a1	# $t1 = Denominador, lo llamamos var N
	add $t2, $zero, $zero	# Guardamos un cero para luego obtener el resultado parte Entera
	
	add $s0, $zero, $zero		# var E de parte entera
	add $s1, $zero, $zero		# var D1 decimal 1
	add $s2, $zero, $zero		# var D2 decimal 2
	
	
	
	
	
	# ---- Proceso de conversion de los numeros en positivos si es que son negativos ---- 
	# vamos a usar t4 y t5 para las copias positivas de los numeros
	slti $t3, $t0, 0		# Analizo signo de N1
	beqz $t3, caso_n1_positivo_div	# Si $t3 es 0, entonces el N1 es positivo o cero, voy a caso_n1_positivo
		# CASO N1 negativo  --> cambio signo de N1
		sub $t4, $zero, $t0		# notar 0 - (N1) = -N1, $t4 = 0 - $t0 = -N1
		j analisis_signo_n2_div		# voy a analisis_signo_n2 y no entro a caso_n1_positivo
	caso_n1_positivo_div:   		# Caso N1 postivo, no cambio el signo
		add $t4, $zero, $t0		# $t4 = $t0 = N1
	
	analisis_signo_n2_div:
	slti $t3, $t1, 0		# Analizo signo de N2
	beqz $t3, caso_n2_positivo_div
		# CASO N2 negativo --> cambio de signo de N2
		sub $t5, $zero, $t1	# Guardo en $t5 el valor de 0 - N2
		j operacion_div		# Ambos numeros son positivos voy a la iteracion de mult
	caso_n2_positivo_div:
		add $t5, $zero, $t1	# Ambos numeros son positivos, continuo en la iteracion
	
	
	
	
	
	
	
	operacion_div:
	# ---- Proceso calculo de la parte entera ----
	add $a0, $zero, $t4		# inicializo los argumentos, en este caso es irrelevante
	add $a1, $zero, $t5
	jal while_divi
	# Obtengo calculo de parte entera
	add $s0, $zero, $v0		# Se guarda la parte entera   en $s0
	add $t4, $zero, $v1		# Actualizamos el valor del resto I
	beqz $t4, exit_division		# En caso de division exacta, salgo de la iteracion
	# Determinamos argumentos para la subrutina multiplicar por 10
	add $a0, $zero, $t4
	addi $a1, $zero, 10
	jal multiplicacion
	add $t4, $zero, $v0		# Valor multiplicacion I*10
	
	
	# --- Proceso calculo del primer decimal ---
	add $a0, $zero, $t4		# I actualizado = resto anterior * 10
	add $a1, $zero, $t5		# valor de N
	jal while_divi
	# Obtengo calculo del decimal 1
	add $s1, $zero, $v0		# En var D1 = $s1se guarda el primer decimal
	add $t4, $zero, $v1		# Actualizamos el valor del resto I
	beqz $t4, exit_divisionPRE		# En caso de solo 1 decimal, salgo de la iteracion
	# Determinamos argumentos para la subrutina multiplicar por 10
	add $a0, $zero, $t4
	addi $a1, $zero, 10
	jal multiplicacion
	add $t4, $zero, $v0		# Valor multiplicacion I*10
	
	
	# --- Proceso calculo del segundo decimal ---
	add $a0, $zero, $t4		# I actualizado = resto anterior * 10
	add $a1, $zero, $t5		# valor de N
	jal while_divi
	# Obtengo decimal 2
	add $s2, $zero, $v0		# En var D2 = $s2, se guarda el segundo decimal


	# --- Calculo de la parte decimal como un unico valor ---
	# Determinamos argumentos para la subrutina multiplicar por 10
	add $a0, $zero, $s1
	addi $a1, $zero, 10
	jal multiplicacion	# en $t3 guardo el primer decimal mult por 10, mas
	add $s1, $v0, $s2	#  el ultimo decimal. Asi determino la parte decimal total
	j exit_division
	

	exit_divisionPRE:	#caso en que solo tenga un decimal, se retorna ejemplo, 2,40 en vez de 2,4
		add $a0, $zero, $s1
		addi $a1, $zero, 10
		jal multiplicacion
		add $s1, $zero, $v0


	exit_division:	
		# En este punto el resultado de la operacion esta en $s0 parte entera y $s1 parte decimal, pero no considera signo
		
		# ---- Proceso de agregar signo al resultado multiplicado ----
		# Analizo los signos de los valores originales $t0 = N1, $t1 = N2
		slt $t3, $t0, $zero		# $t3 guarda signo de N1
		beqz $t3, n1_positivo_div		# Si $t3 es 0, N1 es positivo y voy a n1_positivo
			#CASO N1<0
			slt $t3, $t1, $zero		# Analizo signo de N2
			beqz $t3, n2_positivo_n1_negativo_div	# Si $t3 es 0, N2>0 y N1<0, salto a label
				# CASO N1<0 y N2<0 ---> resultado > 0
				j termino_funcion_div	# No cambio de signo el resultado, es positivo
			n2_positivo_n1_negativo_div:
				# CASO N1<0 y N2>0 ---> resultado < 0
				sub $s0, $zero, $s0	# Cambio de signo el resultado, es negativo
				j termino_funcion_div
		
		n1_positivo_div:	#CASO N1>0
			slt $t3, $t1, $zero
			beqz $t3, termino_funcion_div	# Caso N1>0 y N2>0 ---> resultado > 0, no cambia y salto
				sub $s0, $zero, $s0	# Caso N1>0 y N2<0 ---> resultado < 0, cambia
	
	
	termino_funcion_div:
		add $v0, $zero, $s0		# Retorno $v0 guarda la parte entera
		add $v1, $zero, $s1		# Retorno $v1 guarda la parte decimal
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $ra, 20($sp)
		lw $s0, 24($sp)
		lw $s1, 28($sp)
		lw $s2, 32($sp)
		lw $t5, 36($sp)
		addi $sp, $sp, 40
		jr $ra



# --- Subrutina que realiza la iteracion para contar la division ----
# Entrega el numero por el que hay que multiplicarlo con el division
# para obtener el numero mas cercano inferiormente al dividendo
while_divi:
	addi $sp, $sp, -28	# Almacenamos valores en el stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	add $t0, $zero, $a0	# $t0 = Numerador, lo llamamos I
	add $t1, $zero, $a1	# $t1 = Denominador, lo llamamos var N
	
	slt $t4, $t0, $t1
	addi $t2, $zero, 0	# Var J = $t2 = 0,  Aca se calcula la cantidad de iteraciones
	bnez $t4, salida_ciclo_resta	# Caso dividendo<division, voy a salida y retorno 0
	
	ciclo_resta_menor_n:
		sub $t3, $t0, $t1	# $t3 = I - N
		sub $t3, $t3, $t1	# $t3 = I - N - N, condicion de salida del prox bucle
		slti $t3, $t3, 0	# Guardo el signo de 	I - 2*N,
		addi $t2, $t2, 1	# Contamos la iteracion, J = J + 1
		sub $t0, $t0, $t1	# I = I - N
		bne $t3, $zero, salida_ciclo_resta	# Si el signo es cero, salgo de la iteracion
			j ciclo_resta_menor_n		#  sino, vuelvo a iterar
	
	salida_ciclo_resta:
		add $v0,$zero, $t2	# Guardo el resultado como retorno, $v0 = $t2 = resultado
		add $v1, $zero, $t0	# Guardo el I como retorno, $v1 = $t0 = I
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		addi $sp, $sp, 28
		jr $ra

		
# ---- SUBRUTINA DE MULTIPLICACION (2a) ----
multiplicacion:		# Necesita argumentos en $a0 y $a1, entrega resultado en $v0
	addi $sp, $sp, -36	# Determino espacio a usar en el stack
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)		# Guardo el $ra actual para subrutinas anidadas
	sw $a0, 24($sp)
	sw $a1, 28($sp)
	sw $t5, 32($sp)

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
		lw $t5, 32($sp)
		addi $sp, $sp, 36	# Recupero el espacio en el stack
		jr $ra			# Termina la funcion y retorno a la instruccion guardada en $ra



exit:	# Termino del programa
	li $v0, 10
	syscall