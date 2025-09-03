import mysql.connector

def conectar_bd(host, usuario, clave, base_datos=None):
    try:
        # Conexión a la base de datos
        if base_datos:
            conexion = mysql.connector.connect(
                host=host,
                user=usuario,
                passwd=clave,
                database=base_datos
            )
        else:
            # Conectar sin especificar base de datos
            conexion = mysql.connector.connect(
                host=host,
                user=usuario,
                passwd=clave
            )
        print("✅ Conexión exitosa a MySQL")
        return conexion
    except mysql.connector.Error as error:
        print("❌ Error al conectar a MySQL:", error)
        return None

def crear_base_datos(conexion, nombre_bd):
    """Crear base de datos si no existe"""
    try:
        cursor = conexion.cursor()
        cursor.execute(f"CREATE DATABASE IF NOT EXISTS {nombre_bd}")
        print(f"✅ Base de datos '{nombre_bd}' creada/verificada")
        cursor.close()
        return True
    except mysql.connector.Error as error:
        print(f"❌ Error creando base de datos: {error}")
        return False

def listar_bases_datos(conexion):
    """Listar todas las bases de datos"""
    try:
        cursor = conexion.cursor()
        cursor.execute("SHOW DATABASES")
        databases = cursor.fetchall()
        print("📋 Bases de datos disponibles:")
        for db in databases:
            print(f"   - {db[0]}")
        cursor.close()
    except mysql.connector.Error as error:
        print(f"❌ Error listando bases de datos: {error}")

if __name__ == "__main__":
    # Configuración para XAMPP (por defecto sin contraseña)
    host = "localhost"
    usuario = "root"
    clave = ""  # XAMPP por defecto NO tiene contraseña
    base_datos = "login_db"  # Cambiado a un nombre más apropiado
    
    print("🔄 Intentando conectar a MySQL...")
    
    # Primero conectar sin especificar base de datos
    conexion = conectar_bd(host, usuario, clave)
    
    if conexion:
        # Listar bases de datos existentes
        listar_bases_datos(conexion)
        
        # Crear la base de datos si no existe
        crear_base_datos(conexion, base_datos)
        
        # Cerrar conexión inicial
        conexion.close()
        
        # Ahora conectar a la base de datos específica
        print(f"\n🔄 Conectando a la base de datos '{base_datos}'...")
        conexion_bd = conectar_bd(host, usuario, clave, base_datos)
        
        if conexion_bd:
            print("🎉 ¡Todo funcionando correctamente!")
            conexion_bd.close()
    else:
        print("\n🔧 Opciones para solucionar:")
        print("1. Verificar que XAMPP MySQL esté iniciado")
        print("2. Probar con contraseña vacía: clave = ''")
        print("3. Probar con contraseña '123456': clave = '123456'")
        print("4. Verificar desde phpMyAdmin (http://localhost/phpmyadmin)")