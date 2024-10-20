.data

.text

	#Suponiendo  a = $s0, b = $s1, y que la base del arreglo esta en el registro $s2
	#En este caso damos valores cualquiera a los registro y a la direccion base, para ver el funcionamiento del codigo
	
	addi $s0, $zero, 0	#Inicializamos el registro $s0 (a) como 0
	addi $s1, $zero, 10	#Inicializamos el registro $s1 (b) como 10
	addiu $s2, $zero, 0x10010000	#Inicializamos el registro $s2 con una direccion de memoria existente
	
while:
	slti $t1, $s0, 10	#Guarda en $t1 el signo de la resta entre "a" y la cte 10. (0=+  1=-)
				# Luego, si a<10 -> $t1=1  . Si a>=10 -> $t1=0
	beq $t1, $zero, salida	#En el caso en que el signo sea posito (0), significa que como es igual a cero ($zero), voy al label salida
				#   En caso contrario sigo con la siguiente instruccion
	sll $t1, $s0, 2		#En $t1, almacenamos el valor de "a" multiplicado por 4, para acceder al elemento siguiente de array
				#   Esto se hace, realizando un movimiento de dos bits hacia la izquierda y agregando ceros
	add $t1, $t1, $s2	#Se suma en $t1, la direccion base del array ($s2) mas "a" por 4 (que ya existia en $t1).
				#   Asi obtenemos la direccion de memoria del elemento actual de array
	add $t2, $s1, $s0	#En $t2 guado la suma entre "a" y "b", para usarla en la proxima instruccion
				#   $t2 = b+a
	sw $t2, 0($t1)		#Escribimos en la direccion obtenida de (0 + $t1), el valor de $t2, que es b+a
				#   D[a] = b+a
	addi $s0, $s0, 1	# Aumentamos en 1 el valor de a para evitar ciclo infinito
				#   a += 1
	j while			#Saltamos al inicio de la iteracion
	
	
salida:
	li $v0, 10		#Llamada al sistema para indicar el termino de ejecucion del programa
	syscall
