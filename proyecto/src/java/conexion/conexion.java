package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class conexion {

    private static Connection conexion = null;

    public static Connection getConexion() {
        // --- INICIO DE LA MODIFICACIÓN ---

        // 1. Definir los valores por defecto para el entorno local (localhost)
        // CAMBIA ESTOS VALORES SEGÚN TU CONFIGURACIÓN LOCAL
        String localHost = "localhost";
        String localPort = "3306";
        String localDbName = "sistema_peti"; // O el nombre de tu BD local
        String localUser = "root";           // Tu usuario local, usualmente "root"
        String localPassword = "";  // La contraseña de tu MySQL local

        // 2. Intentar leer las variables de entorno de Azure
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");

        // 3. Decidir qué configuración usar (Lógica de Fallback)
        // Si la variable de entorno es nula, usa el valor local por defecto.
        if (dbHost == null) {
            System.out.println("INFO: No se encontró la variable de entorno DB_HOST. Usando configuración local (localhost).");
            dbHost = localHost;
            dbPort = localPort;
            dbName = localDbName;
            dbUser = localUser;
            dbPassword = localPassword;
        } else {
            System.out.println("INFO: Variable de entorno DB_HOST encontrada. Usando configuración de Azure.");
        }

        // --- FIN DE LA MODIFICACIÓN ---

        // Construye la URL de conexión (esto no cambia)
        String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName
                     + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection(url, dbUser, dbPassword);
            System.out.println("✓ Conexión exitosa a la base de datos: " + dbName);
            return conexion;

        } catch (ClassNotFoundException e) {
            System.err.println("✗ Error: Driver MySQL no encontrado. Asegúrate de tener mysql-connector-java en el classpath.");
            return null;

        } catch (SQLException e) {
            System.err.println("✗ Error de conexión a la base de datos:");
            System.err.println("Mensaje: " + e.getMessage());
            System.err.println("Verifica que los datos de conexión para '" + dbHost + "' sean correctos.");
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
        // Lee la configuración desde las variables de entorno para poder mostrarlas
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String dbUser = System.getenv("DB_USER");

        System.out.println("=== PROBANDO CONEXIÓN A LA BASE DE DATOS ===");
        System.out.println("Servidor: " + dbHost + ":" + dbPort);
        System.out.println("Base de datos: " + dbName);
        System.out.println("Usuario: " + dbUser);
        System.out.println("==========================================");

        Connection conn = getConexion();
        if (conn != null) {
            System.out.println("🎉 ¡Conexión exitosa!");
            cerrarConexion();
        } else {
            System.out.println("💥 Falló la conexión");
        }
    }
    
    /**
     * Método main para pruebas rápidas.
     * Para que funcione localmente, debes configurar las variables de entorno
     * en tu IDE (Eclipse, IntelliJ, etc.).
     */
    public static void main(String[] args) {
        // NOTA: Para que esto funcione en tu PC, debes configurar las variables
        // de entorno (DB_HOST, DB_USER, etc.) en la configuración de ejecución
        // de tu IDE. En Azure, esto ya está configurado.
        probarConexion();
    }
}