import json
import os

ARCHIVO = "contactos.json"

def cargar_contactos():
    if os.path.exists(ARCHIVO):
        with open(ARCHIVO, "r", encoding="utf-8") as f:
            return json.load(f)
    return []

def guardar_contactos(contactos):
    with open(ARCHIVO, "w", encoding="utf-8") as f:
        json.dump(contactos, f, ensure_ascii=False, indent=2)

def mostrar_menu():
    print("\n" + "=" * 35)
    print("      📱 AGENDA DE CONTACTOS")
    print("=" * 35)
    print("1. Ver todos los contactos")
    print("2. Agregar contacto")
    print("3. Buscar contacto")
    print("4. Editar contacto")
    print("5. Eliminar contacto")
    print("6. Salir")
    print("=" * 35)

def ver_contactos(contactos):
    if not contactos:
        print("\n📭 No hay contactos guardados.")
        return

    print(f"\n📋 Tienes {len(contactos)} contacto(s):\n")
    for i, c in enumerate(contactos, 1):
        print(f"{i}. {c['nombre']} {c['apellido']}")
        print(f"   📞 {c['telefono']}")
        if c.get('email'):
            print(f"   ✉️  {c['email']}")
        if c.get('ciudad'):
            print(f"   📍 {c['ciudad']}")
        print()

def agregar_contacto(contactos):
    print("\n➕ AGREGAR NUEVO CONTACTO")
    print("-" * 25)

    nombre = input("Nombre: ").strip()
    if not nombre:
        print("❌ El nombre es obligatorio")
        return contactos

    apellido = input("Apellido: ").strip()
    telefono = input("Teléfono: ").strip()

    if not telefono:
        print("❌ El teléfono es obligatorio")
        return contactos

    email = input("Email (opcional, presiona Enter para saltar): ").strip()
    ciudad = input("Ciudad (opcional, presiona Enter para saltar): ").strip()

    # Verificar si el teléfono ya existe
    for c in contactos:
        if c['telefono'] == telefono:
            print(f"⚠️  Ya existe un contacto con ese teléfono: {c['nombre']} {c['apellido']}")
            return contactos

    nuevo = {
        "id": len(contactos) + 1,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "email": email,
        "ciudad": ciudad
    }

    contactos.append(nuevo)
    guardar_contactos(contactos)
    print(f"\n✅ Contacto '{nombre} {apellido}' guardado!")
    return contactos

def buscar_contacto(contactos):
    if not contactos:
        print("\n📭 No hay contactos para buscar.")
        return

    termino = input("\n🔍 Buscar por nombre, apellido o teléfono: ").strip().lower()

    if not termino:
        return

    encontrados = []
    for c in contactos:
        if (termino in c['nombre'].lower() or
            termino in c['apellido'].lower() or
            termino in c['telefono']):
            encontrados.append(c)

    if encontrados:
        print(f"\nSe encontraron {len(encontrados)} resultado(s):\n")
        for c in encontrados:
            print(f"👤 {c['nombre']} {c['apellido']}")
            print(f"   📞 {c['telefono']}")
            if c.get('email'):
                print(f"   ✉️  {c['email']}")
            if c.get('ciudad'):
                print(f"   📍 {c['ciudad']}")
            print()
    else:
        print(f"\n❌ No se encontraron contactos con '{termino}'")

def editar_contacto(contactos):
    if not contactos:
        print("\n📭 No hay contactos.")
        return contactos

    ver_contactos(contactos)
    try:
        num = int(input("Número del contacto a editar (0 para cancelar): "))
        if num == 0:
            return contactos
        if num < 1 or num > len(contactos):
            print("❌ Número inválido")
            return contactos
    except ValueError:
        print("❌ Ingresa un número válido")
        return contactos

    contacto = contactos[num - 1]
    print(f"\n✏️  Editando: {contacto['nombre']} {contacto['apellido']}")
    print("(Presiona Enter para mantener el valor actual)")

    nuevo_nombre = input(f"Nombre [{contacto['nombre']}]: ").strip()
    nuevo_apellido = input(f"Apellido [{contacto['apellido']}]: ").strip()
    nuevo_telefono = input(f"Teléfono [{contacto['telefono']}]: ").strip()
    nuevo_email = input(f"Email [{contacto.get('email', '')}]: ").strip()
    nueva_ciudad = input(f"Ciudad [{contacto.get('ciudad', '')}]: ").strip()

    if nuevo_nombre:
        contacto['nombre'] = nuevo_nombre
    if nuevo_apellido:
        contacto['apellido'] = nuevo_apellido
    if nuevo_telefono:
        contacto['telefono'] = nuevo_telefono
    if nuevo_email:
        contacto['email'] = nuevo_email
    if nueva_ciudad:
        contacto['ciudad'] = nueva_ciudad

    guardar_contactos(contactos)
    print("\n✅ Contacto actualizado!")
    return contactos

def eliminar_contacto(contactos):
    if not contactos:
        print("\n📭 No hay contactos.")
        return contactos

    ver_contactos(contactos)
    try:
        num = int(input("Número del contacto a eliminar (0 para cancelar): "))
        if num == 0:
            return contactos
        if num < 1 or num > len(contactos):
            print("❌ Número inválido")
            return contactos
    except ValueError:
        print("❌ Ingresa un número válido")
        return contactos

    contacto = contactos[num - 1]
    confirmar = input(f"¿Seguro que quieres eliminar a '{contacto['nombre']} {contacto['apellido']}'? (s/n): ")

    if confirmar.lower() == 's':
        contactos.pop(num - 1)
        guardar_contactos(contactos)
        print("✅ Contacto eliminado")
    else:
        print("Operación cancelada")

    return contactos

def main():
    print("\nBienvenido a tu Agenda Personal")
    contactos = cargar_contactos()

    while True:
        mostrar_menu()
        opcion = input("Elige una opción: ").strip()

        if opcion == "1":
            ver_contactos(contactos)
        elif opcion == "2":
            contactos = agregar_contacto(contactos)
        elif opcion == "3":
            buscar_contacto(contactos)
        elif opcion == "4":
            contactos = editar_contacto(contactos)
        elif opcion == "5":
            contactos = eliminar_contacto(contactos)
        elif opcion == "6":
            print("\n👋 ¡Hasta luego!")
            break
        else:
            print("❌ Opción no válida, elige entre 1 y 6")

main()
