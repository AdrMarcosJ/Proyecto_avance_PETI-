import mysql.connector
from mysql.connector import Error
import hashlib

# Configuración de la base de datos
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'login_db'
}

def hash_password(password):
    """Encriptar contraseña usando SHA-256"""
    return hashlib.sha256(password.encode()).hexdigest()

def setup_database():
    """Configurar completamente la base de datos"""
    print("🔄 Configurando base de datos...")
    
    try:
        # Conectar a MySQL (sin especificar base de datos)
        connection = mysql.connector.connect(
            host=DB_CONFIG['host'],
            user=DB_CONFIG['user'],
            password=DB_CONFIG['password']
        )
        cursor = connection.cursor()
        
        # Crear base de datos si no existe
        cursor.execute("CREATE DATABASE IF NOT EXISTS login_db")
        print("✅ Base de datos 'login_db' creada/verificada")
        
        # Seleccionar la base de datos
        cursor.execute("USE login_db")
        
        # Crear tabla usuarios
        create_table_query = """
        CREATE TABLE IF NOT EXISTS usuarios (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
        """
        
        cursor.execute(create_table_query)
        print("✅ Tabla 'usuarios' creada/verificada")
        
        # Verificar si ya existe un usuario admin
        cursor.execute("SELECT COUNT(*) FROM usuarios WHERE username = 'admin'")
        admin_exists = cursor.fetchone()[0]
        
        if admin_exists == 0:
            # Crear usuario administrador
            admin_password = hash_password('admin123')
            insert_admin = """
            INSERT INTO usuarios (username, password, email) 
            VALUES (%s, %s, %s)
            """
            cursor.execute(insert_admin, ('admin', admin_password, 'admin@login.com'))
            print("✅ Usuario administrador creado")
            print("   👤 Usuario: admin")
            print("   🔑 Contraseña: admin123")
        else:
            print("ℹ️ Usuario administrador ya existe")
        
        # Confirmar cambios
        connection.commit()
        
        # Mostrar usuarios existentes
        cursor.execute("SELECT id, username, email, created_at FROM usuarios")
        usuarios = cursor.fetchall()
        
        print(f"\n📋 Usuarios en la base de datos ({len(usuarios)}):")
        for usuario in usuarios:
            print(f"   ID: {usuario[0]}, Usuario: {usuario[1]}, Email: {usuario[2]}")
        
        cursor.close()
        connection.close()
        
        print("\n🎉 ¡Base de datos configurada exitosamente!")
        return True
        
    except Error as e:
        print(f"❌ Error configurando base de datos: {e}")
        return False

def test_connection():
    """Probar conexión a la base de datos configurada"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor()
        
        cursor.execute("SELECT COUNT(*) FROM usuarios")
        count = cursor.fetchone()[0]
        
        print(f"✅ Conexión exitosa - {count} usuarios en la base de datos")
        
        cursor.close()
        connection.close()
        return True
        
    except Error as e:
        print(f"❌ Error probando conexión: {e}")
        return False

if __name__ == "__main__":
    print("🛠️ Configuración de Base de Datos para Sistema de Login\n")
    
    if setup_database():
        print("\n🧪 Probando conexión final...")
        test_connection()
        print("\n✅ ¡Todo listo! Ahora puedes ejecutar: python app.py")
    else:
        print("\n❌ Hubo problemas en la configuración. Revisa los errores arriba.")