.data
	msj1: .asciiz " e^"
	msj2: .asciiz " = "
	msj3: .asciiz "."
	msj4: .asciiz " cos("
	msj5: .asciiz " ln (1+"
	backParentesis: .asciiz ")"
	salto: .asciiz "\n"
	texto1: .asciiz "Por favor, ingrese un numero entero no negativo para obtener las aproximaciones de las funciones: "
.text
	li $v0, 4		# Mensaje solictar numero
	la $a0, texto1
	syscall
	
	li $v0, 5		# Leo el primer numero
	syscall
	add $t0, $zero, $v0	# $t0 = N1
	

	# funcion Exponencial
	add $a0, $zero, $t0		# arg1 = x
	jal funcion_exponencial
	add $s0, $zero, $v0	# Guardamos la parte entera en $s0
	add $s1, $zero, $v1	# Guardamos la parte decimal en $s1
	# IMPRIMIR funcion EXPONENCIAL
	li $v0, 4		# Imprimir salto de linea
	la $a0, salto
	syscall
	
	li $v0, 4		# Imprimir en " e elevado"
	la $a0, msj1
	syscall
	
	li $v0, 1		# Imprimir valor N1
	add $a0, $zero, $t0
	syscall
		
	li $v0, 4		# Imprimir en pantalla " = "
	la $a0, msj2
	syscall
	
	li $v0, 1		# Imprimir valor parte entera del cos
	add $a0, $zero, $s0
	syscall
	
	li $v0, 4		# Imprimir en pantalla el punto
	la $a0, msj3
	syscall
	
	li $v0, 1		# Imprimir valor parte decimal del cos
	add $a0, $zero, $s1
	syscall
	
	
	# funcion COSENO
	add $a0, $zero, $t0		# arg1 = x
	jal funcion_coseno
	add $s2, $zero, $v0	# Guardamos la parte entera en $s2
	add $s3, $zero, $v1	# Guardamos la parte decimal en $s3
	# IMPRIMIR funcion COSENO
	li $v0, 4		# Imprimir salto de linea
	la $a0, salto
	syscall
	
	li $v0, 4		# Imprimir en " cos("
	la $a0, msj4
	syscall
	
	li $v0, 1		# Imprimir valor N1
	add $a0, $zero, $t0
	syscall
	
	li $v0, 4		# Imprimir en pantalla ")"
	la $a0, backParentesis
	syscall
		
	li $v0, 4		# Imprimir en pantalla " = "
	la $a0, msj2
	syscall
	
	li $v0, 1		# Imprimir valor parte entera del cos
	add $a0, $zero, $s2
	syscall
	
	li $v0, 4		# Imprimir en pantalla el punto
	la $a0, msj3
	syscall
	
	li $v0, 1		# Imprimir valor parte decimal del cos
	add $a0, $zero, $s3
	syscall
	
	
	
	# funcion LOG NATURAL
	add $a0, $zero, $t0		# arg1 = x
	jal funcion_ln
	add $s4, $zero, $v0	# Guardamos la parte entera en $s4
	add $s5, $zero, $v1	# Guardamos la parte decimal en $s5
	# IMPRIMIR funcion LOG NATURAL
	li $v0, 4		# Imprimir salto de linea
	la $a0, salto
	syscall
	
	li $v0, 4		# Imprimir en " ln(1+"
	la $a0, msj5
	syscall
	
	li $v0, 1		# Imprimir valor N1
	add $a0, $zero, $t0
	syscall
	
	li $v0, 4		# Imprimir en pantalla ")"
	la $a0, backParentesis
	syscall
		
	li $v0, 4		# Imprimir en pantalla " = "
	la $a0, msj2
	syscall
	
	li $v0, 1		# Imprimir valor parte entera del ln
	add $a0, $zero, $s4
	syscall
	
	li $v0, 4		# Imprimir en pantalla el punto
	la $a0, msj3
	syscall
	
	li $v0, 1		# Imprimir valor parte decimal del ln
	add $a0, $zero, $s5
	syscall
		
		
		
	j exit			# Salto al termino del programa
	
	

	
	
