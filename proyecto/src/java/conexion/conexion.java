package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
// Removido JOptionPane para compatibilidad web

/**
 * Clase para manejar la conexión a la base de datos MySQL
 * Compatible con HeidiSQL y otros clientes MySQL
 * 
 * @author Mi Equipo
 */
public class conexion {
    
    // Parámetros de conexión - Ajusta estos valores según tu configuración
    private static final String SERVIDOR = "161.132.4.240"; // o la IP de tu servidor
    private static final String PUERTO = "3306"; // Puerto por defecto de MySQL
    private static final String BASE_DATOS = "sistema_peti";
    private static final String USUARIO = "admin"; // Cambia por tu usuario
    private static final String PASSWORD = "Upt2025"; // Cambia por tu contraseña
    
    // URL completa de conexión
    private static final String URL = "jdbc:mysql://" + SERVIDOR + ":" + PUERTO + "/" + BASE_DATOS 
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    
    private static Connection conexion = null;
    
    /**
     * Método para establecer la conexión a la base de datos
     * @return Connection - objeto de conexión o null si falla
     */
    public static Connection getConexion() {
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer la conexión
            conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
            
            System.out.println("✓ Conexión exitosa a la base de datos: " + BASE_DATOS);
            return conexion;
            
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Error: Driver MySQL no encontrado");
            System.err.println("Asegúrate de tener mysql-connector-java en el classpath");
            return null;
            
        } catch (SQLException e) {
            System.err.println("✗ Error de conexión a la base de datos:");
            System.err.println("Código de error: " + e.getErrorCode());
            System.err.println("Mensaje: " + e.getMessage());
            
            System.err.println("Verifica:");
            System.err.println("• Que MySQL esté ejecutándose");
            System.err.println("• Usuario y contraseña correctos");
            System.err.println("• Que la base de datos '" + BASE_DATOS + "' exista");
            return null;
        }
    }
    
    /**
     * Método para cerrar la conexión
     */
    public static void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                System.out.println("✓ Conexión cerrada correctamente");
            }
        } catch (SQLException e) {
            System.err.println("✗ Error al cerrar la conexión: " + e.getMessage());
        }
    }
    
    /**
     * Método para verificar si la conexión está activa
     * @return boolean - true si está conectado, false si no
     */
    public static boolean isConectado() {
        try {
            return conexion != null && !conexion.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
    
    /**
     * Método para probar la conexión
     * Útil para verificar que todo funciona correctamente
     */
    public static void probarConexion() {
        System.out.println("=== PROBANDO CONEXIÓN A LA BASE DE DATOS ===");
        System.out.println("Servidor: " + SERVIDOR + ":" + PUERTO);
        System.out.println("Base de datos: " + BASE_DATOS);
        System.out.println("Usuario: " + USUARIO);
        System.out.println("==========================================");
        
        Connection conn = getConexion();
        if (conn != null) {
            System.out.println("🎉 ¡Conexión exitosa!");
            cerrarConexion();
        } else {
            System.out.println("💥 Falló la conexión");
        }
    }
    
    // Método main para pruebas rápidas
    public static void main(String[] args) {
        probarConexion();
    }
}