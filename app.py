from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error
import hashlib
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'mi_clave_secreta_super_segura_2024'

# Configuración de la base de datos (basada en tu testBD.py exitoso)
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',  # Sin contraseña como en XAMPP
    'database': 'login_db'
}

class DatabaseManager:
    def __init__(self):
        self.config = DB_CONFIG
    
    def get_connection(self):
        """Obtener conexión a la base de datos"""
        try:
            connection = mysql.connector.connect(**self.config)
            return connection
        except Error as e:
            print(f"❌ Error de conexión: {e}")
            return None
    
    def execute_query(self, query, params=None):
        """Ejecutar consulta que no retorna datos (INSERT, UPDATE, DELETE)"""
        connection = self.get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute(query, params)
                connection.commit()
                result = cursor.rowcount
                cursor.close()
                connection.close()
                return result
            except Error as e:
                print(f"❌ Error ejecutando consulta: {e}")
                return False
        return False
    
    def fetch_query(self, query, params=None):
        """Ejecutar consulta que retorna datos (SELECT)"""
        connection = self.get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute(query, params)
                result = cursor.fetchall()
                cursor.close()
                connection.close()
                return result
            except Error as e:
                print(f"❌ Error en consulta SELECT: {e}")
                return []
        return []
    
    def fetch_one(self, query, params=None):
        """Ejecutar consulta que retorna un solo resultado"""
        connection = self.get_connection()
        if connection:
            try:
                cursor = connection.cursor()
                cursor.execute(query, params)
                result = cursor.fetchone()
                cursor.close()
                connection.close()
                return result
            except Error as e:
                print(f"❌ Error en consulta SELECT: {e}")
                return None
        return None

# Instancia del gestor de base de datos
db = DatabaseManager()

def hash_password(password):
    """Encriptar contraseña usando SHA-256"""
    return hashlib.sha256(password.encode()).hexdigest()

@app.route('/')
def home():
    """Página principal"""
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Sistema de login"""
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        
        if not username or not password:
            flash('Por favor, ingresa usuario y contraseña', 'error')
            return render_template('login.html')
        
        hashed_password = hash_password(password)
        
        # Verificar usuario en la base de datos
        query = "SELECT id, username, email FROM usuarios WHERE username = %s AND password = %s"
        result = db.fetch_one(query, (username, hashed_password))
        
        if result:
            session['user_id'] = result[0]
            session['username'] = result[1]
            session['email'] = result[2]
            flash(f'¡Bienvenido, {result[1]}!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Usuario o contraseña incorrectos', 'error')
    
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    """Sistema de registro"""
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        confirm_password = request.form.get('confirm_password', '')
        email = request.form.get('email', '').strip()
        
        # Validaciones
        if not all([username, password, email]):
            flash('Todos los campos son obligatorios', 'error')
            return render_template('register.html')
        
        if password != confirm_password:
            flash('Las contraseñas no coinciden', 'error')
            return render_template('register.html')
        
        if len(password) < 6:
            flash('La contraseña debe tener al menos 6 caracteres', 'error')
            return render_template('register.html')
        
        # Verificar si el usuario ya existe
        check_query = "SELECT id FROM usuarios WHERE username = %s OR email = %s"
        existing = db.fetch_one(check_query, (username, email))
        
        if existing:
            flash('El usuario o email ya existe', 'error')
            return render_template('register.html')
        
        # Insertar nuevo usuario
        hashed_password = hash_password(password)
        insert_query = "INSERT INTO usuarios (username, password, email, created_at) VALUES (%s, %s, %s, %s)"
        
        if db.execute_query(insert_query, (username, hashed_password, email, datetime.now())):
            flash('¡Usuario registrado exitosamente! Ahora puedes iniciar sesión', 'success')
            return redirect(url_for('login'))
        else:
            flash('Error al registrar usuario. Inténtalo de nuevo', 'error')
    
    return render_template('register.html')

@app.route('/dashboard')
def dashboard():
    """Panel de usuario (requiere login)"""
    if 'user_id' not in session:
        flash('Debes iniciar sesión para acceder', 'error')
        return redirect(url_for('login'))
    
    # Obtener información adicional del usuario
    query = "SELECT username, email, created_at FROM usuarios WHERE id = %s"
    user_info = db.fetch_one(query, (session['user_id'],))
    
    return render_template('dashboard.html', user_info=user_info)

@app.route('/logout')
def logout():
    """Cerrar sesión"""
    username = session.get('username', 'Usuario')
    session.clear()
    flash(f'¡Hasta luego, {username}!', 'info')
    return redirect(url_for('home'))

@app.route('/usuarios')
def listar_usuarios():
    """Listar todos los usuarios (solo para administradores)"""
    if 'user_id' not in session:
        flash('Debes iniciar sesión para acceder', 'error')
        return redirect(url_for('login'))
    
    query = "SELECT id, username, email, created_at FROM usuarios ORDER BY created_at DESC"
    usuarios = db.fetch_query(query)
    
    return render_template('usuarios.html', usuarios=usuarios)

def create_users_table():
    """Crear tabla de usuarios si no existe"""
    query = """
    CREATE TABLE IF NOT EXISTS usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
    """
    
    if db.execute_query(query):
        print("✅ Tabla usuarios creada/verificada correctamente")
        
        # Crear usuario administrador por defecto si no existe
        admin_check = db.fetch_one("SELECT id FROM usuarios WHERE username = 'admin'")
        if not admin_check:
            admin_password = hash_password('admin123')
            admin_query = "INSERT INTO usuarios (username, password, email) VALUES (%s, %s, %s)"
            if db.execute_query(admin_query, ('admin', admin_password, 'admin@login.com')):
                print("✅ Usuario administrador creado (usuario: admin, contraseña: admin123)")
    else:
        print("❌ Error al crear la tabla usuarios")

if __name__ == '__main__':
    print("🚀 Iniciando aplicación Flask...")
    create_users_table()
    print("🌐 Servidor corriendo en: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)