# --- Funcion exponencial ---
# Entrada:    $a0 = num
# Salida:     $v0 = e^num
funcion_exponencial:
	addi $sp, $sp, -40
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $s0, 24($sp)
	sw $a0, 28($sp)
	sw $a1, 32($sp)
	sw $ra, 36($sp)
	
	add $s0, $zero, $a0	# valor X
	add $t0, $zero, $zero	#   var ResA, para guardar el resultado de la parte entera
	add $t1, $zero, $zero	#   var Res B, para guardar el resultado de la parte decimal
	add $t2, $zero, $zero	# var i para iterar
	
	while_principal_exponencial:
		slti $t3, $t2, 7	# $t3 --> signo de i - 7 ------> son 7 ITERACIONES
		beqz $t3, salida_while_principal_exponencial
		
		# Llamada a funcion elevado, para calcular X^n, donde n=i
		add $a0, $zero, $s0		# arg1 = X
		add $a1, $zero, $t2		# arg2 = i 
		jal elevado
		add $t4, $zero, $v0	# $t4 = X^i
		
		# Llamada a funcion factorial, para calcular n! = i!
		add $a0, $zero, $t2		#arg1 = i
		jal factorial
		add $t5, $zero, $v0	# $t5 = i!
		
		# Llamada a funcion division, para calcular (X^i)/(i!)
		add $a0, $zero, $t4		# numerador = X^i
		add $a1, $zero, $t5		# divisor = i!
		jal division
		add $t4, $zero, $v0	# var resParcialA = parte entera
		add $t5, $zero, $v1 	# var resParcialB = parte decimal			# ojo que esta parte puede ser add $t0, $t0,$v0
		
		# Sumar valores para cada iteracion
		add $t0, $t0, $t4	# resA = resA + resParcialA
		add $t1, $t1, $t5	# resB = resB + resParcialB
		addi $t2, $t2, 1	# actualizar iterador, i++

		j while_principal_exponencial
	
	
	salida_while_principal_exponencial:
		# Una vez calculado la suma de la parte entera y la decimal para la serie,
		#   se debe separa la parte decimal para obtener los dos primeros valores
		add $a0, $zero, $t1		#arg para obtener 2 valores = parte decimal
		jal dos_primeros_valores
		add $t2, $zero, $v0	# $t2 = parte decimal real (dos decimales)
		
		add $a0, $t1, $zero	# dividir por 100 para obtener la parte entera
		addi $a1, $zero, 100	#   es decir, el numero sin los dos primeros valores
		jal division
		add $t1, $zero, $v0

		add $t0, $t0, $t1	# $t0 = parte entera real
		
		add $v0, $zero, $t0	# Retorno parte entera oficial
		add $v1, $zero, $t2	# Retorno parte decimal oficial
		lw $t0, 0($sp)		# Guardo valores en el stack	
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)
		lw $s0, 24($sp)
		lw $a0, 28($sp)
		lw $a1, 32($sp)
		lw $ra, 36($sp)
		addi $sp, $sp, 40
		jr $ra
		
		
		

	
	
