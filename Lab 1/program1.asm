.data

.text

	#considerando  a = $s0, z = $s1
	
	#inicializaciones
	add $s0, $zero, $zero	#Inicializacion a=0
	addi $s1, $zero, 1	#Inicializacion z=1
	addi $t0, $zero, 10	#Incializacion var temp con 10 para las iteraciones
	
while:
	beq $s1, $t0, salida	#Consideramos el caso contrario de z <> 10,  luego, 
				#  solo si z==10, es decir, $s1==$t0, voy al label salida,
				#  en caso contrario sigo con las instrucciones siguientes
	add $s0, $s0, $s1	#Al registro de a se le suma el valor de z. $s0 = $s0+$s1
	addi $s1, $s1, 1	#Se suma 1 al registro del valor de z. $s1 = $s1+1
	j while			#Salto al inicio de la iteracion, al label while, 
				#  porque no se ha cumplido la condicion de salida
	
	
salida:
	li $v0, 10		#Llamada al sistema para indicar el termino de ejecucion
	syscall			#  del programa
