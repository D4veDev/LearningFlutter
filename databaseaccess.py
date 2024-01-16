
import mysql.connector

# Replace these with your actual MySQL server credentials
host = 'mydatabase.cr8csc4s4i51.eu-north-1.rds.amazonaws.com'
user = 'admin'
password = 'databasepass'
database = 'chinese'

# Establish a connection to the MySQL server
try:
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    if connection.is_connected():
        print("Connected to MySQL Server")

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # Example: Execute a simple SELECT query
        cursor.execute("SELECT * FROM chinese.foods")
        rows = cursor.fetchall()
        print("Fetched data:")
        for row in rows:
            print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")

finally:
    # Close the cursor and connection in the finally block to ensure proper cleanup
    if 'cursor' in locals() and cursor is not None:
        cursor.close()
    if 'connection' in locals() and connection.is_connected():
        connection.close()
        print("Connection closed")