# --- Funcion coseno ---
# Entrada:   $a0 = num
# Salida:    $v0 = cos (num)
funcion_coseno:
	addi $sp, $sp, -40
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $s0, 24($sp)
	sw $a0, 28($sp)
	sw $a1, 32($sp)
	sw $ra, 36($sp)
	
	add $s0, $zero, $a0	# valor X
	add $t0, $zero, $zero	#   var ResA, para guardar el resultado de la parte entera
	add $t1, $zero, $zero	#   var ResB, para guardar el resultado de la parte decimal
	add $t2, $zero, $zero	# var n para iterar
	
	while_principal_coseno:
		slti $t3, $t2, 4	# $t3 --> signo de n - 4   -----> son 4 TERMINOS
		beqz $t3, salida_while_principal_coseno
		
		# Llamada a funcion elevado, para calcular (-1)^n
		addi $a0, $zero, -1		# arg1 = (-1)
		add $a1, $zero, $t2		# arg2 = n
		jal elevado
		add $t3, $zero, $v0	# $t3 = (-1)^n
		
		# Llamada a funcion multipliciacion, para calcular 2n
		addi $a0, $zero, 2		# arg1 = 2
		add $a1, $zero, $t2		# arg2 = n
		jal multiplicacion
		add $t4, $zero, $v0	# $t4 = 2n
		
		# Llamada a funcion elevado, calculo de x^(2n)
		add $a0, $zero, $s0		# arg1 = x
		add $a1, $zero, $t4		# arg2 = 2n
		jal elevado
		add $t5, $zero, $v0	# $t5 = x^2n
		
		# Llamada a funcion multi, calculo de   ((-1)^n) *  (x^2n)
		add $a0, $zero, $t3		# arg1 = (-1)^n
		add $a1, $zero, $t5		# arg2 = x^2n
		jal multiplicacion
		add $t3, $zero, $v0	# $t3 = ((-1)^n) *  (x^2n)
		
		# Llamada a factorial, calculo de  2n!
		add $a0, $zero, $t4		# arg1 = 2n
		jal factorial
		add $t5, $zero, $v0	# $t5 = 2n!
		
		
		# Llamada a funcion division, para calcular (((-1)^n) *  (x^2n))/(2n!)
		add $a0, $zero, $t3		# numerador = ((-1)^n) *  (x^2n)
		add $a1, $zero, $t5		# divisor = 2n!
		jal division
		add $t4, $zero, $v0	# var resParcialA = parte entera
		add $t5, $zero, $v1 	# var resParcialB = parte decimal
		
		
		# Sumar valores para cada iteracion
		add $t0, $t0, $t4	# resA = resA + resParcialA
		# Notar que si el valor es negativo, la parte decimal se resta, no se suma, pero este valor
		#   es siempre positivo. Entonces hay que cambiarlo si es el caso
		slt $t4, $t4, $zero
		beq $t4, 1, cambio_signo_parte_decimal
			# caso en que no se cambia el signo
			add $t1, $t1, $t5	# resB = resB + resParcialB
			j actualizar_n
		cambio_signo_parte_decimal:
			sub $t1, $t1, $t5
		actualizar_n:
		addi $t2, $t2, 1	# actualizar iterador, n++

		j while_principal_coseno
	
	
	salida_while_principal_coseno:
		# Una vez calculado la suma de la parte entera y la decimal para la serie,
		#   se debe separar  la parte decimal para obtener los dos primeros valores
		
		# ademas se debe convertir a positivo la parte decimal, en el caso que sea negativa
		slt $t3, $t1, $zero
		beqz $t3, finalizando_while_cos
			sub $t1, $zero, $t1
		
		finalizando_while_cos:
		add $a0, $zero, $t1		#arg para obtener 2 valores = parte decimal
		jal dos_primeros_valores
		add $t2, $zero, $v0	# $t2 = parte decimal real (dos decimales)
		
		beqz $t3, sin_cambio_signo
			sub $t1, $zero, $t1
		sin_cambio_signo:
		add $a0, $t1, $zero	# dividir por 100 para obtener la parte entera
		addi $a1, $zero, 100	#   es decir, el numero sin los dos primeros valores
		jal division
		add $t1, $zero, $v0

		add $t0, $t0, $t1	# $t0 = parte entera real
		
		add $v0, $zero, $t0	# Retorno parte entera oficial
		add $v1, $zero, $t2	# Retorno parte decimal oficial
		lw $t0, 0($sp)		# Guardo valores en el stack	
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)
		lw $s0, 24($sp)
		lw $a0, 28($sp)
		lw $a1, 32($sp)
		lw $ra, 36($sp)
		addi $sp, $sp, 40
		jr $ra
		

	

