#Importando Libreria mysql.connector para conectar Python con MySQL
import mysql.connector

def connectionBD():
    mydb = mysql.connector.connect(
        host ="localhost", # O la dirección IP del contenedor si no está en localhost
        port='3306',       # Puerto por defecto de MySQL
        user ="root",       # Usuario de la base de datos
        passwd ="",         # Contraseña del usuario
        database = "PETI"   # Nombre de la base de datos
        )
    return mydb
    '''       
    if mydb:
        return ("Conexion exitosa")
    else:
        return ("Error en la conexion a BD")
    '''
    
    #resultado = connectionBD()
    #print(resultado)
