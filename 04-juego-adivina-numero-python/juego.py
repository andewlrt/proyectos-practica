import random

def juego_adivina_numero():
    print("=" * 40)
    print("   🎮 JUEGO: ADIVINA EL NÚMERO")
    print("=" * 40)
    
    print("\nElige la dificultad:")
    print("1. Fácil (1-50, 10 intentos)")
    print("2. Medio (1-100, 7 intentos)")
    print("3. Difícil (1-200, 5 intentos)")
    
    opcion = input("\nElige una opción (1/2/3): ")
    
    if opcion == "1":
        limite = 50
        intentos_maximos = 10
        dificultad = "Fácil"
    elif opcion == "2":
        limite = 100
        intentos_maximos = 7
        dificultad = "Medio"
    elif opcion == "3":
        limite = 200
        intentos_maximos = 5
        dificultad = "Difícil"
    else:
        print("Opción no válida, se usará dificultad Media")
        limite = 100
        intentos_maximos = 7
        dificultad = "Medio"
    
    numero_secreto = random.randint(1, limite)
    intentos = 0
    adivinado = False
    
    print(f"\n✅ Dificultad: {dificultad}")
    print(f"Adivina un número entre 1 y {limite}")
    print(f"Tienes {intentos_maximos} intentos\n")
    
    while intentos < intentos_maximos and not adivinado:
        intentos_restantes = intentos_maximos - intentos
        print(f"Intentos restantes: {intentos_restantes}")
        
        try:
            guess = int(input(f"Intento {intentos + 1}: Ingresa un número: "))
        except ValueError:
            print("❌ Por favor ingresa un número válido\n")
            continue
        
        intentos += 1
        
        if guess < 1 or guess > limite:
            print(f"⚠️  El número debe estar entre 1 y {limite}\n")
            intentos -= 1  # no contar este intento
            continue
        
        if guess == numero_secreto:
            adivinado = True
        elif guess < numero_secreto:
            diferencia = numero_secreto - guess
            if diferencia > 20:
                print("🔥 Muy bajo! El número es bastante más grande\n")
            else:
                print("📈 Un poco bajo, vas bien!\n")
        else:
            diferencia = guess - numero_secreto
            if diferencia > 20:
                print("❄️  Muy alto! El número es bastante más pequeño\n")
            else:
                print("📉 Un poco alto, casi!\n")
    
    print("\n" + "=" * 40)
    if adivinado:
        print(f"🎉 ¡FELICITACIONES! ¡Adivinaste!")
        print(f"El número era: {numero_secreto}")
        print(f"Lo lograste en {intentos} intento(s)")
        
        # Calcular puntaje
        puntaje = (intentos_maximos - intentos + 1) * 10
        print(f"Tu puntaje: {puntaje} puntos")
    else:
        print(f"😢 Se acabaron los intentos!")
        print(f"El número secreto era: {numero_secreto}")
    
    print("=" * 40)
    
    jugar_de_nuevo = input("\n¿Quieres jugar otra vez? (s/n): ")
    if jugar_de_nuevo.lower() == 's':
        juego_adivina_numero()
    else:
        print("\n¡Hasta luego! 👋")

# Ejecutar el juego
juego_adivina_numero()