# --- Funcion Ln ---
# Entrada: $a0 = num
# Salida:  $v0 = ln (1+num)
funcion_ln:
	addi $sp, $sp, -40
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $s0, 24($sp)
	sw $a0, 28($sp)
	sw $a1, 32($sp)
	sw $ra, 36($sp)
	
	add $s0, $zero, $a0	# valor X
	add $t0, $zero, $zero	#   var ResA, para guardar el resultado de la parte entera
	add $t1, $zero, $zero	#   var ResB, para guardar el resultado de la parte decimal
	addi $t2, $zero, 1	# var n para iterar
	
	while_principal_ln:
		slti $t3, $t2, 8	# $t3 --> signo de n - 8  ---> son 7 ITERACIONES
		beqz $t3, salida_while_principal_ln
		
		
		addi $t3, $t2, 1	# $t3 = n + 1 
		# Llamada a funcion elevado, para calcular (-1)^(n+1)
		addi $a0, $zero, -1		# arg1 = (-1)
		add $a1, $zero, $t3		# arg2 = n+1
		jal elevado
		add $t3, $zero, $v0	# $t3 = (-1)^(n+1)
		
		# Llamada a funcion elevado, calculo de x^n
		add $a0, $zero, $s0		# arg1 = x
		add $a1, $zero, $t2		# arg2 = n
		jal elevado
		add $t4, $zero, $v0	# $t4 = x^n
		
		# Llamada a funcion multi, calculo de   ((-1)^(n+1)) *  (x^n)
		add $a0, $zero, $t3		# arg1 = (-1)^(n+1)
		add $a1, $zero, $t4		# arg2 = x^n
		jal multiplicacion
		add $t4, $zero, $v0	# $t4 = ((-1)^(n+1)) *  (x^n)
		
		# Llamada a funcion division, para calcular (((-1)^(n+1)) *  (x^n)) / n
		add $a0, $zero, $t4		# numerador = ((-1)^(n+1)) *  (x^n)
		add $a1, $zero, $t2		# divisor = n
		jal division
		add $t4, $zero, $v0	# var resParcialA = parte entera
		add $t5, $zero, $v1 	# var resParcialB = parte decimal
		
		# Sumar valores para cada iteracion
		add $t0, $t0, $t4	# resA = resA + resParcialA
		# Notar que si el valor es negativo, la parte decimal se resta, no se suma, pero este valor
		#   es siempre positivo. Entonces hay que cambiarlo si es el caso
		slt $t4, $t4, $zero
		beq $t4, 1, cambio_signo_parte_decimal_ln
			# caso en que no se cambia el signo
			add $t1, $t1, $t5	# resB = resB + resParcialB
			j actualizar_n_ln
		cambio_signo_parte_decimal_ln:
			sub $t1, $t1, $t5
		actualizar_n_ln:
			addi $t2, $t2, 1	# actualizar iterador, n++

		j while_principal_ln
	
	
	salida_while_principal_ln:
		# Una vez calculado la suma de la parte entera y la decimal para la serie,
		#   se debe separar  la parte decimal para obtener los dos primeros valores
		
		# ademas se debe convertir a positivo la parte decimal, en el caso que sea negativa
		slt $t3, $t1, $zero
		beqz $t3, finalizando_while_ln
			sub $t1, $zero, $t1
		
		finalizando_while_ln:
		add $a0, $zero, $t1		#arg para obtener 2 valores = parte decimal
		jal dos_primeros_valores
		add $t2, $zero, $v0	# $t2 = parte decimal real (dos decimales)
		
		beqz $t3, sin_cambio_signo_ln
			sub $t1, $zero, $t1
		sin_cambio_signo_ln:
		add $a0, $t1, $zero	# dividir por 100 para obtener la parte entera
		addi $a1, $zero, 100	#   es decir, el numero sin los dos primeros valores
		jal division
		add $t1, $zero, $v0

		add $t0, $t0, $t1	# $t0 = parte entera real
		
		add $v0, $zero, $t0	# Retorno parte entera oficial
		add $v1, $zero, $t2	# Retorno parte decimal oficial
		lw $t0, 0($sp)		# Guardo valores en el stack	
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)
		lw $s0, 24($sp)
		lw $a0, 28($sp)
		lw $a1, 32($sp)
		lw $ra, 36($sp)
		addi $sp, $sp, 40
		jr $ra
		
	
	
	
	
	
# --- Funcion dos primeros valores ---
# Obtiene los dos primeros digitos de un numero, por ejemplo, se ingresa 543542, y retorna 42
# Entrada: $a0 = num
# Salida: $v0 = dos primeros valores de num
dos_primeros_valores:	#Funcion que obtiene los dos pimeros valores de un numero
	addi $sp, $sp, -20
	sw $t0, 0($sp)		# Guardo valores en el stack				ojo $s0000
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $ra, 12($sp)
	add $t0, $zero, $a0	# var num
	addi $t1, $zero, 100	# numero 100
	
	while_dos_primeros_valores:
		slt $t2, $t1, $t0	# $t2 = signo de (100 - num)
		beqz $t2, salida_while_dos_pri_valores	# si 100-num >= 0, salgo del bucle
		addi $t0, $t0, -100	# actualizacion iterador, num = num - 100
		j while_dos_primeros_valores
	
	salida_while_dos_pri_valores:
		# Retornamos el valor que quedo de la iteracion
		add $v0, $zero, $t0
		lw $t0, 0($sp)		# Guardo valores del stack en donde estaban
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 20
		jr $ra
	

	
# --- Funcion elevado ---
# Entrada:   $a0 = base,    $a1 = exponente
# Salida:    $v0 = base^exponente
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
	
	
	
# --- Funcion multiplicacion ---
# Entrada:    $a0 = valor1,      $a1 = valor2
# Salida:    $v0 = valor1 * valor2
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
		
		
		
# --- Funcion factorial ----
# Entrada:   $a0 = n , para obtener n!
# Salida:    $v0 = n!
factorial:
	addi $sp, $sp, -28	# Determino espacio a usar en el stack
	sw $t0, 0($sp)		# Guardo valores en el stack
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra, 16($sp)		# Guardo el $ra actual para subrutinas anidadas
	sw $a0, 20($sp)
	sw $a1, 24($sp)
	
	addi $t0, $zero, 1	# Inicializo $t0 con un 1, res = 1
	addi $t1, $a0, 1 	# Guardo en N+1 en $t1, nMax = N + 1
	addi $t2, $zero, 1	# Variable I se guarda 1, I = 1
	
	# ---- Condicion, si el N es negativo, no realiza la iteracion ----
	slt $t3, $a0, $zero	# Analizo signo de N
	bne $t3, $zero, exit_facto	# En caso de que N<0, voy a exit_facto
	
	while_factorial:	# Iteracion para calcular el factorial
		slt $t3, $t2, $t1	# Guardo el signo de i - nMax
		beqz $t3, exit_facto	# Si el signo es 0, salgo de la iteracion,
		
		# Llamar a la funcion multiplicacion
		add $a0, $zero, $t2	# Argumento 0 guarda el I
		add $a1, $zero, $t0	# Argumento 1 guarda el res
		jal multiplicacion	# Ejecuto funcion multiplicacion
		add $t0, $zero, $v0	# Guardamos el valor de la mult en $t0
		addi $t2, $t2, 1	# i = i + 1
		j while_factorial	# Volvemos a iterar el while_factorial
	
	exit_facto:
		add $v0, $zero, $t0	# Guardo el resultado en el registro de retorno
		lw $t0, 0($sp)		# Guardo valores del stack en donde estaban
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $ra, 16($sp)	
		lw $a0, 20($sp)
		lw $a1, 24($sp)
		addi $sp, $sp, 28	# Recupero el espacio en el stack
		jr $ra			# Termina la funcion
		
		
# --- Funcion division ---
# Entradas:  $a0 = numerador,          $a1 = divisor
# Salidas:   $v0 = parte entera resultado,      $v1 = parte decimal del resultado
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
# Entrega el numero por el que hay que multiplicarlo con el division para obtener el numero mas cercano inferiormente al dividendo
# Entrada:  $a0 = numerador,    $a1 = divisor
# Salida:  $v0 = numero de iteraciones (division entera),    $v1 = resto de la division
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


		
exit:	# Termino del programa
	li $v0 10
	syscall
